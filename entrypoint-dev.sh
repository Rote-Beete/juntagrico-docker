#!/bin/sh

set -e

echo "Running in devmode. Fixing permissions."
REAL_UID="$(stat -c '%u' /home/app/web/manage.py)"
REAL_GID="$(stat -c '%g' /home/app/web/manage.py)"
echo "Determined ${REAL_UID}:${REAL_GID} as ids to use"

sed -i "s/:1000:1000:/:${REAL_UID}:${REAL_GID}:/" /etc/passwd
sed -i "s/:1000:/:${REAL_GID}:/" /etc/group
chown -R app:app \
       "$PROJECT_HOME"

echo "Executing command with dropped privileges"
echo "Command: $@"
exec runuser -u app -- "$@"
