resource "aws_instance" "management_node_wg" {
 ami           = "ami-0c7217cdde317cfec" 
 instance_type = "t2.small"

 key_name = "home1"

 vpc_security_group_ids = [aws_security_group.management_node_sg.id]
 associate_public_ip_address = true
 subnet_id              = module.vpc.private_subnets[0] 

 tags = {
    Name = "EKS-Management-Node"
 }

 user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y aws-cli
              yum install -y kubectl
              EOF
}

resource "aws_security_group" "management_node_sg" {
 name        = "management_node_sg"
 description = "Security group for EKS management node"
 vpc_id      = module.vpc.vpc_id
 
 ingress {
        description = "Allow SSH Access to my Public IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["73.70.24.45/32"]
    }
 egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

 tags = {
    Name = "management_node_sg"
 }
}
