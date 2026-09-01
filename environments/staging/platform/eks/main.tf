data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "staging/platform/networking/terraform.tfstate"
    region = var.aws_region
  }
}

module "eks" {
  source = "../../../../modules/aws/eks"

  cluster_name       = "devex-staging"
  kubernetes_version = "1.36"

  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = true

  # Staging temporarily permits public IPv4 access because a restricted
  # corporate egress CIDR is not yet available. Production must use a
  # stricter endpoint policy.
  public_access_cidrs = ["0.0.0.0/0"]

  node_instance_types = ["t3.medium"]
  node_capacity_type  = "ON_DEMAND"
  node_min_size       = 2
  node_desired_size   = 2
  node_max_size       = 4
  node_disk_size      = 30

  tags = {
    Environment = "staging"
  }
}
