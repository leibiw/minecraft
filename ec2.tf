resource "aws_instance" "management_node_wg" {
 ami           = "ami-07d9b9ddc6cd8dd30" 
 instance_type = "t2.small"
 key_name      = "home1"

 subnet_id              = module.vpc.private_subnets[0] 
 associate_public_ip_address = true
 vpc_security_group_ids = [aws_security_group.management_node_sg.id]
 
 tags = {
    Name           = "EKS-Management-Node"
    Enviroment     = "dev"
 }

 user_data = <<-EOF
              #!/bin/bash
              sudo apt install unzip
              
              #Install AWS CLI
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              
              #Install Kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
              chmod +x kubectl
              sudo mv kubectl /usr/local/bin/
              kubectl version --client
              # Add additional SSH keys  
              echo 'ssh-rsa MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAh524f/FX/xjd+NniTNiJgHh+bBKBgs8vWkB+BOV6vcgDJVabPxOeNKK+o1BgtU7ZfvwWiR/zlzh2zdZgu7L5j/7f0rym9E437KZNiPK49mIJ8tTN+StdkfvIc2PBFI9MXTbU2YPJ2ryar3ldlj8zvTM5V3UmxTpYvZ2jJ1DDRe8UDEMtxMDQiFoejWFf132fyIe3tKMM1DrPgpRXqHVMSUw15juJgqmU5rF4SawIiRhludrM88wbDDT1K8gicKOFMboj2gBQPIw57R7SANl4eiACrG9hsHmiW5fg4W+0bAk70VA3Hg8zogEgovPQH4T7qKKd0aKHyp11VLC/IsyFkwIDAQAB' >> /home/ubuntu/.ssh/authorized_keys
              
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
        cidr_blocks = ["73.70.24.45/32", "32.132.108.216/30"]
    }
 egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

 tags = {
    Name                = "management_node_sg"
    Enviroment          = "dev"
 }
}
