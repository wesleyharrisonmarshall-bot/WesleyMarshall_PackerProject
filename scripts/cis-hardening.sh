#!/bin/bash

LOG_FILE="/var/log/cis-hardening.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting CIS hardening at $(date)"

# Exit on error
set -e

# Helper function
update_sshd_config() {
  local key="$1"
  local value="$2"
  local file="/etc/ssh/sshd_config"
  if grep -q "^${key}" "$file"; then
    sed -i "s/^${key}.*/${key} ${value}/" "$file"
  else
    echo "${key} ${value}" >> "$file"
  fi
}

########################################
# 1. Filesystem Configuration
########################################
echo "Configuring /tmp mount options..."

if ! grep -q '/tmp' /etc/fstab; then
  echo "tmpfs /tmp tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
  mount -o remount /tmp
else
  sed -i '/\/tmp/ s/defaults.*/defaults,nodev,nosuid,noexec/' /etc/fstab
  mount -o remount /tmp
fi

echo "Setting permissions on sensitive files..."
chmod 644 /etc/passwd
chmod 640 /etc/group
chmod 000 /etc/shadow

########################################
# 2. SSH Hardening
########################################
echo "Hardening SSH configuration..."

update_sshd_config "PermitRootLogin" "no"
update_sshd_config "Protocol" "2"
update_sshd_config "PermitEmptyPasswords" "no"
update_sshd_config "ClientAliveInterval" "300"
update_sshd_config "ClientAliveCountMax" "0"

systemctl restart sshd

########################################
# 3. User Account Management
########################################
echo "Setting password expiration policies..."

sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs

echo "Configuring password complexity..."
authconfig --update --passalgo=sha512 --enablefaillock --enablepamaccess

########################################
# 4. System Auditing
########################################
echo "Enabling auditd and adding basic rules..."

yum install -y audit
systemctl enable auditd
systemctl start auditd

cat <<EOF > /etc/audit/rules.d/cis.rules
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/group -p wa -k identity
EOF

augenrules --load

########################################
# 5. Network Security
########################################
echo "Configuring network security..."

echo "Disabling IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

echo "Enabling TCP SYN cookies..."
sysctl -w net.ipv4.tcp_syncookies=1

echo "Disabling ICMP redirects..."
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0

sysctl -p

echo "CIS hardening completed successfully at $(date)"
exit 0

