#!/usr/bin/env bash
# Requires awscli and local IAM account with sufficient permissions

# Verify AWS CLI Credentials are setup
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
if ! grep -q aws_access_key_id ~/.aws/config; then
  if ! grep -q aws_access_key_id ~/.aws/credentials; then
    echo "AWS config not found or CLI not installed. Please run \"aws configure\"."
    exit 1
  fi
fi

echo "This script will create IAM user, generate IAM keys, add to IAM group, generate user policy."
read -r -p "Enter the user name: " USER

echo " "
echo "====================================================="
echo "Creating IAM User: "$USER
aws iam create-user --user-name $USER --output json
echo "====================================================="
echo " "
echo "====================================================="
echo "Generating IAM Access Keys"
aws iam create-access-key --user-name $USER --output json
echo "====================================================="
echo " "
echo "====================================================="
echo "Adding to IAM Group"
aws iam add-user-to-group --user-name $USER --group-name devusers

cat > userpolicy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Deny",
            "Action": "cloudtrail:*",
            "Resource": "*"
        }
    ]
}
EOL
echo " "
echo "====================================================="
echo "Generating User Policy"
aws iam put-user-policy --user-name $USER --policy-name $USER-ec2-cloudtrail --policy-document file://userpolicy.json
rm userpolicy.json
echo " "
echo "====================================================="
echo "Completed!  Created user: "$USER
echo "====================================================="