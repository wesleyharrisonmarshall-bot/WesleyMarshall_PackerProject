#!/bin/bash

LOG_FILE="/var/log/httpd-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting Apache HTTP server setup at $(date)"
set -e

########################################
# 1. Install Apache HTTP server
########################################
echo "[Step 1] Installing httpd..."
dnf install -y httpd

########################################
# 2. Create custom index.html
########################################
echo "[Step 2] Creating custom index.html..."

AMI_DATE=$(date +"%Y-%m-%d")
TEAM_NAME="Wesley Marshall / RowCore Pod™"
CIS_LIST="<ul>
  <li>1.1.1.1 – Secure /tmp mount</li>
  <li>5.2.8 – Disable SSH root login</li>
  <li>5.4.1.1 & 5.4.1.2 – Password aging</li>
  <li>4.1.1.1 – Enable auditd</li>
  <li>3.3.1 & 3.3.2 – Disable IPv6</li>
</ul>"

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Hardened AMI</title>
</head>
<body>
  <h1>Welcome to your hardened AMI</h1>
  <p><strong>Team:</strong> $TEAM_NAME</p>
  <p><strong>AMI Creation Date:</strong> $AMI_DATE</p>
  <p><strong>CIS Benchmarks Implemented:</strong></p>
  $CIS_LIST
</body>
</html>
EOF

########################################
# 3. Configure httpd to start on boot
########################################
echo "[Step 3] Enabling httpd to start on boot..."
systemctl enable httpd

########################################
# 4. Ensure httpd is running
########################################
echo "[Step 4] Starting httpd service..."
systemctl start httpd
systemctl status httpd || echo "Warning: httpd service not running"

########################################
# 5. Configure basic security settings
########################################
echo "[Step 5] Configuring httpd security headers..."

HTTPD_CONF="/etc/httpd/conf/httpd.conf"

# Set ServerTokens to Prod
if grep -q "^ServerTokens" "$HTTPD_CONF"; then
  sed -i 's/^ServerTokens.*/ServerTokens Prod/' "$HTTPD_CONF"
else
  echo "ServerTokens Prod" >> "$HTTPD_CONF"
fi

# Set ServerSignature to Off
if grep -q "^ServerSignature" "$HTTPD_CONF"; then
  sed -i 's/^ServerSignature.*/ServerSignature Off/' "$HTTPD_CONF"
else
  echo "ServerSignature Off" >> "$HTTPD_CONF"
fi

systemctl restart httpd

echo "Apache HTTP server setup completed successfully at $(date)"
exit 0