resource "aws_security_group" "prometheus" {
  name        = "${local.project}-${var.environment}-prometheus-sg"
  description = "Security group for Prometheus server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
    description = "Allow Prometheus access from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project}-${var.environment}-prometheus-sg"
  }
}

resource "aws_iam_role" "prometheus" {
  name = "${local.project}-${var.environment}-prometheus-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.prometheus.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "prometheus_eks_access" {
  name = "${local.project}-${var.environment}-prometheus-eks-access"
  role = aws_iam_role.prometheus.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "prometheus" {
  name = "${local.project}-${var.environment}-prometheus-profile"
  role = aws_iam_role.prometheus.name
}

resource "aws_instance" "prometheus" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.prometheus.id]
  iam_instance_profile   = aws_iam_instance_profile.prometheus.name

  user_data = templatefile("${path.module}/scripts/user_data.sh", {
    region       = var.region,
    cluster_name = aws_eks_cluster.main.name
  })

  tags = {
    Name = "${local.project}-${var.environment}-prometheus"
  }
}

resource "aws_eip" "prometheus" {
  domain = "vpc"

  tags = {
    Name = "${local.project}-${var.environment}-prometheus-eip"
  }
}

resource "aws_eip_association" "prometheus" {
  instance_id   = aws_instance.prometheus.id
  allocation_id = aws_eip.prometheus.id
}
