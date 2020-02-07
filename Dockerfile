FROM alpine:3.7

RUN apk update \
    && apk add --update \
        postgresql-client \
        mysql-client \
        gnupg \
        vim \
        zip \
        bzip2 \
        curl \
        bash \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        py-setuptools \
        git \
        ca-certificates \
  && rm -rf /var/cache/apk/* \
  && curl https://sdk.cloud.google.com | bash -s -- --disable-prompts

RUN pip install python-dateutil
RUN pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm -rf /var/cache/apk/*

ENV PATH="$PATH:/root/google-cloud-sdk/bin/" \
    BACKUP_COMPRESS="true"\
    BACKUP_COMPRESS_FORMAT="gz"\
    BACKUP_ENCRYPT="false"\
    BACKUP_ENCRYPT_KEY=""\
    BACKUP_ENCRYPT_RECIPIENT=""\
    BACKUP_DB=false \
    BACKUP_DB_DRIVER="" \
    BACKUP_DB_HOST="" \
    BACKUP_DB_USER="" \
    BACKUP_DB_PASSWORD="" \
    BACKUP_DB_DATABASE="" \
    BACKUP_DB_EXTRA_ARGS="" \
    BACKUP_DATE_FORMAT="+%Y-%m-%d-%H:%M:%S" \
    BACKUP_PREFIX="{{DATE}}-" \
    BACKUP_UPLOAD="false" \
    BACKUP_UPLOAD_METHOD="" \
    BACKUP_UPLOAD_GS_KEY_FILE=""\
    BACKUP_UPLOAD_GS_PATH="" \
    BACKUP_UPLOAD_S3_SECRET_ACCESS_KEY="" \
    BACKUP_UPLOAD_S3_ACCESS_KEY_ID=""\
    BACKUP_UPLOAD_S3_REGION=""\
    BACKUP_UPLOAD_S3_PATH=""

COPY files/init.sh /usr/sbin/
COPY files/backup_scripts /usr/sbin/backup_scripts

CMD ["/usr/sbin/init.sh"]
