aws_eks_cluster_config = {

      "acme-cluster" = {

        eks_cluster_name         = "acme-cluster"
        eks_subnet_ids = ["subnet-0e8f10dffa4001566","subnet-0fcbeefc3605d82c7","subnet-0dc9466c258d0e176","subnet-06e1eb623f8551023"]
        tags = {
             "Name" =  "acme-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "acme-cluster"
        node_group_name          = "node1"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-0e8f10dffa4001566","subnet-0fcbeefc3605d82c7","subnet-0dc9466c258d0e176","subnet-06e1eb623f8551023"]

        tags = {
             "Name" =  "node1"
         } 
  }

  "node2" = {

        eks_cluster_name         = "acme-cluster"
        node_group_name          = "node2"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-0e8f10dffa4001566","subnet-0fcbeefc3605d82c7","subnet-0dc9466c258d0e176","subnet-06e1eb623f8551023"]

        tags = {
             "Name" =  "node2"
         } 
  }
}