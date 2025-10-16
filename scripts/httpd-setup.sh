### Part 4: HTTP Server Setup (15 points) 
Create `scripts/httpd-setup.sh` that: 
1. Installs Apache HTTP server (httpd) 
2. Creates a custom index.html with: - Your name/team name - AMI creation date 
- List of CIS benchmarks implemented 
3. Configures httpd to start on boot 
4. Ensures httpd service is running 
5. Configures basic security settings (ServerTokens, ServerSignature)