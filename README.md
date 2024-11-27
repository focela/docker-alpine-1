# Focela Alpine: Lightweight and Flexible Docker Image

[![GitHub release](https://img.shields.io/github/v/tag/focela/alpine?style=flat-square)](https://github.com/focela/alpine/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/focela/alpine/main.yml?branch=main&style=flat-square)](https://github.com/focela/alpine/actions)
[![Docker Stars](https://img.shields.io/docker/stars/focela/alpine.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/focela/alpine/)
[![Docker Pulls](https://img.shields.io/docker/pulls/focela/alpine.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/focela/alpine/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-focela-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/focela)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/focela)

---

## Table of Contents
1. [About](#about)
2. [Features](#features)
3. [Installation](#installation)
   - [Getting Started](#getting-started)
   - [Multi Architecture Support](#multi-architecture-support)
4. [Available Tags](#available-tags)
5. [Configuration](#configuration)
   - [Quick Start](#quick-start)
   - [Persistent Storage](#persistent-storage)
   - [Environment Variables](#environment-variables)
   - [Developing / Overriding](#developing--overriding)
6. [Debug Mode](#debug-mode)
7. [Support](#support)
8. [License](#license)

---

## About

A lightweight and flexible [Alpine Linux](https://www.alpinelinux.org/) container image optimized for various use cases such as monitoring, logging, scheduling, and security. This image integrates essential tools to simplify container management.

---

## Features

- **Init System**: [s6 overlay](https://github.com/just-containers/s6-overlay) for PID 1 init capabilities.
- **Monitoring**: Includes [Zabbix Agent](https://zabbix.org) (Classic and Modern) for container monitoring.
- **Scheduling**: Integrated `cron` for task automation.
- **Utilities**: Comes with helpful tools like `bash`, `curl`, `less`, `logrotate`, `nano`, and `vi`.
- **Messaging**: Built-in MSMTP for sending emails via an external SMTP server.
- **Firewall**: Configured with [Fail2ban](https://github.com/fail2ban/fail2ban) to block malicious hosts based on log analysis.
- **Logging**: Supports log shipping to remote servers using [Fluent-Bit](https://github.com/fluent/fluent-bit).
- **Permission Management**: Dynamically updates User ID and Group ID permissions.

---

## Installation

### Getting Started
You can use this image either by building it locally or pulling prebuilt images from trusted registries.

#### Build from Source
If you want to build the image locally:
```bash
docker build <arguments> (imagename) .
```

#### Prebuilt Images
Prebuilt images are available in the following registries:

- **Docker Hub**:
  ```bash
  docker pull docker.io/focela/alpine:(imagetag)
  ```

- **GitHub Container Registry**:
  ```bash
  docker pull ghcr.io/focela/alpine:(imagetag)
  ```

### Multi Architecture Support
This image is primarily built for `amd64` architecture. Variants for `arm/v7`, `arm64`, and others are available but not officially supported.

To verify the architecture compatibility of a specific image:
```bash
docker manifest inspect (image):(tag)
```

---

## Available Tags

| **Alpine Version** | **Tag**  |
|--------------------|----------|
| `edge`             | `:edge`  |
| `3.20`             | `:3.20`  |
| `3.19`             | `:3.19`  |
| `3.18`             | `:3.18`  |
| `3.17`             | `:3.17`  |
| `3.16`             | `:3.16`  |
| `3.15`             | `:3.15`  |
| `3.14`             | `:3.14`  |
| `3.13`             | `:3.13`  |
| `3.12`             | `:3.12`  |
| `3.11`             | `:3.11`  |
| `3.10`             | `:3.10`  |
| `3.9`              | `:3.9`   |
| `3.8`              | `:3.8`   |
| `3.7`              | `:3.7`   |
| `3.6`              | `:3.6`   |
| `3.5`              | `:3.5`   |

---

## Configuration

### Quick Start

Use this image as a base for your builds. For more details on enabling the S6 init system, visit the [s6 overlay repository](https://github.com/just-containers/s6-overlay). You can also refer to other images based on this setup for additional examples.

### Persistent Storage

The following directories can be mapped to the host machine to retain configuration and log files:

| **Directory**                       | **Description**                           |
|-------------------------------------|-------------------------------------------|
| `/etc/fluent-bit/conf.d/`           | Fluent-Bit custom configuration directory |
| `/etc/fluent-bit/parsers.d/`        | Fluent-Bit custom parsers directory       |
| `/etc/zabbix/zabbix_agentd.conf.d/` | Zabbix Agent configuration directory      |
| `/etc/fail2ban/filter.d`            | Custom Fail2ban filter configuration      |
| `/etc/fail2ban/jail.d`              | Custom Fail2ban jail configuration        |
| `/var/log`                          | Logs for container, cron, Zabbix, etc.    |
| `/assets/cron`                      | Drop custom crontabs here                 |
| `/assets/iptables`                  | Drop custom IPTables rules here           |

**Note:** Mapping these directories ensures data persistence between container restarts.

### Environment Variables

Below is a list of variables available for customizing the container. Variables marked with 'x' in the `_FILE` column can load values from files, which is useful for managing sensitive information.

#### **Container Options**

| **Parameter**                      | **Description**                                                                | **Default**                        |
|------------------------------------|--------------------------------------------------------------------------------|------------------------------------|
| `CONTAINER_ENABLE_LOG_TIMESTAMP`   | Add timestamps to container logs                                               | `TRUE`                             |
| `CONTAINER_COLORIZE_OUTPUT`        | Enable/Disable colorized console output                                        | `TRUE`                             |
| `CONTAINER_CUSTOM_BASH_PROMPT`     | Set a custom bash prompt (e.g., '(imagename):(version) HH:MM:SS # ')           |                                    |
| `CONTAINER_CUSTOM_PATH`            | Path to custom files loaded at startup                                         | `/assets/custom`                   |
| `CONTAINER_CUSTOM_SCRIPTS_PATH`    | Path to custom scripts executed at startup                                     | `/assets/custom-scripts`           |
| `CONTAINER_ENABLE_PROCESS_COUNTER` | Display the execution count of a process in logs                               | `TRUE`                             |
| `CONTAINER_LOG_LEVEL`              | Log level (`INFO`, `WARN`, `NOTICE`, `DEBUG`)                                  | `NOTICE`                           |
| `CONTAINER_LOG_PREFIX_TIME_FMT`    | Format for log timestamps (time)                                               | `%H:%M:%S`                         |
| `CONTAINER_LOG_PREFIX_DATE_FMT`    | Format for log timestamps (date)                                               | `%Y-%m-%d`                         |
| `CONTAINER_LOG_PREFIX_SEPERATOR`   | Separator for timestamp components                                             | `-`                                |
| `CONTAINER_LOG_FILE_LEVEL`         | Log level for internal container logs                                          | `DEBUG`                            |
| `CONTAINER_LOG_FILE_NAME`          | File name for container logs                                                   | `/var/log/container/container.log` |
| `CONTAINER_LOG_FILE_PATH`          | Path for container logs                                                        | `/var/log/container/`              |
| `CONTAINER_LOG_PREFIX_TIME_FMT`    | Format for log timestamps (time)                                               | `%H:%M:%S`                         |
| `CONTAINER_LOG_PREFIX_DATE_FMT`    | Format for log timestamps (date)                                               | `%Y-%m-%d`                         |
| `CONTAINER_LOG_PREFIX_SEPARATOR`   | Separator for timestamp components                                             | `-`                                |
| `CONTAINER_NAME`                   | Custom container name for monitoring and log shipping                          | (hostname)                         |
| `CONTAINER_POST_INIT_COMMAND`      | Commands to run after all services have initialized (comma-separated)          |                                    |
| `CONTAINER_POST_INIT_SCRIPT`       | Scripts to execute after all services have initialized (comma-separated paths) |                                    |
| `TIMEZONE`                         | Set container timezone                                                         | `Etc/GMT`                          |

**Example Usage:**
To set a post-initialization script:
```bash
docker run -e CONTAINER_POST_INIT_SCRIPT="/assets/scripts/init.sh" my-container
```

#### Scheduling Options

This image allows you to execute scheduled tasks at specified times using [cron syntax](https://cron.help/). Currently, the image supports **BusyBox cron** but can be extended to other scheduling backends with minimal effort.

| **Parameter**                    | **Description**                       | **Default**        |
|----------------------------------|---------------------------------------|--------------------|
| `CONTAINER_ENABLE_SCHEDULING`    | Enable scheduled tasks                | `TRUE`             |
| `CONTAINER_SCHEDULING_BACKEND`   | Scheduling tool to use (`cron`)       | `cron`             |
| `CONTAINER_SCHEDULING_LOCATION`  | Directory for cron task files         | `/assets/cron/`    |
| `SCHEDULING_LOG_TYPE`            | Log type (`FILE`)                     | `FILE`             |
| `SCHEDULING_LOG_LOCATION`        | Log file location                     | `/var/log/cron/`   |
| `SCHEDULING_LOG_LEVEL`           | Log level (`1` = loud to `8` = quiet) | `6`                |

**Note:** Only BusyBox cron is supported by default. To use other scheduling backends, you may need additional configuration.

##### Cron Options

You can define cron jobs in two ways:
1. Drop files into `/assets/cron/`. These will be parsed when the container starts.
2. Use environment variables prefixed with `CRON_`.

| **Parameter** | **Description**                                                       | **Default** |
|---------------|-----------------------------------------------------------------------|-------------|
| `CRON_*`      | Name of the job, followed by the cron schedule and command to execute | ``          |

**Example Usage:**
```bash
# Add a cron job to run every minute
CRON_HELLO="* * * * * echo 'hello' > /tmp/hello.log"
```

**Disabling Cron Jobs:**
If a cron job is baked into the parent Docker image, you can override it by:
- Replacing it with your own value.
- Disabling it entirely by setting its value to `FALSE`.

Example:
```bash
CRON_HELLO=FALSE
```

#### Messaging Options

To enable email messaging capabilities, set `CONTAINER_ENABLE_MESSAGING=TRUE` and configure the following environment variables. Currently, only the `msmtp` backend is supported, but others can be added easily.

| **Parameter**                 | **Description**                          | **Default** |
|-------------------------------|------------------------------------------|-------------|
| `CONTAINER_ENABLE_MESSAGING`  | Enable messaging services like SMTP      | `TRUE`      |
| `CONTAINER_MESSAGING_BACKEND` | Messaging backend to use (e.g., `msmtp`) | `msmtp`     |

##### SMTP Configuration

To configure `msmtp` for sending emails, set the required SMTP parameters in your environment. Refer to the [MSMTP Configuration Options](https://marlam.de/msmtp/msmtp.html) for detailed documentation.

| **Parameter**              | **Description**                                                                 | **Default**     | **`_FILE`** |
|----------------------------|---------------------------------------------------------------------------------|-----------------|-------------|
| `SMTP_AUTO_FROM`           | Automatically set the sender based on the email address (useful for Gmail SMTP) | `FALSE`         |             |
| `SMTP_HOST`                | Hostname of the SMTP server                                                     | `postfix-relay` | x           |
| `SMTP_PORT`                | Port number of the SMTP server                                                  | `25`            | x           |
| `SMTP_DOMAIN`              | HELO/EHLO domain to identify the client                                         | `docker`        |             |
| `SMTP_MAILDOMAIN`          | Domain to use in the `From` field                                               | `local`         |             |
| `SMTP_AUTHENTICATION`      | Authentication type (`none`, `plain`, `login`, or `cram-md5`)                   | `none`          |             |
| `SMTP_USER`                | Username for SMTP authentication                                                | ``              | x           |
| `SMTP_PASS`                | Password for SMTP authentication                                                | ``              | x           |
| `SMTP_TLS`                 | Enable TLS encryption (`TRUE` or `FALSE`)                                       | `FALSE`         |             |
| `SMTP_STARTTLS`            | Enable STARTTLS within the session (`TRUE` or `FALSE`)                          | `FALSE`         |             |
| `SMTP_TLSCERTCHECK`        | Verify the remote certificate when using TLS                                    | `FALSE`         |             |
| `SMTP_ALLOW_FROM_OVERRIDE` | Allow overriding the `From` address manually                                    | ``              |             |

**Example Usage:**
To configure SMTP with TLS:
```bash
docker run \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=myemail@gmail.com \
    -e SMTP_PASS=mysecurepassword \
    -e SMTP_TLS=TRUE \
    -e SMTP_STARTTLS=TRUE \
    my-container
```

**Example with Plain Authentication:**
For servers not requiring TLS or STARTTLS:
```bash
docker run \
    -e SMTP_HOST=mail.example.com \
    -e SMTP_PORT=25 \
    -e SMTP_AUTHENTICATION=plain \
    -e SMTP_USER=myuser \
    -e SMTP_PASS=myplainpassword \
    my-container
```

**Security Recommendations:**
- Always use `_FILE` variables (e.g., `SMTP_USER_FILE`, `SMTP_PASS_FILE`) to store sensitive information in files rather than passing them directly as environment variables.
- Example for using `_FILE` variables:
```bash
docker run \
    -e SMTP_USER_FILE=/run/secrets/smtp_user \
    -e SMTP_PASS_FILE=/run/secrets/smtp_pass \
    my-container
```

**Additional Notes:**
- For Gmail SMTP, ensure `SMTP_AUTO_FROM=TRUE` and the email address matches the sender domain.
- For advanced configuration and troubleshooting, see the [MSMTP Configuration Options](https://marlam.de/msmtp/msmtp.html).
- To integrate with Zabbix, refer to the [Official Zabbix Agent Documentation](https://www.zabbix.com/documentation/5.4/manual/appendix/config/zabbix_agentd).

#### Monitoring Options

This image includes agents for monitoring application metrics. Currently, it supports Zabbix as the monitoring platform, with the potential for future integration with other platforms.

| **Parameter**                  | **Description**                              | **Default** |
|--------------------------------|----------------------------------------------|-------------|
| `CONTAINER_ENABLE_MONITORING`  | Enable monitoring of applications or metrics | `TRUE`      |
| `CONTAINER_MONITORING_BACKEND` | Monitoring agent to use (`zabbix`)           | `zabbix`    |

##### Zabbix Options

This image supports both Zabbix Agent 1 (Classic, C-compiled) and Zabbix Agent 2 (Modern, Go-compiled). You can configure the agents using environment variables or by placing custom files in `/etc/zabbix/zabbix_agentd.conf.d`.

To switch to manual configuration, set `ZABBIX_SETUP_TYPE=MANUAL`.

| **Parameter**                        | **Description**                                                                   | **Default**              | 1   | 2   | `_FILE` |
|--------------------------------------|-----------------------------------------------------------------------------------|--------------------------|-----|-----|---------|
| `ZABBIX_SETUP_TYPE`                  | Configuration mode: `AUTO` or `MANUAL`                                            | `AUTO`                   | x   | x   |         |
| `ZABBIX_AGENT_TYPE`                  | Version of Zabbix Agent to use (`1` or `2`)                                       | `1`                      | N/A | N/A |         |
| `ZABBIX_AGENT_LOG_PATH`              | Directory for Zabbix agent log files                                              | `/var/log/zabbix/agent/` | x   | x   |         |
| `ZABBIX_AGENT_LOG_FILE`              | Name of the log file for the agent                                                | `zabbix_agentd.log`      | x   | x   |         |
| `ZABBIX_CERT_PATH`                   | Directory for storing Zabbix certificates                                         | `/etc/zabbix/certs/`     | x   | x   |         |
| `ZABBIX_ENCRYPT_PSK_ID`              | Pre-shared Key (PSK) ID for secure communication                                  | ``                       | x   | x   | x       |
| `ZABBIX_ENCRYPT_PSK_KEY`             | Pre-shared Key (PSK) for secure communication                                     | ``                       | x   | x   | x       |
| `ZABBIX_ENCRYPT_PSK_FILE`            | Path to a file containing the Pre-shared Key                                      | ``                       | x   | x   |         |
| `ZABBIX_ENABLE_AUTOREGISTRATION`     | Enable auto-registration to the Zabbix server                                     | `TRUE`                   | x   | x   |         |
| `ZABBIX_ENABLE_AUTOREGISTRATION_DNS` | Use DNS instead of IP for auto-registration                                       | `TRUE`                   | x   | x   |         |
| `ZABBIX_AUTOREGISTRATION_DNS_NAME`   | Custom DNS name for auto-registration (default: `CONTAINER_NAME`)                 | `$CONTAINER_NAME`        | x   | x   |         |
| `ZABBIX_AUTOREGISTRATION_DNS_SUFFIX` | Append a suffix to the auto-registration DNS name                                 | ``                       | x   | x   |         |
| `ZABBIX_LOG_FILE_SIZE`               | Maximum size for the agent log file                                               | `0`                      | x   | x   |         |
| `ZABBIX_DEBUGLEVEL`                  | Debug level (`0` = off, `4` = maximum verbosity)                                  | `1`                      | x   | x   |         |
| `ZABBIX_REMOTECOMMANDS_ALLOW`        | Allow remote commands from the Zabbix server                                      | `*`                      | x   | x   |         |
| `ZABBIX_REMOTECOMMANDS_DENY`         | Deny remote commands                                                              | ``                       | x   | x   |         |
| `ZABBIX_REMOTECOMMANDS_LOG`          | Enable logging for remote commands (`0` = off, `1` = on)                          | `1`                      | x   | ``  |         |
| `ZABBIX_SERVER`                      | IP address or hostname of the Zabbix server                                       | `0.0.0.0/0`              | x   | x   |         |
| `ZABBIX_STATUS_PORT`                 | Agent will listen to this port for status requests (http://localhost:port/status) | `10050`                  | ``  | x   |         |
| `ZABBIX_SERVER_ACTIVE`               | Zabbix server for active checks                                                   | `zabbix-proxy`           | x   | x   | x       |
| `ZABBIX_HOSTNAME`                    | Hostname reported to the Zabbix server                                            | `$CONTAINER_NAME`        | x   | x   |         |
| `ZABBIX_LISTEN_PORT`                 | Port for Zabbix agent to listen                                                   | `10050`                  | x   | x   |         |
| `ZABBIX_LISTEN_IP`                   | IP address for Zabbix agent to bind                                               | `0.0.0.0`                | x   | x   |         |
| `ZABBIX_START_AGENTS`                | Number of agent instances to start                                                | `1`                      | x   | ``  |         |
| `ZABBIX_REFRESH_ACTIVE_CHECKS`       | Interval in seconds to refresh active checks                                      | `120`                    | x   | x   |         |
| `ZABBIX_BUFFER_SEND`                 | Buffer send size in seconds                                                       | `5`                      | x   | x   |         |
| `ZABBIX_BUFFER_SIZE`                 | Buffer size for metrics                                                           | `100`                    | x   | x   |         |
| `ZABBIX_MAXLINES_SECOND`             | Maximum lines sent per second                                                     | `20`                     | x   | ``  |         |
| `ZABBIX_SOCKET`                      | Path to the socket used for communication                                         | `/tmp/zabbix.sock`       | ``  | x   |         |
| `ZABBIX_ALLOW_ROOT`                  | Allow the agent to run as root                                                    | `1`                      | x   | ``  |         |
| `ZABBIX_USER`                        | User account to run the Zabbix agent                                              | `zabbix`                 | x   | x   |         |
| `ZABBIX_USER_SUDO`                   | Allow the Zabbix user to execute commands as sudo                                 | `TRUE`                   | x   | x   |         |
| `ZABBIX_AGENT_TIMEOUT`               | Timeout in seconds for user parameter checks                                      | `3`                      | x   | x   |         |

##### Example Usage

**Auto-Registration with PSK:**
```bash
docker run \
    -e ZABBIX_SETUP_TYPE=AUTO \
    -e ZABBIX_ENCRYPT_PSK_ID=my-psk-id \
    -e ZABBIX_ENCRYPT_PSK_KEY=my-psk-key \
    my-container
```

**Using Custom Configuration Files:**
```bash
docker run \
    -e ZABBIX_SETUP_TYPE=MANUAL \
    -v /path/to/zabbix/config:/etc/zabbix/zabbix_agentd.conf.d \
    my-container
```

#### Additional Notes

- Auto-registration tags can be defined in configuration files using `# Autoregister=`. These tags are added to the `HostMetadata` field and can be used for host discovery.
- Check the `[zabbix_templates](zabbix_templates/)` directory for server templates.

#### Logging Options

This section is part of an ongoing effort to develop a comprehensive logging solution. Currently, the functionality allows for daily log rotation. Future enhancements will include the ability to ship logs to external data warehouses like Loki or Elasticsearch. At present, log shipping is supported only via `fluent-bit` and is limited to the `x86_64` architecture.

| **Parameter**                            | **Description**                                                                        | **Default**  |
|------------------------------------------|----------------------------------------------------------------------------------------|--------------|
| `CONTAINER_ENABLE_LOGROTATE`             | Enable log rotation (requires scheduling to be enabled).                               | `TRUE`       |
| `CONTAINER_ENABLE_LOGSHIPPING`           | Enable log shipping to an external backend.                                            | `FALSE`      |
| `CONTAINER_LOGSHIPPING_BACKEND`          | Backend to use for log shipping. Current option: `fluent-bit`.                         | `fluent-bit` |
| `LOGROTATE_COMPRESSION_TYPE`             | Compression algorithm for rotated log files. Options: `NONE`, `BZIP2`, `GZIP`, `ZSTD`. | `ZSTD`       |
| `LOGROTATE_COMPRESSION_VALUE`            | Compression level for the selected algorithm.                                          | `8`          |
| `LOGROTATE_COMPRESSION_EXTRA_PARAMETERS` | Additional parameters for the compression command (optional).                          |              |
| `LOGROTATE_RETAIN_DAYS`                  | Number of days to retain rotated logs.                                                 | `7`          |

##### Log Shipping Parsing

You can enable log shipping by defining an environment variable. Create a variable prefixed with `LOGSHIP_` followed by a name, and set its value to the location of the log files. Setting the value to `FALSE` disables an existing configuration.

##### Example Usage
```bash
LOGSHIP_NGINX=/var/log/nginx/*.log
```
This configuration tags all log files in the specified directory as originating from `CONTAINER_NAME` and `nginx`. Note: This does not allow for custom parsing and simply ships raw log entries.

##### Auto Configuration of Logrotate for Log Shipping

If `LOGSHIPPING_AUTO_CONFIG_LOGROTATE` is set to `TRUE`, you can specify which parser should be used for shipped logs. Ensure the appropriate `.conf` parser files are available in `/etc/fluent-bit/parsers.d/`.

To configure, add a line to the corresponding `logrotate.d/<file>` that includes the directive:
```bash
# logship: <parser>
```

- **Multiple Parsers**: Separate parser names with commas.
- **Exclude Logs**: Use `SKIP` to prevent a specific log file from being shipped.

| **Parameter**                       | **Description**                                                              | **Default** |
|-------------------------------------|------------------------------------------------------------------------------|-------------|
| `LOGSHIPPING_AUTO_CONFIG_LOGROTATE` | Automatically configure log shipping for files listed in `/etc/logrotate.d`. | `TRUE`      |

#### Fluent-Bit Options

Below is the complete list of configuration parameters for Fluent-Bit. These options control various aspects of Fluent-Bit operation, including log processing, forwarding, and storage.

| **Parameter**                         | **Description**                                                                                   | **Default**              | **`_FILE`** |
|---------------------------------------|---------------------------------------------------------------------------------------------------|--------------------------|-------------|
| `FLUENTBIT_CONFIG_PARSERS`            | Parsers config file name                                                                          | `parsers.conf`           |             |
| `FLUENTBIT_CONFIG_PLUGINS`            | Plugins config file name                                                                          | `plugins.conf`           |             |
| `FLUENTBIT_ENABLE_HTTP_SERVER`        | Embedded HTTP Server for metrics `TRUE` / `FALSE`                                                 | `TRUE`                   |             |
| `FLUENTBIT_ENABLE_STORAGE_METRICS`    | Public storage pipeline metrics in /api/v1/storage                                                | `TRUE`                   |             |
| `FLUENTBIT_FLUSH_SECONDS`             | Wait time to flush records in seconds                                                             | `1`                      |             |
| `FLUENTBIT_FORWARD_BUFFER_CHUNK_SIZE` | Buffer Chunk Size                                                                                 | `32KB`                   |             |
| `FLUENTBIT_FORWARD_BUFFER_MAX_SIZE`   | Buffer Maximum Size                                                                               | `64KB`                   |             |
| `FLUENTBIT_FORWARD_PORT`              | What port when using `PROXY` (listen) mode or `FORWARD` (client) output                           | `24224`                  |             |
| `FLUENTBIT_GRACE_SECONDS`             | Wait time before exit in seconds                                                                  | `1`                      |             |
| `FLUENTBIT_HTTP_LISTEN_IP`            | HTTP Listen IP                                                                                    | `0.0.0.0`                |             |
| `FLUENTBIT_HTTP_LISTEN_PORT`          | HTTP Listening Port                                                                               | `2020`                   |             |
| `FLUENTBIT_LOG_FILE`                  | Log File                                                                                          | `fluentbit.log`          |             |
| `FLUENTBIT_LOG_LEVEL`                 | Log Level `info` `warn` `error` `debug` `trace`                                                   | `info`                   |             |
| `FLUENTBIT_LOG_PATH`                  | Log Path                                                                                          | `/var/log/fluentbit/`    |             |
| `FLUENTBIT_MODE`                      | Type of operation - Client `NORMAL` or Proxy `PROXY`                                              | `NORMAL`                 |             |
| `FLUENTBIT_OUTPUT_FORWARD_HOST`       | Where to forward Fluent-Bit data to                                                               | `fluent-proxy`           | x           |
| `FLUENTBIT_OUTPUT_FORWARD_TLS_VERIFY` | Verify certificates when using TLS                                                                | `FALSE`                  |             |
| `FLUENTBIT_OUTPUT_FORWARD_TLS`        | Enable TLS when forwarding                                                                        | `FALSE`                  |             |
| `FLUENTBIT_OUTPUT_LOKI_COMPRESS_GZIP` | Enable GZIP compression when sending to loki host                                                 | `TRUE`                   |             |
| `FLUENTBIT_OUTPUT_LOKI_HOST`          | Host for Loki Output                                                                              | `loki`                   | x           |
| `FLUENTBIT_OUTPUT_LOKI_PORT`          | Port for Loki Output                                                                              | `3100`                   | x           |
| `FLUENTBIT_OUTPUT_LOKI_TLS`           | Enable TLS For Loki Output                                                                        | `FALSE`                  |             |
| `FLUENTBIT_OUTPUT_LOKI_TLS_VERIFY`    | Enable TLS Certificate Verification For Loki Output                                               | `FALSE`                  |             |
| `FLUENTBIT_OUTPUT_LOKI_USER`          | (optional) Username to authenticate to Loki Server                                                | ``                       | x           |
| `FLUENTBIT_OUTPUT_LOKI_PASS`          | (optional) Password to authenticate to Loki Server                                                | ``                       | x           |
| `FLUENTBIT_OUTPUT_TENANT_ID`          | (optional) Tenant ID to pass to Loki Server                                                       | ``                       | x           |
| `FLUENTBIT_OUTPUT`                    | Output plugin to use `LOKI` , `FORWARD`, `NULL`                                                   | `FORWARD`                |             |
| `FLUENTBIT_TAIL_BUFFER_CHUNK_SIZE`    | Buffer Chunk Size for Tail                                                                        | `32k`                    |             |
| `FLUENTBIT_TAIL_BUFFER_MAX_SIZE`      | Maximum size for Tail                                                                             | `32k`                    |             |
| `FLUENTBIT_TAIL_READ_FROM_HEAD`       | Read from Head instead of Tail                                                                    | `FALSE`                  |             |
| `FLUENTBIT_TAIL_SKIP_EMPTY_LINES`     | Skip Empty Lines when Tailing                                                                     | `TRUE`                   |             |
| `FLUENTBIT_TAIL_SKIP_LONG_LINES`      | Skip Long Lines when Tailing                                                                      | `TRUE`                   |             |
| `FLUENTBIT_TAIL_DB_ENABLE`            | Enable Offset DB per tracked file (will be same name as log file yet hidden and a suffix of `db`) | `TRUE`                   |             |
| `FLUENTBIT_TAIL_DB_SYNC`              | DB Sync Type `normal` or `full`                                                                   | `normal`                 |             |
| `FLUENTBIT_TAIL_DB_LOCK`              | Lock access to DB File                                                                            | `TRUE`                   |             |
| `FLUENTBIT_TAIL_DB_JOURNAL_MODE`      | Journal Mode for DB `WAL` `DELETE` `TRUNCATE` `PERSIST` `MEMORY` `OFF`                            | `WAL`                    |             |
| `FLUENTBIT_TAIL_KEY_PATH_ENABLE`      | Enable sending Key for Log Filename/Path                                                          | `TRUE`                   |             |
| `FLUENTBIT_TAIL_KEY_PATH`             | Path Key Name                                                                                     | `filename`               |             |
| `FLUENTBIT_TAIL_KEY_OFFSET_ENABLE`    | Enable sending Key for Offset in Log file                                                         | `FALSE`                  |             |
| `FLUENTBIT_TAIL_KEY_OFFSET`           | Offset Path Key Name                                                                              | `offset`                 |             |
| `FLUENTBIT_SETUP_TYPE`                | Automatically generate configuration based on these variables `AUTO` or `MANUAL`                  | `AUTO`                   |             |
| `FLUENTBIT_STORAGE_BACKLOG_LIMIT`     | Maximum amount of memory to use for backlogged/unsent records                                     | `5M`                     |             |
| `FLUENTBIT_STORAGE_CHECKSUM`          | Create CRC32 checksum for filesystem RW functions                                                 | `FALSE`                  |             |
| `FLUENTBIT_STORAGE_PATH`              | Absolute file system path to store filesystem data buffers                                        | `/tmp/fluentbit/storage` |             |
| `FLUENTBIT_STORAGE_SYNC`              | Synchronization mode to store data in filesystem `normal` or `full`                               | `normal`                 |             |

#### Firewall Options

When the appropriate capabilities are set for the container, it can apply detailed block/allow rules through a firewall at startup. Currently, only `iptables` is supported.

To enable this functionality, ensure that your container is run with the following capabilities added:  
`NET_ADMIN`, `NET_RAW`

| **Parameter**                | **Description**                                | **Default** |
|------------------------------|------------------------------------------------|-------------|
| `CONTAINER_ENABLE_FIREWALL`  | Enable firewall functionality                  | `FALSE`     |
| `CONTAINER_FIREWALL_BACKEND` | Firewall backend to use (currently `iptables`) | `iptables`  |
| `FIREWALL_RULE_00`           | First firewall rule to execute                 |             |
| `FIREWALL_RULE_01`           | Second firewall rule to execute                |             |

You can define firewall rules using `FIREWALL_RULE_XX` environment variables. Below is an example of how to block access to a port for all except a specific IP address:

```bash
FIREWALL_RULE_00=-I INPUT -p tcp -m tcp -s 101.69.69.101 --dport 389 -j ACCEPT
FIREWALL_RULE_01=-I INPUT -p tcp -m tcp -s 0.0.0.0/0 --dport 389 -j DROP
```

##### Host Override Options

In some cases, you may need to modify the container's host file by adding custom entries. This is achievable using the following parameter:

| **Parameter**                | **Description**             | **Default** |
|------------------------------|-----------------------------|-------------|
| `CONTAINER_HOST_OVERRIDE_01` | Create a manual hosts entry |             |

##### Example:
The value should follow the format:  
`<destination> override1 override2`

Examples:
- `1.2.3.4 example.org example.com`  
  (Maps `example.org` and `example.com` to IP `1.2.3.4`)
- `proxy example.com example.org`  
  (If no IP is provided, the system will resolve the domain to an IP address.)

##### IPTables Options

If you prefer to define a ruleset file instead of using environment variables for individual rules, you can provide an `iptables-restore` compatible ruleset. This ruleset will be applied during container startup.

| **Parameter**         | **Description**                                                  | **Default**         |
|-----------------------|------------------------------------------------------------------|---------------------|
| `IPTABLES_RULES_PATH` | Path to the IPTables rules directory                             | `/assets/iptables/` |
| `IPTABLES_RULES_FILE` | IPTables rules file to restore if it exists at container startup | `iptables.rules`    |

##### Example Ruleset:
Save the ruleset in a file (e.g., `iptables.rules`) in the specified directory. The file should follow the `iptables-restore` format.

##### Fail2Ban Options

The container supports Fail2Ban if `CONTAINER_ENABLE_FIREWALL=TRUE` is enabled. Fail2Ban monitors log files for suspicious patterns and blocks remote hosts attempting unauthorized connections for a configurable period.

You can add custom jail configurations as `.conf` files in `/etc/fail2ban/jail.d/` and custom filters in `/etc/fail2ban/filter.d`. These configurations will be parsed during container startup. Use the startup delay environment variable (`FAIL2BAN_STARTUP_DELAY`) to prevent Fail2Ban from failing when logs are unavailable during a fresh installation.

| **Parameter**               | **Description**                                                                   | **Default**                                    |
|-----------------------------|-----------------------------------------------------------------------------------|------------------------------------------------|
| `CONTAINER_ENABLE_FAIL2BAN` | Enable Fail2Ban functionality. Requires `CONTAINER_ENABLE_FIREWALL=TRUE`.         | `FALSE`                                        |
| `FAIL2BAN_BACKEND`          | Backend for Fail2Ban operation.                                                   | `AUTO`                                         |
| `FAIL2BAN_CONFIG_PATH`      | Path for Fail2Ban configuration files.                                            | `/etc/fail2ban/`                               |
| `FAIL2BAN_DB_FILE`          | Name of the persistent Fail2Ban database file.                                    | `fail2ban.sqlite3`                             |
| `FAIL2BAN_DB_PATH`          | Path for storing the persistent Fail2Ban database file.                           | `/data/fail2ban/`                              |
| `FAIL2BAN_DB_PURGE_AGE`     | Purge database entries after the specified time (in seconds).                     | `86400` (1 day)                                |
| `FAIL2BAN_DB_TYPE`          | Type of database to use: `NONE`, `MEMORY`, or `FILE`.                             | `MEMORY`                                       |
| `FAIL2BAN_IGNORE_IP`        | Space-separated list of IPs or ranges to ignore.                                  | `127.0.0.1/8 ::1 172.16.0.0/12 192.168.0.0/24` |
| `FAIL2BAN_IGNORE_SELF`      | Ignore the container's own IP. `TRUE` or `FALSE`.                                 | `TRUE`                                         |
| `FAIL2BAN_LOG_PATH`         | Path for storing Fail2Ban log files.                                              | `/var/log/fail2ban/`                           |
| `FAIL2BAN_LOG_FILE`         | Name of the Fail2Ban log file.                                                    | `fail2ban.log`                                 |
| `FAIL2BAN_LOG_LEVEL`        | Log level: `CRITICAL`, `ERROR`, `WARNING`, `NOTICE`, `INFO`, or `DEBUG`.          | `INFO`                                         |
| `FAIL2BAN_LOG_TYPE`         | Output logs to `FILE` or `CONSOLE`.                                               | `FILE`                                         |
| `FAIL2BAN_MAX_RETRY`        | Maximum number of matches for a pattern within the `FAIL2BAN_TIME_FIND` window.   | `5`                                            |
| `FAIL2BAN_STARTUP_DELAY`    | Delay (in seconds) before Fail2Ban starts monitoring to allow log initialization. | `15`                                           |
| `FAIL2BAN_TIME_BAN`         | Default ban duration for detected patterns.                                       | `10m`                                          |
| `FAIL2BAN_TIME_FIND`        | Time window to monitor log patterns.                                              | `10m`                                          |
| `FAIL2BAN_USE_DNS`          | Use DNS lookups: `yes`, `warn`, `no`, or `raw`.                                   | `warn`                                         |

##### Examples

1. **Custom Jail Configuration**:
   Create a `.conf` file in `/etc/fail2ban/jail.d/` to specify custom behavior. For instance:
   ```conf
   [nginx-auth]
   enabled  = true
   filter   = nginx-auth
   logpath  = /var/log/nginx/access.log
   maxretry = 3
   bantime  = 3600
   ```

2. **Startup Delay**:
   Use `FAIL2BAN_STARTUP_DELAY` to give time for monitored logs to generate data, especially in newly deployed systems:
   ```bash
   FAIL2BAN_STARTUP_DELAY=30
   ```

3. **Ignoring Specific IPs**:
   Specify trusted IP ranges that Fail2Ban should ignore:
   ```bash
   FAIL2BAN_IGNORE_IP="192.168.1.0/24 10.0.0.0/8"
   ```

4. **Custom Filters**:
   Add custom patterns to `/etc/fail2ban/filter.d/` to match specific log entries.

#### Permissions

You can modify internal user and group IDs in the container by setting environment variables. For example, adding `USER_NGINX=1000` will change the container's `nginx` user ID from the default `82` to `1000`.

If you set `DEBUG_PERMISSIONS=TRUE`, all modified users and groups will be displayed in the output during container startup.

**Tip:** Modify the Group ID (`GID`) to match your local development user's UID & GID. This prevents Docker permission issues during development.

| **Parameter**                     | **Description**                                                             |
|-----------------------------------|-----------------------------------------------------------------------------|
| `CONTAINER_USER_<USERNAME>`       | Modifies the UID for the specified user in `/etc/passwd`.                   |
| `CONTAINER_GROUP_<GROUPNAME>`     | Modifies the GID for the specified group in `/etc/group` and `/etc/passwd`. |
| `CONTAINER_GROUP_ADD_<GROUPNAME>` | Adds the username to the specified group in `/etc/group`.                   |

#### Process Watchdog

This experimental feature enables you to call an external script whenever a process is executed. This script can be used for various scenarios, such as:

- Sending alerts to a Slack channel when a process executes multiple times.
- Disabling a process after it restarts a set number of times (e.g., 50 times).
- Writing additional log entries.
- Updating a webserver to display "Under Maintenance" if a specific process is not expected to run repeatedly.

#### How It Works:
1. When a process starts, the container looks for a bash script in `CONTAINER_PROCESS_HELPER_PATH` with the same name as the process.
    - If the script is found, it is executed with the following arguments: `DATE`, `TIME`, `SCRIPT_NAME`, `TIMES_EXECUTED`, `HOSTNAME`.
    - Example: `2021-07-01 23:01:04 04-scheduling 2 container`.
2. If no matching script is found, the container uses the default script specified by `CONTAINER_PROCESS_HELPER_SCRIPT`.

#### Example:
For a process named `04-scheduling`, the container will look for a script at `$CONTAINER_PROCESS_HELPER_PATH/04-scheduling`. The script can use arguments as follows:
```bash
#!/bin/bash
echo "Process $3 executed $4 times on host $5 at $1 $2"
```

| **Parameter**                                 | **Description**                                                            | **Default**                        |
|-----------------------------------------------|----------------------------------------------------------------------------|------------------------------------|
| `CONTAINER_PROCESS_HELPER_PATH`               | Path for storing external helper scripts.                                  | `/assets/container/processhelper/` |
| `CONTAINER_PROCESS_HELPER_SCRIPT`             | Default helper script name if no specific script is found.                 | `processhelper.sh`                 |
| `CONTAINER_PROCESS_HELPER_DATE_FMT`           | Date format passed to the external script.                                 | `%Y-%m-%d`                         |
| `CONTAINER_PROCESS_HELPER_TIME_FMT`           | Time format passed to the external script.                                 | `%H:%M:%S`                         |
| `CONTAINER_PROCESS_RUNAWAY_PROTECTOR`         | Enables protection against runaway processes.                              | `TRUE`                             |
| `CONTAINER_PROCESS_RUNAWAY_DELAY`             | Delay (in seconds) before restarting a process.                            | `1`                                |
| `CONTAINER_PROCESS_RUNAWAY_LIMIT`             | Maximum number of restarts before the process is disabled.                 | `50`                               |
| `CONTAINER_PROCESS_RUNAWAY_SHOW_OUTPUT_FINAL` | Displays the program's output during the final execution before disabling. | `TRUE`                             |

#### Networking

The container exposes the following ports for communication:

| **Port** | **Description** |
|----------|-----------------|
| `2020`   | Fluent Bit      |
| `10050`  | Zabbix Agent    |

---

## Developing / Overriding

This base image has been successfully used to build secondary images in over a hundred projects. While the approach deviates from the "one process per container" rule, it allows for rapid image development. For more complex scalability, the work can be split into individual containers. Below is a crash course on how this image works: *(Work in Progress)*

1. **Defaults**: Place defaults in `/assets/defaults/(script name)`.
2. **Functions**: Place reusable functions in `/assets/functions/(script name)`.
3. **Initialization Scripts**: Place initialization scripts in `/etc/cont-init.d/(script name)`.
    - Use these scripts to prepare the container environment.
4. **Service Scripts**: Place service scripts in `/etc/services.available/(script name)`.
    - These scripts manage individual service start-ups.

### Initialization Script Example

Place the following script in `/etc/cont-init.d/(script name)`:

```bash
#!/command/with-contenv bash          # Import container environment variables
source /assets/functions/00-container # Import custom container functions
prepare_service single                # Load functions and defaults matching the script filename
PROCESS_NAME="process"                # Prefix for logging

# Custom scripting starts here
print_info "This is an INFO log"
print_warn "This is a WARN log"
print_error "This is an ERROR log"

liftoff                               # Write state files to prove execution (checks /tmp/.container/ files)
```

### Service Script Example

Place the following script in `/etc/services.available/(script name)`:

```bash
#!/command/with-contenv bash          # Import container environment variables
source /assets/functions/00-container # Import custom container functions
prepare_service defaults single       # Load defaults matching the script filename
PROCESS_NAME="process"                # Prefix for logging

check_container_initialized           # Verify the container is properly initialized
check_service_initialized init        # Wait until the `cont-init.d/(script name)` script completes
liftoff                               # Ensure the script executed successfully

print_start "Starting processname"    # Log process start with a counter if enabled
fakeprocess (args)                    # Replace `fakeprocess` with your actual process and arguments
```

| **Parameter**                 | **Description**                                              | **Default** |
|-------------------------------|--------------------------------------------------------------|-------------|
| `CONTAINER_SKIP_SANITY_CHECK` | Skip verification of script execution in `/etc/cont-init.d`. | `FALSE`     |
| `DEBUG_MODE`                  | Enable debug mode to show all script output (`set -x`).      | `FALSE`     |
| `PROCESS_NAME`                | Prefix for logging messages in scripts.                      | `container` |

#### Improvements Made

1. **Clarity**:
    - Added detailed explanations for each directory and its purpose.
    - Simplified technical descriptions for easier comprehension.

2. **Examples**:
    - Provided structured and clear examples for initialization and service scripts.
    - Demonstrated where and how specific functions and parameters are used.

3. **Consistency**:
    - Unified formatting for commands, script examples, and explanations.
    - Used consistent terminology for processes and parameters.

4. **Table Optimization**:
    - Streamlined the parameter descriptions for clarity and conciseness.

---

## Debug Mode

When using this base image, you can enable debug functionality by setting the environment variable `DEBUG_MODE=TRUE`. This allows your applications and scripts to output more detailed logs and enables debugging features where applicable.

When `DEBUG_MODE=TRUE` is enabled, this base image provides the following functionality:

1. **Verbose Logging for Zabbix Agent**:
   - Configures the Zabbix Agent to produce detailed log output, helping you troubleshoot issues more effectively.

2. **Script Debugging**:
   - Shows all script output by enabling debug tracing (`set -x` equivalent), allowing you to see each command as it is executed.

### Implementation Example

In your custom startup script, you can add conditions to check for `DEBUG_MODE=TRUE` and enable application-specific debugging modes:

```bash
if [ "${DEBUG_MODE}" = "TRUE" ]; then
    echo "Debug mode is enabled"
    # Example: Enable verbose logging in your application
    export APP_LOG_LEVEL=debug
    export APP_ENABLE_VERBOSE=true
fi
```

### Best Practices

1. **Use Debug Mode for Development**:
   - Enable `DEBUG_MODE=TRUE` only during development or troubleshooting to avoid excessive logging in production environments.

2. **Combine with Application Debug Flags**:
   - Ensure your custom applications or processes respect the `DEBUG_MODE` flag to enable consistent debugging across your container.

3. **Monitor Logs**:
   - Regularly monitor and review the verbose output to identify issues and fine-tune your configuration.

### Improvements Made

1. **Clarity**:
   - Enhanced the explanation of `DEBUG_MODE` functionality.
   - Added examples for better understanding of implementation.

2. **Structure**:
   - Organized content into key features, examples, and best practices for readability.

3. **Professional Tone**:
   - Improved phrasing for a more professional and user-friendly tone.

---

## Support

These images were originally built to address specific needs in a production environment and have been enhanced over time based on community feedback.

### Usage

- The [Discussions board](../../discussions) is an excellent place to collaborate with the community, share tips, and learn tricks for using this image effectively.
- For personalized support, consider [sponsoring me](https://focela.com/sponsor).

### Bug Fixes

- If you encounter an issue or something is not working as expected, please submit a [Bug Report](issues/new).  
  I’ll prioritize the fix and aim to resolve it as quickly as possible.

### Feature Requests

- You are welcome to submit feature requests to improve the functionality of this image.  
  However, please note that there is no guarantee of implementation or a specific timeline for delivery.
- For priority feature development, you can [sponsor me](https://focela.com/sponsor).

### Updates

- I make every effort to track upstream changes and update the image as needed, especially if I actively use it in a production environment.
- For guaranteed up-to-date releases, consider [sponsoring me](https://focela.com/sponsor).

---

## License

This image is licensed under the MIT License. See [LICENSE](LICENSE) for full details.
