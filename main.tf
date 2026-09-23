provider "aws" {
  
}

resource "aws_instance" "test1" {
  ami = "ami-0454207e5367abf01"
  instance_type = "t2.micro"

}