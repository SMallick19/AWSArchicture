variable "environment" {
    description = "Environment name"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR block for vpc"
    type = string
}

variable "availability_zones" {
    description = "availablity zone for vpc"
    type = list(string)
}

variable "public_subnets" {
    description = "Public subnets for vpc cidr"
    type = list(string)
}

variable "private_subnets" {
    description = "Private subnets for vpc cidr for test"
    type = list(string)
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state lock"
  type        = string
}
