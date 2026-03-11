resource "aws_instance" "test-server" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "key"
  subnet_id = "subnet-04103d4f13bfa451c"
  vpc_security_group_ids = ["sg-0178d50f27e5cf78c"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./key.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server1"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/terraform-files/ansibleplaybook.yml"
     }
  }
