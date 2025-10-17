**Hardened Amazon Linux 2023 AMI with Packer**

This project automates the creation of a secure, CIS-compliant Amazon Linux 2023 AMI using HashiCorp Packer. It provisions a hardened operating system, installs and configures Apache httpd, and validates infrastructure readiness with embedded screenshots and audit-ready scripting.

**Objective**

Build a custom Amazon Linux 2023 AMI using Packer that:

Implements CIS Level 1 security benchmarks

Installs and configures Apache httpd with a branded index page

Automates infrastructure setup using bash scripts

Documents and verifies all controls for audit and compliance

**Learning Outcomes**

Apply Infrastructure as Code principles using Packer

Implement CIS benchmark controls for Linux hardening

Automate AMI creation and provisioning in AWS

Practice bash scripting for secure system configuration

**Prerequisites**

AWS account with EC2 and IAM permissions

Packer v1.14.2+ installed

AWS CLI configured with credentials

Basic understanding of Linux and bash scripting

**Project Structure**

packer-ami-project/
├── template.pkr.hcl
├── README.md
├── scripts/
│   ├── cis-hardening.sh
│   └── httpd-setup.sh
├── screenshots/
│   ├── AMI_Build_Complete_YIPPEE.png
│   ├── Packer_Validated.png
│   ├── Custom_HTTPD_Page.png
│   └── EC2_Launch_Instance.png

Installed plugin github.com/hashicorp/amazon v1.5.0 in "/home/wesley/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.5.0_x5.0_linux_amd64"
Open and update VSCode
Verify pwd
cd 05_Packers
mkdir -p packer-ami-projects
cd packer-ami-projects
touch template.pkr.hcl
touch README.md
mkdir scripts
ls -l
verified file structure
cd scripts
touch cis-hardening.sh
touch httpd-setup.sh

**Packer Configuration**

Update script template.pkr.hcl in VSCode

Source Settings

Base AMI: Amazon Linux 2023

Instance type: t3.micro

Region: us-east-2

SSH username: ec2-user

Build Settings

AMI tagged with project metadata

Temporary security group for SSH access

AMI name includes timestamp

Provisioners

cis-hardening.sh: applies CIS benchmark controls

httpd-setup.sh: installs and configures Apache httpd

**CIS Benchmarks Implemented**

Update script cis-hardening.sh in VSCode

The following controls are enforced via cis-hardening.sh:

1. Filesystem hardening (/tmp with nodev, nosuid, noexec)

2. SSH configuration: disables root login, enforces protocol 2, disables empty passwords

3. Password aging and complexity policies

4. Auditd setup with rules for sensitive file monitoring

5. Network hardening: disables IPv6, ICMP redirects, enables SYN cookies

6. File permissions: locks down /etc/passwd, /etc/shadow, /etc/group

7. Login banner: sets /etc/issue.net with compliance notice

All changes are logged to /var/log/cis-hardening.log.

**Apache Setup**

Update httpd-setup.sh in VSCode

The httpd-setup.sh script:

Installs Apache httpd and mod_ssl

Creates a custom index.html with:

Team name: Wesley Marshall 

AMI creation date

List of implemented CIS controls

Configures Apache to start on boot

Applies basic security settings (ServerTokens, ServerSignature)

**Verification Steps**

After launching an EC2 instance from your AMI:

1. SSH into the instance

ssh -i ~/devops-key.pem ec2-user@18.217.255.243

2. Verify CIS controls

sudo grep -E "PermitRootLogin|Protocol|PermitEmptyPasswords" /etc/ssh/sshd_config
grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS" /etc/login.defs
sudo systemctl status auditd

3. Test Apache response

curl http://localhost

Expected Output:

<h1>Welcome to your hardened AMI</h1>
<p><strong>Team:</strong> Wesley Marshall</p>
<p><strong>AMI Creation Date:</strong> 2025-10-17</p>
<p><strong>CIS Benchmarks Implemented:</strong></p>
<ul>
  <li>1.1.1.1 – Secure /tmp mount</li>
  <li>5.2.8 – Disable SSH root login</li>
  <li>5.4.1.1 & 5.4.1.2 – Password aging</li>
  <li>4.1.1.1 – Enable auditd</li>
  <li>3.3.1 & 3.3.2 – Disable IPv6</li>
</ul>

**Cleanup Instructions**

To avoid AWS charges:

1. Deregister the AMI

Go to EC2 > AMIs

Select your AMI > Actions > Deregister

2. Delete associated snapshots

Go to EC2 > Snapshots

Find the snapshot linked to your AMI

Select > Actions > Delete Snapshot

**GitHub Repository Creation**

Created wes_packerproject, public, enabled read me
SSH git@github.com:wesleyharrisonmarshall-bot/wes_packerproject.git
GitHub CLI gh repo clone wesleyharrisonmarshall-bot/wes_packerproject
ssh-keygen -t rsa, saved in packer-project-ami folder, no pass
git clone git@github.com:wesleyharrisonmarshall-bot/wes_packerproject.git
git config --global user.email "wesleyharrisonmarshall@gmail.com"
git init
git branch -m main
git remote add origin https://github.com/wesleyhmarshall/packer-ami-project.git
git add .
I couldn't login using username and password
ssh-keygen -t ed25519 -C "wesleyharrisonmarshall@gmail.com"
cat ~/.ssh/id_ed25519.pub
git remote set-url origin git@github.com:wesleyhmarshall/packer-ami-project.git
ssh -T git@github.com  
Hi wesleyharrisonmarshall-bot! You've successfully authenticated, but GitHub does not provide shell access.


**Deliverables**

template.pkr.hcl

scripts/cis-hardening.sh and httpd-setup.sh

README.md with full documentation

Screenshots of AMI creation and Apache response

Brief report describing:

Which CIS benchmarks were implemented and why

Challenges faced and how they were resolved

How the implementation was tested and verified

**Problems Encountered**

1. When Installing Packer v1.14.2 with CLI:
Install packer vPacker v1.14.2 with CLI:
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install packer

Required Plugin packer-ami-project packer plugins install github.com/hashicorp/amazon

Encountered wicked problem with duplicate files
DEVOPS grep -r "baltocdn.com" /etc/apt/sources.list.d/
/etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list:deb https://baltocdn.com/helm/stable/debian/ all main
/etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list:# deb-src https:/baltocdn.com/helm/stable/debian/ all main

------Solution-----
DEVOPS sudo rm /etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list
Install packer: sudo apt install packer
Verified install was successful Packer v1.14.2
The following plugins are required, but not installed:
⦁	github.com/hashicorp/amazon >= 1.0.0
Did you run packer init for this project ?

2. I couldn't login to GitHub in VSCode CLI using username and password

GitHub disabled password-based authentication for Git operations in August 2021. You now need to use:
- SSH keys (as you did)
- Or personal access tokens (PATs) for HTTPS

------Solution-----
ssh-keygen -t ed25519 -C "wesleyharrisonmarshall@gmail.com"
cat ~/.ssh/id_ed25519.pub
git remote set-url origin git@github.com:wesleyhmarshall/packer-ami-project.git
ssh -T git@github.com  
Hi wesleyharrisonmarshall-bot! You've successfully authenticated, but GitHub does not provide shell access.

3. Numerous failures to build AMI due to coding format issues
    - packer.validate template.pkr.hcl
error on line 40
use this = temporary_security_group_source_cidrs = "[0.0.0.0/0]"

