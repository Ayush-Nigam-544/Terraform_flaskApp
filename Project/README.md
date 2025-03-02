# AWS Terraform Flask Project

This project sets up a Flask application on AWS using Terraform.

## Prerequisites
1. Install **Terraform**
2. Have an **AWS account** with credentials configured.
3. Install **AWS CLI** and configure (`aws configure`).

## Steps to Run

### Step 1: Deploy Infrastructure
```sh
cd terraform
terraform init
terraform apply -auto-approve
```

### Step 2: Deploy Flask Application
```sh
scp -i your-key.pem scripts/setup.sh ec2-user@<EC2_PRIVATE_IP>:/home/ec2-user/
ssh -i your-key.pem ec2-user@<EC2_PRIVATE_IP>
chmod +x setup.sh
./setup.sh
```
scp -i id_rsa.pem -r scripts/ ec2-user@54.91.240.54:/home/ec2-user/ 
ssh -i id_rsa.pem ec2-user@54.91.240.54

### Step 3: Test the Application
Find the **ALB DNS Name** from Terraform output:
```sh
terraform output alb_dns_name
```
Open in browser:
```
http://<ALB-DNS-NAME>
```

✅ You should see:
```
Student: John Doe, Age: 22
```

## Cleanup
```sh
terraform destroy -auto-approve
```

## Notes
- Ensure your **EC2 security group** allows **outbound access** to **RDS on port 5432**.
- Update `db_user`, `db_password`, and `db_name` in Terraform files before deployment.