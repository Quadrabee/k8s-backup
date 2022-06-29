#!/usr/bin/env sh
set -eo pipefail

#
# Upload backups functions
#

upload_backup_googlestorage(){
  echo "Uploading $1 to googlestorage"

  if [ -z "$BACKUP_UPLOAD_GS_KEY_FILE" ]; then
    die "Missing env var BACKUP_UPLOAD_GS_KEY_FILE"
  fi

  if [ ! -e "$BACKUP_UPLOAD_GS_KEY_FILE" ]; then
    die "Missing gcloud key file: $BACKUP_UPLOAD_GS_KEY_FILE"
  fi

  if [ -z "$BACKUP_UPLOAD_GS_PATH" ]; then
    die "Missing env var BACKUP_UPLOAD_GS_PATH"
  fi

  gcloud auth activate-service-account --key-file $BACKUP_UPLOAD_GS_KEY_FILE
  gsutil cp $1 $BACKUP_UPLOAD_GS_PATH
}

upload_backup_S3(){
  echo "Uploading $1 to S3"

  if [ -z "$BACKUP_UPLOAD_S3_ACCESS_KEY_ID" ]; then
    die "Missing env var BACKUP_UPLOAD_S3_ACCESS_KEY_ID"
  fi

  if [ -z "$BACKUP_UPLOAD_S3_SECRET_ACCESS_KEY" ]; then
    die "Missing env var BACKUP_UPLOAD_S3_SECRET_ACCESS_KEY"
  fi

  if [ -z "$BACKUP_UPLOAD_S3_REGION" ]; then
    die "Missing env var BACKUP_UPLOAD_S3_REGION"
  fi

  if [ -z "$BACKUP_UPLOAD_S3_PATH" ]; then
    die "Missing env var BACKUP_UPLOAD_S3_PATH"
  fi

  export AWS_SECRET_ACCESS_KEY=$BACKUP_UPLOAD_S3_SECRET_ACCESS_KEY
  export AWS_ACCESS_KEY_ID=$BACKUP_UPLOAD_S3_ACCESS_KEY_ID
  export AWS_DEFAULT_REGION=$BACKUP_UPLOAD_S3_REGION
  
  aws --endpoint-url $BACKUP_UPLOAD_S3_ENDPOINT s3 cp $1 $BACKUP_UPLOAD_S3_PATH
}

upload_backup(){
  echo "Uploading backup file $1"

  if [ -z "$BACKUP_UPLOAD_METHOD" ]; then
    die "Missing env var BACKUP_UPLOAD_METHOD"
  fi

  if [ "$BACKUP_UPLOAD_METHOD" = "googlestorage" ] ||
     [ "$BACKUP_UPLOAD_METHOD" = "gs" ]; then
     upload_backup_googlestorage $1
  elif [ "$BACKUP_UPLOAD_METHOD" = "s3" ]; then
     upload_backup_S3 $1
  else
    die "Unknown BACKUP_UPLOAD_METHOD: $BACKUP_UPLOAD_METHOD"
  fi
}
