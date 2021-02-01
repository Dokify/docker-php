#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec bash <<EOF
  chown root:root -R /root/.ssh
  chmod 0600 -R /root/.ssh
  /usr/sbin/sshd
  "$@"
EOF