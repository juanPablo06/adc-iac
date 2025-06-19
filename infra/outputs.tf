output "ecr_repository_url" {
  value       = aws_ecr_repository.main.repository_url
  description = "The URL of the ECR repository"
}

output "eks_cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "Name of the EKS cluster"
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "Endpoint for the EKS control plane"
}

output "eks_cluster_certificate_authority_data" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
  description = "Base64 encoded certificate data for the EKS cluster"
  sensitive   = true
}

output "kubectl_config_command" {
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.main.name}"
  description = "Command to configure kubectl for this cluster"
}

output "prometheus_public_ip" {
  value       = aws_eip.prometheus.public_ip
  description = "Public IP address of the Prometheus server"
}

output "argocd_server_url" {
  value       = "argocd-server.argocd.svc.cluster.local"
  description = "ArgoCD server URL (internal)"
}

output "argocd_instructions" {
  value = <<EOT
To access ArgoCD:
1. Get the password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
2. Get the ArgoCD URL: kubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
3. Login with username: admin and the password from step 1
EOT
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of private subnets"
}

output "nlb_eip_allocation_id" {
  value       = aws_eip.nlb.allocation_id
  description = "Allocation ID of the Elastic IP for the NLB"
}
