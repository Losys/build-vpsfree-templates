DISTNAME=ubuntu
RELVER=14.04
RELNAME=trusty
BASEURL=http://cz.archive.ubuntu.com/ubuntu/

. $INCLUDE/debian.sh

bootstrap
configure-common

cat > $INSTALL/etc/apt/sources.list <<SOURCES
deb $BASEURL $RELNAME main restricted universe multiverse
deb $BASEURL $RELNAME-security main restricted universe multiverse
deb $BASEURL $RELNAME-updates main restricted universe multiverse
SOURCES

configure-debian

configure-append <<EOF
sed -i -e 's/^\\\$ModLoad imklog/#\\\$ModLoad imklog/g' /etc/rsyslog.conf
sed -i -e 's/^PermitRootLogin\ without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
cat > /etc/init/tty0.conf <<"TTY0"
start on stopped rc or RUNLEVEL=[2345]
stop on runlevel [!2345]
respawn
exec /sbin/getty -L 38400 tty0 vt102
TTY0
EOF

run-configure
