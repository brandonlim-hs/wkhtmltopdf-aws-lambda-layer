FROM amazonlinux:2

RUN yum install -y \
    rpmdevtools \
    wget \
    yum-utils

WORKDIR /tmp

# Download wkhtmltopdf and its dependencies. Then extract all rpm files.
ENV WKHTMLTOPDF_BIN="wkhtmltopdf.rpm"
RUN wget -O $WKHTMLTOPDF_BIN https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox-0.12.5-1.centos7.$(arch).rpm \
    && yum install --downloadonly --downloaddir=/tmp $WKHTMLTOPDF_BIN \
    && yumdownloader --archlist=$(arch) \
    bzip2-libs \
    expat \
    libuuid \
    && rpmdev-extract *rpm

WORKDIR /layer

# Copy wkhtmltopdf binary and dependency libraries for packaging
RUN mkdir -p {bin,lib} \
    && cp /tmp/wkhtml*/usr/local/bin/* bin \
    && cp /tmp/*/usr/lib64/* lib || :

# Zip files
ENV LAYER_ZIP="layer.zip"
RUN zip -r $LAYER_ZIP bin lib \
    && mv $LAYER_ZIP /