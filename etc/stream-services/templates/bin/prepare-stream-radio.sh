#!/bin/sh

pkill -9 -f "/etc/stream-services/start.conf"

[ -d /var/run/stream-services ] || mkdir /var/run/stream-services
chmod 775 /var/run/stream-services
chown audiostream /var/run/stream-services

[ -f /var/run/stream-services/stream-services.pid ] && rm /var/run/stream-services/stream-services.pid

[ -d /var/log/stream-services/ ] || mkdir /var/log/stream-services/
chmod 755 /var/log/stream-services
chown audiostream:www-data /var/log/stream-services/
[ -f /var/log/stream-services/radio.log ] && chmod 664 /var/log/stream-services/radio.log
[ -f /var/log/stream-services/radio.log ] && chown audiostream:www-data /var/log/stream-services/radio.log

exit 0
