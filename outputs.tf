output "aws-ami-id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec-2-public-ip" {
  value = aws_instance.myapp-server.public_ip
}
