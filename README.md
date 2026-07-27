# Openfire Client Control Plugin

Allows to specify XMPP clients that are allowed to connect to the server, which Spark features are enabled and control which Spark version should be used by clients.

**Note for developers**, on 29 October 2020 this repository was rewritten to remove legacy and unrelated Openfire commit history.  See [forums post](https://discourse.igniterealtime.org/t/89049) for more details.  This repository was susquently rewritten again on 1 December 2020 to remove and additional bad commit circa 2013.

## CI Build Status

[![Build Status](https://github.com/igniterealtime/openfire-clientControl-plugin/workflows/Java%20CI/badge.svg)](https://github.com/igniterealtime/openfire-clientControl-plugin/actions)

## Architecture-specific Spark packages

The existing `spark.<os>.client` properties remain the defaults. Newer Spark clients can additionally request a package that matches their runtime architecture. The plugin recognizes `windows`, `mac` and `linux` together with `x86`, `x64` and `arm64`.

For example:

- `spark.windows.x86.client`
- `spark.windows.x64.client`
- `spark.windows.arm64.client`
- `spark.mac.x64.client`
- `spark.mac.arm64.client`
- `spark.linux.x86.client`
- `spark.linux.x64.client`
- `spark.linux.arm64.client`

If an architecture-specific property is absent or blank, the plugin falls back to the corresponding generic property, such as `spark.windows.client`, `spark.mac.client` or `spark.linux.client`. This keeps existing deployments and older Spark clients compatible.

## Reporting Issues

Issues may be reported to the [forums](https://discourse.igniterealtime.org) or via this repo's [Github Issues](https://github.com/igniterealtime/openfire-clientControl-plugin).
