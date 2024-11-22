# Base image with Alpine Linux
# This image is a lightweight, secure, and flexible base for customizations
ARG ALPINE_VERSION=3.20
FROM docker.io/alpine:${ALPINE_VERSION}

# Metadata about the image
LABEL maintainer="Focela Digital (https://github.com/focela)" \
      description="Custom Alpine image with added utilities for logging, monitoring, and scheduling"

# Define versions for dependencies
# These ARGs allow specifying versions of dependencies at build time
ARG GOLANG_VERSION=1.21.13
ARG DOAS_VERSION
ARG FLUENTBIT_VERSION
ARG S6_OVERLAY_VERSION
ARG YQ_VERSION
ARG ZABBIX_VERSION

# Environment variables for runtime configurations and versioning
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

# Apply Mono Repo workarounds
# Adjust configurations and packages based on Alpine version
RUN case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2)" in \
        # Disable UPX for older Alpine versions
        "3.5" | "3.6" ) no_upx=true ;; \
        *) busybox_extras="busybox-extras" ;; \
    esac ; \
    \
    # Configure Zabbix Agent and Fluent Bit for newer Alpine versions
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2 | cut -d _ -f 1)" in \
        3.11 | 3.12 | 3.13 | 3.14 | 3.15 | 3.16 | 3.17* | 3.18* | 3.19* | 3.20* | 3.21* | edge ) \
            zabbix_args=" --enable-agent2 " ; \
            zabbix_agent2=true ; \
            fluentbit_make=true ; \
            echo "** Building Zabbix Agent 2" ; \
            echo "** Building Fluent Bit" ;; \
        *) : ;; \
    esac ; \
    \
    # Adjust Golang version for compatibility
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2 | cut -d _ -f 1)" in \
        3.11 | 3.12 | 3.13 | 3.14 ) export GOLANG_VERSION=1.19.5 ; yq=false ;; \
        *) : ;; \
    esac ; \
    \
    # Adjust YQ support based on Alpine version
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2 | cut -d _ -f 1)" in \
        3.5 | 3.6 | 3.7 | 3.8 | 3.9 | 3.10 | 3.11 | 3.12 | 3.13 | 3.14 | 3.15 | 3.16 ) yq=false ;; \
        *) : ;; \
    esac ; \
    \
    # Configure FTS library (fts vs musl-fts) based on Alpine version
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2 | cut -d _ -f 1)" in \
        3.5 | 3.6 | 3.7 | 3.8 | 3.9 | 3.10 | 3.11 | 3.12 | 3.13 | 3.14 | 3.15 | 3.16 ) fts=fts ;; \
        3.17 | 3.18* | 3.19* | 3.20* | 3.21* ) fts=musl-fts ;; \
        *) : ;; \
    esac ; \
    \
    # Adjust SSL library (libressl vs openssl) based on Alpine version
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2 | cut -d _ -f 1)" in \
        3.5 | 3.6 | 3.7 | 3.8 | 3.9 | 3.10 | 3.11 | 3.12 | 3.13 | 3.14 | 3.15 | 3.16 ) alpine_ssl=libressl ;; \
        3.17* | 3.18* | 3.19* | 3.20* | 3.21* ) alpine_ssl=openssl ;; \
        *) : ;; \
    esac ; \
    \
    # Determine UPX availability based on architecture
    apkArch="$(apk --print-arch)" ; \
    case "$apkArch" in \
        x86_64) upx=upx ;; \
        *) : ;; \
    esac; \
    \
    # Disable UPX for specific Alpine versions
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2)" in \
        "3.5" | "3.6") upx="" ;; \
    esac ; \
    \
    # Configure DOAS and ZSTD packages based on Alpine version
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2)" in \
        "3.5" | "3.6" | "3.7" | "3.8" ) build_doas=true ;; \
        *) doas_package="doas" ;; \
    esac ; \
    case "$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2 | cut -d . -f 1,2)" in \
        "3.5" | "3.8" ) zstd_package="" ;; \
        *) zstd_package=zstd ;; \
    esac ; \
    # Enable debug mode and exit on errors
    # -e: Exit the script immediately if a command exits with a non-zero status
    # -x: Print each command before executing it (useful for debugging)
    set -ex && \
    # Update Alpine package index and upgrade installed packages
    apk update && apk upgrade && \
    # Add base runtime dependencies
    apk add -t .base-rundeps \
        acl \
        ${alpine_ssl} \
        bash \
        bc \
        ${busybox_extras} \
        curl \
        ${doas_package} \
        fail2ban \
        ${fts} \
        git \
        grep \
        iptables \
        iputils \
        jq \
        less \
        libgcc \
        $(apk search libssl1* -q) \
        logrotate \
        msmtp \
        nano \
        pcre \
        s6 \
        sudo \
        tzdata \
        yaml \
        ${zstd_package} \
        && \
    \
    # Add Go programming language and development dependencies
    apk add -t .golang-build-deps \
        go \
        musl-dev \
        && \
    \
    # Add Zabbix build dependencies
    apk add -t .zabbix-build-deps \
        alpine-sdk \
        autoconf \
        automake \
        binutils \
        coreutils \
        g++ \
        openssl-dev \
        make \
        pcre-dev \
        zlib-dev \
        ${additional_packages} \
        ${upx} \
        && \
    \
    # Add Fluent Bit build dependencies
    apk add -t .fluentbit-build-deps \
        bison \
        cmake \
        flex \
        ${fts}-dev \
        linux-headers \
        openssl-dev \
        snappy-dev \
        yaml-dev \
        && \
    \
    # Add gettext and move envsubst to a new path
    apk add gettext && \
    mv /usr/bin/envsubst /usr/local/bin/envsubst && \
    \
    # Set timezone configuration
    cp -R /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    \
    # Configure sudo to reduce verbosity
    echo "Set disable_coredump false" > /etc/sudo.conf && \
    \
    # Build and install Doas (if required)
    if [ "$build_doas" = "true" ] ; then \
        mkdir -p /usr/src/doas ; \
        curl -sSL https://github.com/Duncaen/OpenDoas/archive/${DOAS_VERSION}.tar.gz | tar xfz - --strip 1 -C /usr/src/doas ; \
        cd /usr/src/doas ; \
        ./configure --prefix=/usr \
                    --enable-static \
                    --without-pam ; \
        make ; \
        make install ; \
    fi ;

# Use Bash as the default shell
SHELL ["/bin/bash", "-c"]

# Expose necessary ports for monitoring and logging
EXPOSE 2020/TCP 10050/TCP

# Copy installation scripts into the container
COPY install/ /
