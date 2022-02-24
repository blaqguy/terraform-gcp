# Terraform Hello World Web App
### This Repository deploys a Hello World Web App to GCP along with supporting services. 

## Requirements
- A GCP Account
- A project created within the GCP account
- A Service account with preferably admin credentials
- Supporting APIs Enabled API
> - Cloud Resource Manager API
> - Cloud Resource Manager V2
> - Compute Engine API
> - Service Network API
> - Identity and Access Management (IAM) API
- Access to Terraform

---
## Usage

- Clone the Repo
```bash
git clone https://github.com/blaqguy/terraform-gcp.git
```
- Change directory into our local repo and once more into the bootstrap directory
- Edit the variables in the script to the right values then run the script. It'll create several resources: A Project, Enable the API(s) we need to call in the project, create a Service Account within the project for Terraform and lastly download the Service Account API key
> If you created the required resources manually, just download your Service Account Key from GCP console and place in your local repo directory
- Edit the providers.tf file and update the values for the credentials parameter
- Update our variable values, I recommend creating a .tfvars file but you're free to update the default values directly in the variables.tf file
- Initialize the Directory
```bash
terraform init
```
- Output the Terraform Plan
```bash
terraform plan -out plan.out
```
- Apply our Plan
```bash
terraform apply plan.out
```
- Should everything have run successfully, navigate to your GCP console, then to the Load Balancer Service, click on our created http Load Balancer and navigate to the ip address
- Cleaning Up
```bash
terraform destroy --auto-approve
```
