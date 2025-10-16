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

**Creating File Structure**
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

**Git Repository Creation**
Created WesleyMarshal_PackerProject, public, did not enabled read me
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
git push -u origin main
I CAN SEE MY WORK ON GITHUB!!!!!
