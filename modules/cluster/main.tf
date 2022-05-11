module "eks" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.0.3"

  # EKS CLUSTER
  cluster_name              = "${var.env}-eks-tf-cluster-poc"
  vpc_id                    = var.vpc_id
  private_subnet_ids        = var.private_subnets_ids
  public_subnet_ids         = var.public_subnets_ids
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # List of map_users
  map_users = [
    for username in ["username1", "username2"] : {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}" # The ARN of the IAM user to add.
      username = "opsuser"                                                                      # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"]                                                             # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_m5 = {
      # 1> Node Group configuration
      node_group_name    = "eks_managed_node_group"
      instance_types     = ["m5.large"]
      subnet_ids         = var.private_subnets_ids
      launch_template_os = "amazonlinux2eks"
      capacity_type      = "ON_DEMAND"
      enable_monitoring  = true
      public_ip          = false
      desired_size       = var.eks_node_count
      max_size           = var.eks_node_max_count
      min_size           = var.eks_node_min_count
      max_unavailable    = 1 # or percentage = 20
      block_device_mappings = [
        {
          device_name           = "/dev/xvda"
          delete_on_termination = true
          encrypted             = true
          volume_size           = var.worker_nodes_disk_size
        }
      ]
    }
  }
}
