# ADC Infrastructure as Code (IaC) Project

## Overview

This repository contains the infrastructure and application code for a Kubernetes-deployed web service that:
- Shows Gandalf's image at `/gandalf`
- Shows current time in Colombo, Sri Lanka at `/colombo`
- Tracks metrics for requests to both endpoints

## Architecture

The solution consists of:

- **Web Application**: A Flask app in Python with Prometheus metrics
- **Infrastructure**: AWS EKS (Kubernetes) with automated deployment via ArgoCD
- **Monitoring**: Prometheus server on EC2 to track application metrics
- **CI/CD**: GitHub Actions workflow for container builds and deployments

## Key Components

### Infrastructure (Terraform)
- **Network**: VPC with public and private subnets across 3 availability zones
- **Kubernetes**: EKS cluster with ARM64-based node group (m7g.medium instances)
- **Git-based deployment**: ArgoCD for declarative application deployment
- **Load Balancing**: AWS Network Load Balancer with static IP using EIP allocation
- **Container Registry**: ECR repository with lifecycle policies

### Web Application
- Python Flask application with Gandalf image and Colombo time endpoints
- Built-in Prometheus metrics for endpoint access counting
- Packaged in a Docker container and stored in Amazon ECR

### Deployment Strategy (Helm/ArgoCD)

- **Helm Charts** for application packaging and configuration
- **ArgoCD** for GitOps-based deployment
- **Network Load Balancer** with static IP (Elastic IP allocation)

### CI/CD Pipeline
- GitHub Actions workflow triggered on app code changes
- Multi-architecture Docker image builds (ARM64/AMD64) for compatibility
- Pull Request-based deployment to ensure change tracking
- ECR image publishing with automatic Helm chart updates

### Monitoring
- Prometheus server on EC2 instance with dedicated static IP
- Direct scraping of application metrics via load balancer endpoint
- Tracking of `/gandalf` and `/colombo` request counters

## Implementation Decisions

- **ARM-based Kubernetes**: Using Graviton instances for better price/performance
- **Static IP**: Implemented using AWS Network Load Balancer with EIP allocation
- **Direct Metrics Scraping**: Prometheus scrapes metrics directly from the app's public endpoint
- **Infrastructure as Code**: All resources provisioned via Terraform for reproducibility
- **Stack**: I chose based on my affinity with the resources and tools

## Visual Documentation

For screenshots of the components, please see [Screenshots](screenshots.md).