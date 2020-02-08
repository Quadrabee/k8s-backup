#!/usr/bin/env sh
set -eo pipefail

#
# Database backups functions
#

check_db_params(){
  if [ -z "$BACKUP_DB_DRIVER" ]; then
    die "Missing env var BACKUP_DB_DRIVER"
  elif [ -z "$BACKUP_DB_HOST" ]; then
    die "Missing env var BACKUP_DB_HOST"
  elif [ -z "$BACKUP_DB_USER" ]; then
    die "Missing env var BACKUP_DB_USER"
  elif [ -z "$BACKUP_DB_PASSWORD" ]; then
    die "Missing env var BACKUP_DB_PASSWORD"
  elif [ -z "$BACKUP_DB_DATABASE" ]; then
    die "Missing env var BACKUP_DB_DATABASE"
  fi
}

backup_db(){
  if [ "$BACKUP_DB_DRIVER" == "postgres" ]; then
    backup_postgres
  elif [ "$BACKUP_DB_DRIVER" == "mysql" ]; then
    backup_mysql
  else
    die "BACKUP_DB_DRIVER not set"
  fi
}

backup_postgres(){
  check_db_params
  export PGPASSWORD="$BACKUP_DB_PASSWORD"
  pg_dump -U "$BACKUP_DB_USER" \
    -h "$BACKUP_DB_HOST" \
    -d "$BACKUP_DB_DATABASE" \
    $BACKUP_DB_EXTRA_ARGS > /tmp/db-backup.sql

  handle_backup_file /tmp/db-backup.sql
}

backup_mysql(){
  echo "Backuping mysql: $BACKUP_DB_USER@$BACKUP_DB_HOST/$BACKUP_DB_DATABASE"
  check_db_params
  mysqldump -u "$BACKUP_DB_USER" \
    --password="$BACKUP_DB_PASSWORD" \
    -h "$BACKUP_DB_HOST" \
    $BACKUP_DB_EXTRA_ARGS \
    "$BACKUP_DB_DATABASE" > /tmp/db-backup.sql

  handle_backup_file /tmp/db-backup.sql
}
