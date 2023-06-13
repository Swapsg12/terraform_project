
resource "aws_security_group" "MediaWiki-SG" {
  name        = "Med_wiki-SG"
  description = "To whitelist port 443, 22 & 80"

  dynamic "ingress" {
    for_each = var.port

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rhel7_public_ip" {
  value = aws_instance.MediaWiki.public_ip
}
