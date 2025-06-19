# ADC Infrastructure Screenshots

This document provides visual evidence of the working implementation for the ADC Infrastructure project.

## Application Endpoints

### Root Endpoint
![Root Endpoint](/screenshots/root.png)
*The application's root endpoint showing the server is up and running*

### Gandalf Endpoint
![Gandalf Endpoint](/screenshots/gandalf.png)
*Screenshot showing Gandalf's image being displayed at the /gandalf endpoint*

### Colombo Time Endpoint
![Colombo Time](/screenshots/colombo.png)
*Screenshot showing the current time in Colombo, Sri Lanka at the /colombo endpoint*

## Prometheus Monitoring

### Metrics Endpoint
![Metrics Endpoint](/screenshots/metrics.png)
*Raw metrics output showing the counters for Gandalf and Colombo requests*

### Gandalf Requests Metrics
![Gandalf Metrics](/screenshots/gandalf_query.png)
*Prometheus dashboard showing the metrics for requests to the /gandalf endpoint*

### Colombo Requests Metrics
![Colombo Metrics](/screenshots/colombo_query.png)
*Prometheus dashboard showing the metrics for requests to the /colombo endpoint*

## CI/CD and Deployment

### GitHub Actions Workflow
![GitHub Actions](/screenshots/workflow.png)
*GitHub Actions workflow successfully building and deploying the application*

### Pull Request
![Pull Request](/screenshots/pr.png)
*Automated Pull Request updating the image tag after a successful build*

### ArgoCD Deployment
![ArgoCD](/screenshots/argocd.png)
*ArgoCD dashboard showing the successful deployment of the application*


