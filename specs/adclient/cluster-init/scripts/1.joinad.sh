#!/bin/bash

NAMESERVER=$(jetpack config adjoin.ad_server)

echo "supersede domain-name-servers ${NAMESERVER};" > /etc/dhcp/dhclient.conf
echo "append domain-name-servers 168.63.129.16;" >> /etc/dhcp/dhclient.conf
systemctl restart NetworkManager

sleep 10

ADMIN_DOMAIN=$(jetpack config adjoin.ad_domain)
ADMIN_NAME=$(jetpack config adjoin.ad_admin)
ADMIN_PASSWORD=$(jetpack config adjoin.ad_password)

echo $ADMIN_PASSWORD| realm join -U $ADMIN_NAME $ADMIN_DOMAIN --verbose

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

sed -i 's@override_homedir.*@override_homedir = /shared/home/%u@' /etc/sssd/sssd.conf 
sed -i 's@fallback_homedir.*@fallback_homedir = /shared/home/%u@' /etc/sssd/sssd.conf
sed -i 's@use_fully_qualified_names.*@use_fully_qualified_names = False@' /etc/sssd/sssd.conf
systemctl restart sssd

cat <<EOF >/etc/ssh/ssh_config
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
