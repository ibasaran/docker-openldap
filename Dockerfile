FROM debian:jessie

MAINTAINER Christian Luginbühl <dinkel@pimprecords.com>

ENV OPENLDAP_VERSION 2.4.40

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        slapd=${OPENLDAP_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap /etc/ldap.dist

RUN mkdir -p /etc/ldap/prepopulate

ENV SLAPD_PASSWORD secret

ENV SLAPD_DOMAIN liderahenk.org

ENV SLAPD_ADDITIONAL_MODULES liderahenk

ENV SLAPD_CONFIG_PASSWORD secret

COPY modules/ /etc/ldap.dist/modules

COPY prepopulate/ /etc/ldap/prepopulate

COPY entrypoint.sh /entrypoint.sh

EXPOSE 389

VOLUME ["/etc/ldap", "/var/lib/ldap"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["slapd", "-d", "32768", "-u", "openldap", "-g", "openldap"]
