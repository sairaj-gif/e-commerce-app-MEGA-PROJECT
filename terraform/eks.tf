module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # v21 parameter names
  name               = local.name
  kubernetes_version = "1.33" # or your desired version

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    tws-demo-ng = {
      instance_types = ["t2.large"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      capacity_type = "SPOT"

      disk_size = 35

      tags = {
        Name        = "tws-demo-ng"
        Environment = "dev"
        ExtraTag    = "e-commerce-app"
      }
    }
  }

  tags = local.tags
}
