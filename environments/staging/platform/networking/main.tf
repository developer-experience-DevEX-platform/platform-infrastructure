module "networking" {
  source = "../../../../modules/aws/networking"

  name     = "devex-staging"
  vpc_cidr = "10.10.0.0/16"

  availability_zones = [
    "eu-west-2a",
    "eu-west-2b",
  ]

  public_subnet_cidrs = [
    "10.10.0.0/24",
    "10.10.1.0/24",
  ]

  private_subnet_cidrs = [
    "10.10.16.0/20",
    "10.10.32.0/20",
  ]

  nat_gateway_mode = "single"

  tags = {
    Environment = "staging"
  }
}
