#!/usr/bin/with-contenv bash
set -e

TP_CONF="/etc/tinyproxy/tinyproxy.conf"

: ${LISTEN_PORT:=8888}
: ${ALLOWED:="127.0.0.1"}
: ${CONNECT_PORTS:="443 563"}
: ${LOG_TO_SYSLOG:="Yes"}
: ${LOG_LEVEL:="Info"}
: ${MAXCLIENTS:="100"}
: ${MINSPARESERVERS:="10"}
: ${MAXSPARESERVERS:="20"}
: ${STARTSERVERS:="10"}
: ${REVERSE:="No"}

if [[ ! -f $TP_CONF ]]
 then
	cat > $TP_CONF <<EOF
User app
Group app
Port $LISTEN_PORT
Syslog $LOG_TO_SYSLOG
LogLevel $LOG_LEVEL
PidFile "/tmp/tinyproxy.pid"
XTinyproxy Yes
MaxClients $MAXCLIENTS
MinSpareServers $MINSPARESERVERS
MaxSpareServers $MAXSPARESERVERS
StartServers $STARTSERVERS
PidFile "/tmp/tinyproxy.pid"
XTinyproxy Off
DisableViaHeader On
ReverseOnly $REVERSE
EOF

for a in $ALLOWED
 do
	echo "Allow $a" >> $TP_CONF
done

for p in $CONNECT_PORTS
 do
	echo "ConnectPort $p" >> $TP_CONF
done
fi

chown -R app:app /var/log/tinyproxy
