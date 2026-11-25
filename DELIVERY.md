# 发布与验证

在 MoonBit 工程中运行 `moon add Duckweed/moon-mqtt@0.3.17` 安装此版本。

## 从源码复现

在仓库根目录运行以下命令。

```sh
moon fmt --check
moon check --target native --deny-warn
moon test --target native
python scripts/check_cli_loopback.py
```

使用回环 TCP 对端验证命令行发布与订阅。会话恢复示例可用 `moon run examples/resume --target native` 运行，核对 QoS 2 重放及确认后的在途记录。

[使用说明](README.md) · [版本记录](CHANGELOG.md) · [代码与数据来源](PROVENANCE.md)
