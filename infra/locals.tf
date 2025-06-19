locals {
  project            = "adc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, min(3, length(data.aws_availability_zones.available.names)))
  public_subnets     = [for i in range(length(local.availability_zones)) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_subnets    = [for i in range(length(local.availability_zones)) : cidrsubnet(local.vpc_cidr, 8, i + 10)]
}
