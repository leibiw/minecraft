# ELB for Minecraft Server
resource "aws_elb" "minecraft" {
  name            = "minecraft-elb"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.minecraft_elb_sg.id]

  listener {
    instance_port     = 25565
    instance_protocol = "tcp"
    lb_port           = 25565
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:25565"
    interval            = 30
  }
}

# Security Group for Minecraft ELB
resource "aws_security_group" "minecraft_elb_sg" {
  name        = "minecraft-elb-sg"
  description = "Security group for Minecraft ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow SSH Access to my Public IP"
    from_port       = 25565
    to_port         = 25565
    protocol        = "tcp"
    cidr_blocks     = ["73.70.24.45/32", "32.132.108.216/30"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "minecraft-elb-sg"
    Environment = "dev"
  }
}

# Kubernetes Service for Minecraft
resource "kubernetes_service" "minecraft" {
  metadata {
    name = "minecraft"
  }
  spec {
    selector = {
      app = "minecraft"
    }
    port {
      port        = 25565
      target_port = 25565
    }
    type = "LoadBalancer"
    load_balancer_ip = aws_elb.minecraft.dns_name
  }
}