# Provenance and licensing

This file records where the code, the design references, and the test data of
`moon-mqtt` come from.

## Origin of the source code

All MoonBit source under `protocol/`, `session/`, `core/`, `transport/`,
`client/`, `browser/`, `async/`, `examples/`, and `scripts/` was written for this
project. No source file was copied from another project.

`transport/tcp_stub.c` is a thin C FFI shim for TCP sockets (about 180 lines,
four functions plus Winsock initialisation). It was written for this repository;
it follows the same FFI boundary convention used in `moon-hive` (same author's
project), without copying code from it.

## Design and protocol references

| Reference | License | What was taken |
|---|---|---|
| OASIS MQTT 3.1.1 specification | OASIS open standard | Protocol semantics: packet layout, QoS handshakes, session state, keep-alive. Implemented from the specification text. |
| MQTT.js | MIT | API naming and shape only (for example `connect` / `subscribe` / `publish` / `on_message`). No code copied. |
| Eclipse Paho MQTT C | EPL-2.0 / EDL-1.0 | Behaviour cross-check (what a mature client does on the same packet sequence). No code copied. |

The project is MIT-licensed. It does not include or modify MQTT.js or Paho
sources, so their licences do not flow into this repository.

## Test data

- All packet fixtures in the tests are encoded by hand in the test files from
  the MQTT 3.1.1 packet layout.
- The `client/client_wbtest.mbt` tests use a scripted fake connection; the byte
  sequences are written in the test file.
- No third-party capture, corpus, or dataset is included.

## AI assistance

AI coding tools were used for boilerplate, test drafts, and documentation
drafts. The protocol decisions, the layering, the error-boundary choices, and
the final review were done by the author. AI-generated tests were checked
against the specification before being kept. See the "AI tool usage" section of
`README.md`.

## Identity

All commits are authored by `Duckweed-yhb <3071974740@qq.com>`, the same person
who registered the project. No other person's name, account, or identity is used.

## Licence

MIT. See `LICENSE`.
