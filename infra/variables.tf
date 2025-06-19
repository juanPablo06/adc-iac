variable "environment" {
  description = "The environment in which the resources will be created"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
