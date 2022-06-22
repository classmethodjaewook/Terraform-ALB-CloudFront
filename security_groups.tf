# Security Group
# Bastion EC2 SG
resource "aws_security_group" "bastion_ec2"{
    name        = "${var.project_name}-${var.environment}-bastion-sg"
    description = "for bastion ec2"
    vpc_id      = aws_vpc.vpc.id

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

# Private EC2 SG
resource "aws_security_group" "private_ec2"{
    name        = "${var.project_name}-${var.environment}-private-sg"
    description = "for private ec2"
    vpc_id      = aws_vpc.vpc.id

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-sg"
  }
}

resource "aws_security_group_rule" "private_ec2" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_ec2.id
  security_group_id        = aws_security_group.private_ec2.id
}

resource "aws_security_group_rule" "private_ec2_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ALB.id
  security_group_id        = aws_security_group.private_ec2.id
}

# Private EC2_2 SG
resource "aws_security_group" "private_ec2_2"{
    name        = "${var.project_name}-${var.environment}-private-2-sg"
    description = "for private ec2_2"
    vpc_id      = aws_vpc.vpc.id

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-2-sg"
  }
}

resource "aws_security_group_rule" "private_ec2_2" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_ec2.id
  security_group_id        = aws_security_group.private_ec2_2.id
}

resource "aws_security_group_rule" "private_ec2_2_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ALB.id
  security_group_id        = aws_security_group.private_ec2_2.id
}

# ALB SG
resource "aws_security_group" "ALB"{
    name        = "${var.project_name}-${var.environment}-ALB-sg"
    description = "for ALB"
    vpc_id      = aws_vpc.vpc.id

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ALB-sg"
  }
}

resource "aws_security_group_rule" "alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ALB.id
}

resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ALB.id
}