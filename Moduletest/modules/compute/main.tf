# COST: t2/t3.micro = Free Tier eligible (750 hrs/month for 12 months on
# legacy free-tier accounts; on newer accounts it consumes your free credits).
# EBS gp3 8 GB root volume is within the 30 GB Free Tier allowance.
# Instance types are region dependent; verify with:
#   aws ec2 describe-instance-types --filters Name=free-tier-eligible,Values=true \
#     --query "InstanceTypes[*].InstanceType" --region <region>

# Always-current Amazon Linux 2023 AMI via the public SSM parameter (free).
data "aws_ssm_parameter" "al2023" {
  count = var.create_instance ? 1 : 0
  name  = var.instance_type == "t4g.micro" ? "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64" : "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "this" {
  count = var.create_instance ? 1 : 0

  ami                         = data.aws_ssm_parameter.al2023[0].value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge({ Name = "${var.name}-ec2", Module = "compute" }, var.tags)
}
