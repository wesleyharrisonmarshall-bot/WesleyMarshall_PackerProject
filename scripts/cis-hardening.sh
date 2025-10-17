#!/bin/bash

LOG_FILE="/var/log/cis-hardening.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting CIS hardening at $(date)"
set -e

# 1. Filesystem Configuration (CIS 1.1.1.1)
echo "[Filesystem] Securing /tmp mount options..."
if grep -q '/tmp' /etc/fstab; then
  sed -i '/\/tmp/ s/defaults.*/defaults,nodev,nosuid,noexec/' /etc/fstab
else
  echo "tmpfs /tmp tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
fi
mount -o remount /tmp || echo "Warning: /tmp remount failed"

# 2. SSH Hardening (CIS 5.2.8)
echo "[SSH] Disabling root login..."
SSHD_CONFIG="/etc/ssh/sshd_config"
if grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
  sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
else
  echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi
systemctl restart sshd || echo "Warning: SSH restart failed"

# 3. User Account Management (CIS 5.4.1.1 & 5.4.1.2)
echo "[User Management] Setting password expiration policies..."
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs

# 4. System Auditing (CIS 4.1.1.1)
echo "[Auditing] Installing and enabling auditd..."
yum install -y audit || dnf install -y audit
systemctl enable auditd
systemctl start auditd

# 5. Network Security (CIS 3.3.1 & 3.3.2)
echo "[Network] Disabling IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

echo "CIS hardening completed successfully at $(date)"
exit 0