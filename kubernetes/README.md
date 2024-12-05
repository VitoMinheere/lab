# Kubernetes Configuration Files

This directory contains Kubernetes YAML files for setting up and managing my homelab environment.

## Contents

- **mealie/**: Deployment manifests for the Mealie application.
- **helm/**: Helm charts I have used
- **monitoring/**: Setup for monitoring in Kubernetes

## Usage

To apply these configurations to your cluster:
```bash
kubectl apply -f <file-name>.yaml

