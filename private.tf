# Private EC2-1
resource "aws_instance" "private-ec2" {
  ami = "${var.Private_EC2_ami}"
  instance_type = "${var.Private_EC2_instance_type}"
  vpc_security_group_ids = [aws_security_group.private_ec2.id]
  iam_instance_profile = aws_iam_instance_profile.private_ec2.name
  subnet_id = aws_subnet.private1.id
  associate_public_ip_address = false
  key_name = "${var.Private_EC2_key_name}"
  disable_api_termination = true
  depends_on = [aws_nat_gateway.nat_gateway]

  root_block_device {
    volume_size = "${var.Private_EC2_volume_size}"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-private-ec2"
    }
  }

  user_data = <<-EOF
            #!/bin/bash
            # Use this for your user data (script from top to bottom)
            # install httpd (Linux 2 version)
            sudo yum update -y
            sudo yum install httpd-2.4.51 -y
            sudo systemctl start httpd
            sudo systemctl enable httpd
            sudo httpd -v
            sudo cp /usr/share/httpd/noindex/index.html /var/www/html/index.html
            EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-private-ec2"
  }
}

# Private EC2-2
resource "aws_instance" "private-ec2-2" {
  ami = "${var.Private_EC2_2_ami}"
  instance_type = "${var.Private_EC2_2_instance_type}"
  vpc_security_group_ids = [aws_security_group.private_ec2_2.id]
  iam_instance_profile = aws_iam_instance_profile.private_ec2_2.name
  subnet_id = aws_subnet.private2.id
  associate_public_ip_address = false
  key_name = "${var.Private_EC2_2_key_name}"
  disable_api_termination = true
  depends_on = [aws_nat_gateway.nat_gateway]
  root_block_device {
    volume_size = "${var.Private_EC2_2_volume_size}"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-private-ec2-2"
    }
  }

  user_data = <<-EOF
            #!/bin/bash
            # Use this for your user data (script from top to bottom)
            # install httpd (Linux 2 version)
            sudo yum update -y
            sudo yum install httpd-2.4.51 -y
            sudo systemctl start httpd
            sudo systemctl enable httpd
            sudo httpd -v
            sudo cp /usr/share/httpd/noindex/index.html /var/www/html/index.html
            EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-private-ec2-2"
  }
}