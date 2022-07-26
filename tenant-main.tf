terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "tenant_vpc" {
  cidr_block       = var.tenant_cidr # !Ref pTenantCIDR
  instance_tenancy = var.vpc_tenancy # !Ref pVPCTenancy
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    # Value: !Join
    #     - ' '
    #     - - !Ref pTenantVPCName   tn-vpc
    #     - !Ref pTenantVPCEnvironment  dev
    #     - 'Tenant VPC'
    Name = join(" ", [var.tenant_vpc_name, var.tenant_vpc_environment, "Tenant VPC"])
    # !Ref pTenantVPCEnvironment
    Environment = var.tenant_vpc_environment
  }
}

# this is not part of cloudformation template, for demo purpose only
resource "aws_subnet" "tenant_public_subnet" {
  vpc_id     = aws_vpc.tenant_vpc.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true // it makes this a public subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "tenant_public_subnet"
  }
}

resource "aws_route_table" "tenant_route_table" {
  vpc_id = aws_vpc.tenant_vpc.id

    # DestinationCidrBlock: !Ref pTransitVPCCIDR
    # RouteTableId: !Ref rRouteTableMain
    # VpcPeeringConnectionId: !Ref rVPCPeeringConnection

  # routes not defined as there is transit account is not provisioned yet
  route = []


  tags = {
    # Value: !Join
    #     - ' '
    #     - - !Ref pTenantVPCName
    #     - !Ref pTenantVPCEnvironment
    #     - 'Tenant VPC Route Table'
    Name = join(" ", [var.tenant_vpc_name, var.tenant_vpc_environment, "Tenant VPC Route Table"])
  }
}

resource "aws_vpc_endpoint" "tenant_vpc_endpoint" {
  vpc_id       = aws_vpc.tenant_vpc.id
  route_table_ids = [aws_route_table.tenant_route_table.id]

    # ServiceName: !Join
    #     - ''
    #     - - com.amazonaws.
    #     - !Ref 'AWS::Region'
    #     - .s3
  service_name = "com.amazonaws.us-east-1.s3"

}

#Just for test
# This VPC will not be created
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = false
  # ... omitted
}