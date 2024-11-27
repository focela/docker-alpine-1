
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

## About

Dockerfile to build an [alpine](https://www.alpinelinux.org/) Linux container image.

## Features

- **Supported Versions**: Currently tracking versions 3.5 through 3.20 and edge.
- **PID 1 Init System**: [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for managing init capabilities.
- **Monitoring**: Includes [zabbix-agent](https://zabbix.org) (Classic and Modern) for container monitoring.
- **Task Scheduling**: Enabled via cron with helpful tools (bash, curl, less, logrotate, nano, vi) for simplified management.
- **Messaging**: MSMTP for sending mail from containers to external SMTP servers.
- **Firewall**: Integrated [Fail2ban](https://github.com/fail2ban/fail2ban) to block malicious hosts.
- **Log Shipping**: Capabilities to forward logs to remote servers using [Fluent-Bit](https://github.com/fluent/fluent-bit).
- **Dynamic User Management**: Update User ID and Group ID permissions dynamically.
