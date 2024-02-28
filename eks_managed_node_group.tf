eks_managed_node_group_defaults = {
    ami_type                = "AL2_x86_64"
    instance_types          = ["m5.large"]

    attach_cluster_primary_security_group = true
}

eks_managed_node_groups = {
    sphere-cluster-wg = {
        min_size = 1
        max_size = 2
        desired_size = 1


        instance_types = ["t3.large"]
        capacity_type  = "SPOT"
        
        tags    = {
            ExtraTag = "sphere-wg"
        }

        }
    }
}