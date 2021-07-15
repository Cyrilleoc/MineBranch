variable "tempate_origin_bucket" {
    type = string
    default = "sidewinder-testing"
    description = "Origin Bucket for Tenant VPC Template(s)"
}

variable "tempate_origin_prefix" {
    type = string
    default = "resources"
    description = "Origin Prefix for Tenant VPC Template(s)"
}

variable "notify_email" {
    type = string
    default = "chrhas@amazon.com"
    description = <<EOT
Notification email address for security events (you will receive a
confirmation email)
EOT
}

variable "availability_zone_a" {
    type = string
    # default = "sidewinder-testing"
    description = "Availability Zone 1"
}

variable "availability_zone_b" {
    type = string
    # default = "sidewinder-testing"
    description = "Availability Zone 2"
}

variable "logs_bucket" {
    type = string
    default = "unique-bucket-name"
    description = "S3 bucket name for log storage"
    validation {
        # regex(...) fails if it cannot find a match
        condition     = can(regex("^[0-9a-zA-Z]+([0-9a-zA-Z-.]*[0-9a-zA-Z])*$", var.logs_bucket))
        error_message = "Invalid bucket name."
            # Bucket name can include numbers, lowercase letters, uppercase
            # letters, periods (.), and hyphens (-). It cannot start or end with a hyphen (-).
    }
}

variable "cloudtrail_to_cloudwatch_logs" {
    type = bool
    default = true
    description = <<EOT
True if a CloudWatch Logs log group was manually created for CloudTrail
Logs to be sent to CloudWatch Logs in this account
EOT
}

variable "cloudtrail_log_group" {
    type = string
    default = "cloudtrail"
    description = "Name of CloudWatch Logs log group local destination for CloudTrail Logs"
}

variable "tenant_cidr" {
    type = string
    default = "10.1.0.0/16"
    description = "CIDR range of Tenant VPC, must not overlap with the Transit VPC CIDR block"
    ### REGEX INCORRECT
    # validation {
    #     # regex(...) fails if it cannot find a match
    #     condition     = can(regex("((\d{1,3})\.){3}\d{1,3}/\d{1,2}", var.tenant_cidr))
    #     error_message = "Invalid CIDR range."
    # }
}

variable "vpc_tenancy" {
    type = string
    default = "default"
    description = "Instance tenancy behavior for this VPC"
    validation {
        condition     = contains(["default", "dedicated"], var.vpc_tenancy)
        error_message = "Valid values for var: vpc_tenancy are (deafult, dedicated)."
    } 
}

variable "peer_vpc_account_id" {
    type = string
    description = <<EOT
Account ID of the Transit VPC owner, taken from the outputs of the Transit
VPC stack
EOT
}

variable "peer_vpc_id" {
    type = string
    description = <<EOT
VPC ID of the Transit VPC owner, taken from the outputs of the Transit VPC
stack
EOT
}

variable "peer_role_arn" {
    type = string
    description = <<EOT
Complete Amazon Resource Name for the peering role, taken from the outputs
of the Transit VPC stack
EOT
}

variable "transit_vpc_cidr" {
    type = string
    default = "10.0.0.0/24"
    description = "The CIDR block of the Transit VPC"
    ### REGEX INCORRECT
    # validation {
    #     # regex(...) fails if it cannot find a match
    #     condition     = can(regex("\d{1,3})\.){3}\d{1,3}/\d{1,2}", var.transit_vpc_cidr))
    #     error_message = "Invalid CIDR range."
    # }
}

variable "tenant_vpc_name" {
    type = string
    description = "Project Name"
}

variable "tenant_vpc_environment" {
    type = string
    default = "DEV"
    description = "Ability to name Tenant VPC with DEV, TEST, or PROD identifiers"
    validation {
        condition     = contains(["DEV", "TEST", "PROD"], var.tenant_vpc_environment)
        error_message = "Valid values for var: tenant_vpc_environment are (DEV, TEST, PROD)."
    } 
}

variable "first_account_tenant" {
    type = bool
    default = true
    description = <<EOT
True if this is the first peered Tenant VPC in this account
Logs to be sent to CloudWatch Logs in this account
EOT
}

variable "tenant_bucket_name" {
    type = string
    default = ""
    description = "Bucket name of Tenant Public Keys Bucket"
}

variable "deploy_lambda" {
    type = bool
    default = true
    description = "True if deploying lambda function"
}

variable "lambda_move_pub_keys_role" {
    type = string
    default = ""
    description = "Role Lambda Function will assume to put keys in Tranits Logs"
}

variable "lambda_key" {
    type = string
    default = ":default"
    description = "Object key of lambda function in deployment bucket"
}



