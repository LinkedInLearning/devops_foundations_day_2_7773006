module "vervium_cloud_ai" {
  source = "../../modules/vervium-ec2"

  name          = "vervium-cloud-ai"
  instance_type = "t3.micro"

  # TODO: fill in your own AMI ID below!
  ami = "ami-09f833cbef0620166"

  # TODO: fill in your own Key Pair name below!
  key_name = "jim-brikman-personal-mgmt-us-east-2"
}