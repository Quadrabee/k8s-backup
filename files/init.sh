#!/usr/bin/env sh
set -eo pipefail

. /usr/sbin/backup_scripts/global.sh

#
# Database backups
#

if [ ! -z "$BACKUP_DB" ]; then
  backup_db
fi
