FROM amazonlinux:2

RUN yum install -y \
    rpmdevtools \
    wget \
    yum-utils

ENV LAYER_DIR="/layer"
ENV LAYER_ZIP="layer.zip"
ENV TEMP_DIR="/tmp"
ENV WKHTMLTOPDF_BIN="$TEMP_DIR/wkhtmltopdf.rpm"

# Download wkhtmltopdf and its dependencies
RUN wget -O $WKHTMLTOPDF_BIN https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox-0.12.5-1.centos7.$(arch).rpm \
    && yum install --downloadonly --downloaddir=$TEMP_DIR $WKHTMLTOPDF_BIN
RUN yumdownloader --destdir $TEMP_DIR --archlist=$(arch) expat

# Extract all rpm files
RUN cd $TEMP_DIR && rpmdev-extract *rpm

# Copy wkhtmltopdf binary and dependency libraries for packaging
RUN mkdir -p $LAYER_DIR/{bin,lib} \
    && cp $TEMP_DIR/wkhtml*/usr/local/bin/* $LAYER_DIR/bin \
    && cp $TEMP_DIR/*/usr/lib64/* $LAYER_DIR/lib || :

# Zip files
RUN cd $LAYER_DIR \
    && zip -r $LAYER_ZIP bin lib \
    && mv $LAYER_ZIP /