# Launch EC2 instance and host a website on it.

resource "aws_instance" "web" {
  ami                         = lookup(var.web_ami, var.region)
  instance_type               = var.web_instance_type
  subnet_id                   = local.pub_sub_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data                   = file("scripts/apache.sh")
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = "web-app-jh"
  }
}