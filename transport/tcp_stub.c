/* ============================================================
 * moon-mqtt · transport — 原生 TCP socket（C FFI 存根）
 *
 * 职责：建立 TCP 连接、读写原始字节、关闭连接。
 * 只做字节搬运，不做 MQTT 协议语义（协议在 MoonBit 上层）。
 *
 * 字节经 moonbit_string_t 承载：每个 UTF-16 单元存一个 0-255 字节值，
 * 与 moon-hive platform/fs 的边界写法一致。
 *
 * 平台：Windows winsock2 / POSIX socket（Linux、macOS）。
 * ============================================================ */

#include "moonbit.h"
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#endif

/* 连接 host:port。host 可为 IP 或域名。返回 socket 句柄（转 int64）；
   失败返回 -1。 */
int64_t mqtt_tcp_connect(moonbit_string_t host, int32_t port) {
  int32_t hn = (int32_t)Moonbit_array_length(host);
  char hbuf[256];
  if (hn >= (int32_t)sizeof(hbuf)) {
    hn = (int32_t)sizeof(hbuf) - 1;
  }
  for (int32_t i = 0; i < hn; i++) {
    hbuf[i] = (char)(host[i] & 0xFF);
  }
  hbuf[hn] = 0;

  int32_t family = AF_INET;
  struct sockaddr_in sa;
  memset(&sa, 0, sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_port = htons((unsigned short)port);
  if (inet_pton(AF_INET, hbuf, &sa.sin_addr) != 1) {
    /* host 是域名：用 getaddrinfo 解析 */
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    char portstr[16];
    snprintf(portstr, sizeof(portstr), "%d", port);
    if (getaddrinfo(hbuf, portstr, &hints, &res) != 0 || res == NULL) {
      return -1;
    }
    sa = *(struct sockaddr_in *)res->ai_addr;
    freeaddrinfo(res);
    (void)family;
  }

#ifdef _WIN32
  static int32_t wsastart = -1;
  if (wsastart < 0) {
    WSADATA wsa;
    wsastart = (WSAStartup(MAKEWORD(2, 2), &wsa) == 0) ? 1 : 0;
  }
  if (wsastart != 1) {
    return -1;
  }
  SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock == INVALID_SOCKET) {
    return -1;
  }
  if (connect(sock, (struct sockaddr *)&sa, sizeof(sa)) != 0) {
    closesocket(sock);
    return -1;
  }
  return (int64_t)sock;
#else
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    return -1;
  }
  if (connect(sock, (struct sockaddr *)&sa, sizeof(sa)) != 0) {
    close(sock);
    return -1;
  }
  return (int64_t)sock;
#endif
}

/* 写入全部字节；循环 send/write 直到全部写完或出错。
   返回实际写入字节数（== n 表示全部写完）；失败返回 -1。 */
int32_t mqtt_tcp_write(int64_t fd, moonbit_string_t data) {
  int32_t n = (int32_t)Moonbit_array_length(data);
  if (n == 0) {
    return 0;
  }
  char *buf = (char *)malloc((size_t)n);
  if (buf == NULL) {
    return -1;
  }
  for (int32_t i = 0; i < n; i++) {
    buf[i] = (char)(data[i] & 0xFF);
  }
  int32_t total = 0;
  while (total < n) {
    int32_t sent;
#ifdef _WIN32
    sent = (int32_t)send((SOCKET)fd, buf + total, (size_t)(n - total), 0);
#else
    sent = (int32_t)write((int)fd, buf + total, (size_t)(n - total));
#endif
    if (sent < 0) {
      free(buf);
      return -1;
    }
    if (sent == 0) {
      /* 对端关闭 */
      break;
    }
    total += sent;
  }
  free(buf);
  return total;
}

/* 读最多 max 字节，返回 String（每单元一字节）。EOF/错误返回空串。 */
moonbit_string_t mqtt_tcp_read(int64_t fd, int32_t max) {
  if (max <= 0) {
    max = 4096;
  }
  char *buf = (char *)malloc((size_t)max);
  if (buf == NULL) {
    return moonbit_make_string(0, 0);
  }
  int32_t got;
#ifdef _WIN32
  got = (int32_t)recv((SOCKET)fd, buf, max, 0);
#else
  got = (int32_t)recv((int)fd, buf, (size_t)max, 0);
#endif
  if (got <= 0) {
    free(buf);
    return moonbit_make_string(0, 0);
  }
  moonbit_string_t out = moonbit_make_string(got, 0);
  for (int32_t i = 0; i < got; i++) {
    out[i] = (uint16_t)(unsigned char)buf[i];
  }
  free(buf);
  return out;
}

/* 关闭连接。 */
void mqtt_tcp_close(int64_t fd) {
#ifdef _WIN32
  closesocket((SOCKET)fd);
#else
  close((int)fd);
#endif
}

/* 等 socket 可读。
   返回：0 = 数据可读；-1 = 超时；-2 = 错误。 */
int32_t mqtt_tcp_wait_read(int64_t fd, int32_t timeout_ms) {
  fd_set rfds;
  struct timeval tv;
  FD_ZERO(&rfds);
  FD_SET((SOCKET)fd, &rfds);
  tv.tv_sec = timeout_ms / 1000;
  tv.tv_usec = (timeout_ms % 1000) * 1000;
#ifdef _WIN32
  int r = select(0, &rfds, NULL, NULL, &tv);
#else
  int r = select((int)fd + 1, &rfds, NULL, NULL, &tv);
#endif
  if (r < 0) return -2;
  if (r == 0) return -1;
  return 0;
}
