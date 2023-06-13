
provider "aws" {
  region     = "us-west-1"
  access_key = var.cred_access_key
  secret_key = var.cred_secret_key
}


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

output  "rhel7_public_ip" {
  value = aws_instance.MediaWiki.public_ip
}


#Ec2 instance


resource "aws_instance" "MediaWiki" {
  ami                    = "ami-002070d43b0a4f171" # Centos 7 AMI ID
  instance_type          = "t2.micro"
  key_name               = "rhel7_server"
  vpc_security_group_ids = [aws_security_group.MediaWiki-SG.id]
  tags = {
    Name = "mediawiki_server"

  }

  
  provisioner "remote-exec" {
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./rhel7_server.pem")}"
      host        = self.public_ip
    }


    inline = [
      "sudo amazon-linux-extras install -y ansible2",
      "sudo yum install -y python3-pip",
      "sudo pip3 install boto boto3"
    ]
  }

  provisioner "file" {
    source      = "F:\\DevOps Journey\\Learning\\Terraform_project\\playbook.yaml"
    destination = "/home/ec2-user/playbook.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/playbook.yaml",
      "ansible-playbook -i localhost, /home/ec2-user/playbook.yaml"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./rhel7_server.pem")}"
    }
  }


}