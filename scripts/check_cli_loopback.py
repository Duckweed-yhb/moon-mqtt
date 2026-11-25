"""Exercise the native CLI against a scripted MQTT 3.1.1 peer on loopback."""
import socket
import subprocess
from concurrent.futures import ThreadPoolExecutor


TOPIC = b"demo/temperature"
PAYLOAD = "23.5 °C".encode()
# Cross the native 16 KiB read boundary and finish with a multibyte character.
LARGE_PAYLOAD = b"A" * 16384 + "温度".encode()


def remaining_length(size):
    encoded = bytearray()
    while True:
        size, digit = divmod(size, 128)
        encoded.append(digit | (128 if size else 0))
        if not size:
            return bytes(encoded)


def frame(stream, header):
    first = stream.read(1)
    assert first == bytes([header]), (first, header)
    size = 0
    for shift in range(0, 28, 7):
        digit = stream.read(1)[0]
        size += (digit & 127) << shift
        if digit < 128:
            body = stream.read(size)
            assert len(body) == size
            return body
    raise AssertionError("invalid remaining length")


def exchange(listener, mode):
    conn, _ = listener.accept()
    with conn, conn.makefile("rb") as stream:
        conn.settimeout(10)
        assert frame(stream, 0x10).startswith(b"\x00\x04MQTT\x04")
        conn.sendall(b"\x20\x02\x00\x00")
        topic = len(TOPIC).to_bytes(2, "big") + TOPIC
        if mode == "pub":
            body = frame(stream, 0x32)
            assert body.startswith(topic) and body[len(topic) + 2:] == PAYLOAD
            pid = body[len(topic):len(topic) + 2]
            assert pid != b"\x00\x00"
            conn.sendall(b"\x40\x02" + pid)
        else:
            body = frame(stream, 0x82)
            assert body[2:] == topic + b"\x01"
            if mode == "eof":
                conn.sendall(b"\x90\x03" + body[:2] + b"\x01")
                return
            publish = topic + b"\x00\x07" + LARGE_PAYLOAD
            conn.sendall(b"\x32" + remaining_length(len(publish)))
            conn.sendall(publish)
            assert frame(stream, 0x40) == b"\x00\x07"
            conn.sendall(b"\x90\x03" + body[:2] + b"\x01")
        assert frame(stream, 0xE0) == b""


def check(mode, family=socket.AF_INET, client_host=None):
    with socket.socket(family) as listener, ThreadPoolExecutor(1) as worker:
        address = "::1" if family == socket.AF_INET6 else "127.0.0.1"
        try:
            listener.bind((address, 0))
        except OSError:
            if family != socket.AF_INET6:
                raise
            print("IPv6 loopback unavailable on this host")
            return
        listener.listen(1)
        listener.settimeout(30)
        peer = worker.submit(exchange, listener, mode)
        arg = PAYLOAD.decode() if mode == "pub" else "--once"
        cli = subprocess.run(
            ["moon", "run", "cmd/moon-mqtt", "--target", "native", "--", "sub" if mode == "eof" else mode,
             client_host or address, str(listener.getsockname()[1]), TOPIC.decode(), arg],
            capture_output=True, encoding="utf-8", timeout=40,
        )
        peer.result()
        if mode == "eof":
            assert cli.returncode != 0, cli.stdout
            assert "TCP read: EOF" in cli.stdout, cli.stdout
            print("sub: reported EOF when peer closed after SUBACK")
            return
        assert cli.returncode == 0, (cli.stdout, cli.stderr)
        expected = "PUBACK " + TOPIC.decode() if mode == "pub" else TOPIC.decode() + " " + LARGE_PAYLOAD.decode()
        assert expected in cli.stdout.splitlines(), cli.stdout
        print(f"{mode} ({client_host or address}): verified CLI output and wire acknowledgements")


if __name__ == "__main__":
    check("pub")
    check("sub")
    check("eof")
    check("pub", client_host="localhost")
    if socket.has_ipv6:
        check("pub", socket.AF_INET6)
