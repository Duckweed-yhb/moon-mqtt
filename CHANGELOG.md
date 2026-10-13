# Changelog

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- 项目骨架（`moon.mod` / `moon.pkg` / CI / LICENSE / README）。
- `protocol/` 包：MQTT 3.1.1 报文编解码（纯计算，四后端），包括：
  - QoS 类型与固定头、剩余长度变长编解码
  - CONNECT 编码 / CONNACK 解码（返回码、session present）
  - PUBLISH 编解码 + QoS1/2 握手控制包（PUBACK/PUBREC/PUBREL/PUBCOMP）
  - SUBSCRIBE/SUBACK、UNSUBSCRIBE/UNSUBACK
  - PINGREQ/PINGRESP/DISCONNECT
  - Topic 过滤器匹配（`+` 单层、`#` 多层）
  - 统一入站分发 `decode_packet`
- `session/` 包：QoS2 exactly-once 会话状态机（纯计算，四后端）：
  - 报文标识分配器（1..65535 循环）
  - 发布侧 / 接收侧 QoS2 握手（PUBREC/PUBREL/PUBCOMP）
  - 重复 PUBREC 重发 PUBREL、乱序 PUBREL 忽略等边界
