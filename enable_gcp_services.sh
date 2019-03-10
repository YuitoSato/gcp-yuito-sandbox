#!/usr/bin/env bash

# Cloud Build
gcloud services enable cloudbuild.googleapis.com

# GKE
gcloud services enable container.googleapis.com

# GCR
gcloud services enable containerregistry.googleapis.com

# Google Cloud Source Repository
gcloud services enable sourcerepo.googleapis.com

