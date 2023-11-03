resource "aws_instance" "airflow" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  subnet_id     = "subnet-12345678"
  vpc_security_group_ids = ["sg-12345678"]
  tags = {
    Name = "airflow-instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install python3-pip -y
              pip3 install apache-airflow
              EOF
}