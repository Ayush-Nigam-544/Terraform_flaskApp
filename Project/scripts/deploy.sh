#!/bin/bash

# Set AWS Region
AWS_REGION="us-east-1"  # Change this if needed
KEY_FILE="your-key.pem"  # Your SSH key file

# Get the latest running EC2 instance's Private IP
EC2_PRIVATE_IP=$(aws ec2 describe-instances \
    --region $AWS_REGION \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text | head -n 1)

if [[ -z "$EC2_PRIVATE_IP" ]]; then
    echo "❌ No running EC2 instance found!"
    exit 1
fi

echo "✅ Found EC2 instance at $EC2_PRIVATE_IP"

# Copy setup script
scp -i $KEY_FILE scripts/setup.sh ec2-user@$EC2_PRIVATE_IP:/home/ec2-user/

# Connect and execute setup script
ssh -i $KEY_FILE ec2-user@$EC2_PRIVATE_IP << EOF
    chmod +x /home/ec2-user/setup.sh
    /home/ec2-user/setup.sh
EOF

echo "🚀 Deployment completed successfully!"
