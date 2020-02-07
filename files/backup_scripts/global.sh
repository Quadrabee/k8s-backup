#!/usr/bin/env sh
set -eo pipefail

. /usr/sbin/backup_scripts/db_backups_functions.sh
. /usr/sbin/backup_scripts/upload_functions.sh

# Die handler
die () {
  echo "$0: $@" >&2
  exit 1;
}

# Check environment vars for encryption settings
check_encrypt(){
  if [ "$BACKUP_ENCRYPT" = "true" -a -z "$BACKUP_ENCRYPT_KEY" ]; then
    die "BACKUP_ENCRYPT_KEY missing"
  fi
  printf -- "$BACKUP_ENCRYPT_KEY" > /tmp/key.pub
  gpg --import /tmp/key.pub
}

# Encrypt a file
encrypt () {
  check_encrypt
  echo "Encrypting backup file $1"
  gpg --yes --trust-model always -e -r "$BACKUP_ENCRYPT_RECIPIENT" $1
}

# Compress a file
compress () {
  if [ "$BACKUP_COMPRESS_FORMAT" = "zip" ]; then
    zip $1.zip $1
  elif [ "$BACKUP_COMPRESS_FORMAT" = "gz" ]; then
    gzip $1
  elif [ "$BACKUP_COMPRESS_FORMAT" = "bz2" ]; then
    bzip2 $1
  else
    die "Unsupported BACKUP_COMPRESS_FORMAT: $BACKUP_COMPRESS_FORMAT"
  fi
}

handle_backup_file () {
  FNAME=`basename $1`
  echo "Handling backup file $FNAME"
  DATE=`date $BACKUP_DATE_FORMAT`
  PREFIX="${BACKUP_PREFIX/\{\{DATE\}\}/$DATE}"

  BACKUP_FILE="/tmp/$PREFIX$FNAME"
  mv $1 $BACKUP_FILE

  if [ "$BACKUP_COMPRESS" = "true" ]; then
    echo "Compressing backup file $BACKUP_FILE"
    compress $BACKUP_FILE
    BACKUP_FILE="$BACKUP_FILE.$BACKUP_COMPRESS_FORMAT"
  fi

  if [ "$BACKUP_ENCRYPT" = "true" ]; then
    echo "Encrypting backup file $BACKUP_FILE"
    encrypt $BACKUP_FILE
    BACKUP_FILE="$BACKUP_FILE.gpg"
  fi

  if [ "$BACKUP_UPLOAD" = "true" ]; then
    echo "Uploading backup file $BACKUP_FILE"
    upload_backup $BACKUP_FILE
  fi
}
