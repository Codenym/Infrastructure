resource "aws_instance" "airflow" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  subnet_id     = "subnet-12345678"
  vpc_security_group_ids = ["sg-12345678"]
  tags = {
    Name = "airflow-instance"
  }

}