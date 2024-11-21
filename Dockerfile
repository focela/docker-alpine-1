# Base image with Alpine Linux
ARG ALPINE_VERSION=3.20
FROM docker.io/alpine:${ALPINE_VERSION}
LABEL maintainer="Focela Technologies (https://github.com/focela)" \
      description="Custom Alpine image with added utilities for logging, monitoring, and scheduling"

# Build arguments
ARG GOLANG_VERSION=1.21.13
ARG DOAS_VERSION
ARG FLUENTBIT_VERSION
ARG S6_OVERLAY_VERSION
ARG YQ_VERSION
ARG ZABBIX_VERSION

# Environment variables
ENV FLUENTBIT_VERSION=${FLUENTBIT_VERSION:-"3.2.1"} \
    S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION:-"3.2.0.2"} \
    YQ_VERSION=${YQ_VERSION:-"v4.44.2"} \
    ZABBIX_VERSION=${ZABBIX_VERSION:-"7.0.6"} \
    DOAS_VERSION=${DOAS_VERSION:-"v6.8.2"} \
    DEBUG_MODE=FALSE \
    TIMEZONE=Etc/GMT \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    CONTAINER_SCHEDULING_BACKEND=cron \
    CONTAINER_ENABLE_MESSAGING=TRUE \
    CONTAINER_MESSAGING_BACKEND=msmtp \
    CONTAINER_ENABLE_MONITORING=TRUE \
    CONTAINER_MONITORING_BACKEND=zabbix \
    CONTAINER_ENABLE_LOGSHIPPING=FALSE \
    S6_GLOBAL_PATH="/command:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin" \
    S6_KEEP_ENV=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    IMAGE_NAME="focela/alpine" \
    IMAGE_REPO_URL="https://github.com/focela/alpine/"
