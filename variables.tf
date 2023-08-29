# @options ["g4dn.xlarge","g4dn.2xlarge","g4dn.4xlarge"]
variable "instance_type" {
  type = string
  description = "Instance type"
  default = "g4dn.xlarge"
}

variable "spot_price" {
  description = "The price for spot instance"
  default = "0.24192"
}

variable "ami_id" {
  description = "The ID of the AMI used to launch the EC2 instance"
  default     = "ami-0a093cfdcd72ee5dd"
}

variable "disk_size" {
  type = number
  description = "Root disk size in GiB"
  default = 100
}

variable "vpc_name" {
  type = string
  description = "VPC Name"
  default = ""
}

variable "security_group_name" {
  type = string
  description = "Security group Name"
  default = ""
}

variable "instance_name" {
  type        = string
  default     = "stable-diffusion-demo"
}

variable "key_name" {
  type = string
  description = "Key pair name"
  default = ""
}
