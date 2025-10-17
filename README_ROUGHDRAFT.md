**PROJECT OVERVIEW**
Create a custom Amazon Linux 2023 AMI using HashiCorp Packer that implements CIS benchmark
List of **CIS controls implemented**:
1. **Filesystem Configuration** - Ensure /tmp is configured with nodev, nosuid, noexec options - Set permissions on /etc/passwd, /etc/shadow, /etc/group 
2. **SSH Hardening** - Disable root login (PermitRootLogin no) - Set SSH Protocol to 2 - Disable empty passwords (PermitEmptyPasswords no) - Set ClientAliveInterval and ClientAliveCountMax 
3. **User Account Management** - Set password expiration policies (PASS_MAX_DAYS, PASS_MIN_DAYS) - Configure password complexity requirements 
4. **System Auditing** - Enable and configure auditd service - Add basic audit rules for sensitive file monitoring 
5. **Network Security** - Disable IPv6 if not needed - Enable TCP SYN cookies - Disable ICMP redirects

**PREREQUISITES**
Install packer **vPacker v1.14.2** with CLI: 
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

**Required Plugin** packer-ami-project packer plugins install github.com/hashicorp/amazon 

**Packer Install Troubleshooting**
Encountered wicked problem with duplicate files
DEVOPS grep -r "baltocdn.com" /etc/apt/sources.list.d/

/etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list:deb https://baltocdn.com/helm/stable/debian/ all main
/etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list:# deb-src https:/baltocdn.com/helm/stable/debian/ all main
➜  
DEVOPS sudo rm /etc/apt/sources.list.d/archive_uri-https_baltocdn_com_helm_stable_debian_-noble.list

Install packer: sudo apt install packer
Verified install was successful Packer v1.14.2                                           

The following plugins are required, but not installed:

* github.com/hashicorp/amazon >= 1.0.0

Did you run packer init for this project ?


➜  packer-ami-project packer plugins install github.com/hashicorp/amazon                                                                                       

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

Update script template.pkr.hcl
Update script cis-hardening.sh
Update httpd-setup.sh

packer.validate template.pkr.hcl
error on line 40 
use this = temporary_security_group_source_cidrs = "[0.0.0.0/0]"

packer build template.pkr.hcl
!!!!!!!!!!!!!!!!Packer Validated and Created AWS AMI!!!!!!!!!!!!!!!!!!!!!!!!!
Verified on AWS

**Git Repository Creation**
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

**Create AWS ECS from AMI**
AMI created and verified on AWS. -see screenshot-
Created new EC2 instance - ec2-user@ip-172-31-25-246
ssh -i ~/devops-key.pem ec2-user@18.217.255.243
Confirmed CIS SSH Hardening: sudo grep -E "PermitRootLogin|Protocol|PermitEmptyPasswords" /etc/ssh/sshd_config
Confirmed HTTP Apache Server: curl http://localhost

**Terminate Cleanup**
1. Deregister the AMI
This removes the AMI from your account but does not delete associated snapshots.
🔧 Steps:
- Go to the EC2 Dashboard in AWS Console.
- Click AMIs in the left sidebar.
- Select your custom AMI.
- Click Actions > Deregister.
- Confirm the deregistration.
📝 Note: Deregistering an AMI makes it unusable for launching new instances, but the snapshot remains.


2. Delete Associated Snapshots
After deregistering, you’ll need to manually delete the EBS snapshot created during the AMI build.
🔧 Steps:
- In the EC2 Dashboard, click Snapshots.
- Find the snapshot linked to your AMI (check the Description or Tags).
- Select the snapshot and click Actions > Delete Snapshot.
- Confirm deletion.
💡 Tip: You can tag your AMI and snapshot during Packer build to make them easier to identify.