resource "aws_instance" "stable_diffusion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.vpc_name != "" ? data.aws_subnets.selected.0.ids.0 : null
  vpc_security_group_ids = var.security_group_name != "" ? [data.aws_security_group.selected.0.id] : null
  associate_public_ip_address = true
  
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price          = var.spot_price * var.increase_rate
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_type           = "io2"
    volume_size           = var.disk_size
    iops                  = var.disk_iops
    encrypted             = false
    delete_on_termination = true
  }

  tags = {
    Name = "stable-diffusion"
  }

  user_data = <<EOF
#!/usr/bin/env bash
su - ubuntu -c "/home/ubuntu/stable-diffusion-aws/scripts/run.sh"
EOF
}

resource "null_resource" "health_check" {
  depends_on = [
    aws_instance.stable_diffusion,
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "for i in `seq 1 300`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      ENDPOINT = "http://${aws_instance.stable_diffusion.public_ip}:7860"
    }
  }
}
