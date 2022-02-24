#!/bin/bash

# Exit on Error | Execute this script with bash -x if you want to print command before executing, helpful for debugging
set -Eeuo pipefail

# Variables
# Project name must be at least 6 characters | The RANDOM variable generates random number(s), this is to make sure our name is unique
PROJECT_NAME="assessment"$RANDOM
PROJECT_APIS=("cloudresourcemanager.googleapis.com" "compute.googleapis.com" "servicenetworking.googleapis.com" "iam.googleapis.com")
SERVICE_ACCOUNT_NAME="terraform"
SERVICE_ACCOUNT_ROLE="roles/owner"
BILLING_ACCOUNT_ID="<>"

# This block deploys our GCP resources
# Create a Project
gcloud projects create $PROJECT_NAME

# Associate Project with billing account in order to utilize GCP services (REQUIRED!)
# This functionality is in beta currently.
# To Grab the IDs for your billing account run: gcloud alpha billing accounts list (This Functionality is in Alpha)
gcloud beta billing projects link $PROJECT_NAME --billing-account=$BILLING_ACCOUNT_ID

# Enable APIs within your create project
gcloud config set project $PROJECT_NAME
for api in ${PROJECT_APIS[@]}; do
  gcloud services enable $api
done

# Create Service Account for Terraform
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --display-name=$SERVICE_ACCOUNT_NAME

# Add Role (Permissions) to Service Account
gcloud projects add-iam-policy-binding $PROJECT_NAME \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com" \
    --role=$SERVICE_ACCOUNT_ROLE

# Create API Key for our Service account and Download it to your machine
gcloud iam service-accounts keys create $SERVICE_ACCOUNT_NAME \
    --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com
