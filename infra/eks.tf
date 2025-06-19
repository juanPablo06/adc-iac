resource "aws_eks_cluster" "main" {
  name = "${local.project}-${var.environment}-eks-cluster"

  version = "1.33"

  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.project}-${var.environment}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type = "AL2023_ARM_64_STANDARD"

  capacity_type = "SPOT"

  labels = {
    "Name"        = "${local.project}-${var.environment}-worker"
    "role"        = "worker"
    "environment" = var.environment
  }

  tags = {
    "Name" = "${local.project}-${var.environment}-worker"
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${local.project}-${var.environment}-eks-node-"
  instance_type = "m7g.medium"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.project}-${var.environment}-worker"
    }
  }
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]

  depends_on = [
    aws_eks_cluster.main,
  ]
}
