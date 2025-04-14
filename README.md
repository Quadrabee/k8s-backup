# k8s-backup

Simple docker image to facilitate backup creation, encryption & upload.

## Env Vars

| Env var                   | default             | possible values | description |
|---------------------------| --------------------| ----------------| ----------------------|
| BACKUP_COMPRESS                    | true                |                        | compress backup files |
| BACKUP_COMPRESS_FORMAT             | gz                  |    gz, bz2, zip        | compression format |
| BACKUP_ENCRYPT                     | false               |                        | encrypt the backup files |
| BACKUP_ENCRYPT_KEY                 |                     |                        | valid pgp public key |
| BACKUP_ENCRYPT_RECIPIENT           |                     |                        | email address associated with the public key |
| BACKUP_DB                          | false               |                        | export and backup a database |
| BACKUP_DB_DRIVER                   |                     | mysql, postgres, redis | database engine |
| BACKUP_DB_HOST                     |                     |                        | db hostname |
| BACKUP_DB_USER                     |                     |                        | db user; TODO for redis |
| BACKUP_DB_PASSWORD                 |                     |                        | db password; TODO for redis |
| BACKUP_DB_DATABASE                 |                     |                        | db name; TODO for redis |
| BACKUP_DB_EXTRA_ARGS               |                     |                        | extra args to provide to pg_dump/mysqldump/redis-cli |
| BACKUP_DATE_FORMAT                 | +%Y-%m-%d-%H:%M:%S" |   `date` format        | format to use for dates |
| BACKUP_PREFIX                      | {{DATE}}-"          |                        | prefix to use for backup files |
| BACKUP_UPLOAD                      | false               |                        | upload the backups somewhere |
| BACKUP_UPLOAD_METHOD               |                     |          gs, s3        | type of destination |
| BACKUP_UPLOAD_GS_KEY_FILE          |                     |                        | path to gcloud key | |
| BACKUP_UPLOAD_GS_PATH              |                     |                        | destination path (gs://bucket/subfolder/) |
| BACKUP_UPLOAD_S3_SECRET_ACCESS_KEY |                     |                        | secret key for S3 |
| BACKUP_UPLOAD_S3_ACCESS_KEY_ID     |                     |                        | access key for S3 |
| BACKUP_UPLOAD_S3_REGION            |                     |                        | AWS region for S3 |
| BACKUP_UPLOAD_S3_PATH              |                     |                        | S3 path to store the backup into |
| BACKUP_UPLOAD_S3_ENDPOINT          | ""                  |                        | S3 endpoint, __ONLY__ for not AWS |

## Examples

See the [example folder](https://github.com/Quadrabee/k8s-backup/tree/master/examples/kubernetes) to see how to use this image with kubernetes to implement a daily db backup with [Kubernetes' CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

## Tasks

- add support for ftp, sftp
- add support for prometheus metrics publication
- add support for simple files/folders backup
- add support for redis-cli URI enabling authentication, DB selection and custom port as described in [Redis doc](https://redis.io/docs/connect/cli/#host-port-password-and-database)
