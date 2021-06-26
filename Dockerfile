FROM registry.access.redhat.com/ubi8/ubi

ARG WWWDATA_UID=888

ENV HOME=/var/www
ENV APP_ROOT=/app

RUN yum update --disableplugin=subscription-manager -y && rm -rf /var/cache/yum
RUN yum install -y --disableplugin=subscription-manager httpd \
openssl \
mod_ssl \
openssl-devel \
bind-utils \
gettext \
hostname \
httpd-devel \
vim \
nss_wrapper \ 
mod_ldap \
mod_session \
mod_security \
mod_auth_mellon \
sscg \
wget \
&& \
rm -rf /var/cache/yum

RUN cd / &&\ 
wget https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.8.4/mod_auth_openidc-2.4.8.4-1.el8.x86_64.rpm && \
wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/cjose-0.6.1-2.module_el8.4.0+674+2c6c7264.x86_64.rpm && \
wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/cjose-devel-0.6.1-2.module_el8.4.0+674+2c6c7264.x86_64.rpm && \
wget https://rpmfind.net/linux/centos/8-stream/BaseOS/x86_64/os/Packages/jansson-2.11-3.el8.x86_64.rpm && \
wget https://rpmfind.net/linux/epel/8/Everything/x86_64/Packages/h/hiredis-0.13.3-13.el8.x86_64.rpm && \
wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/jansson-devel-2.11-3.el8.x86_64.rpm && \
rpm -Uivh cjose-0.6.1-2.module_el8.4.0+674+2c6c7264.x86_64.rpm mod_auth_openidc-2.4.8.4-1.el8.x86_64.rpm  cjose-devel-0.6.1-2.module_el8.4.0+674+2c6c7264.x86_64.rpm jansson-2.11-3.el8.x86_64.rpm hiredis-0.13.3-13.el8.x86_64.rpm jansson-devel-2.11-3.el8.x86_64.rpm 


# Add default Web page and expose port
RUN echo "The Web Server is Running" > /var/www/html/index.html
EXPOSE 80
EXPOSE 443

ENV HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ \
    HTTPD_APP_ROOT=${APP_ROOT} \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/httpd.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_TLS_CERT_PATH=/etc/httpd/tls \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_LOG_PATH=/var/log/httpd

COPY ./root /

RUN mkdir ${APP_ROOT}
RUN /usr/libexec/httpd-prepare 

USER 1001

CMD ["/usr/bin/run-httpd"]

