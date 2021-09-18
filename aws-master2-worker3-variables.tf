
/*
 * ----------VPC Settings----------
 */

variable "aws_network_cidr" {
  description = "VPC network ip block."
  default     = "172.16.0.0/16"
}

variable "aws_subnet1_cidr" {
  description = "Subset block from VPC network ip block."
  default     = "172.16.0.0/24"
}

/*
 * ----------vm Settings----------
 */

 variable "amis" {
  description = "Default AMIs to use for nodes depending on the region"
  default     = "ami-08c64544f5cfcddd0"
}

variable "aws_region" {
  description = "Default to Northern California region."
  default     = "ap-northeast-2"
}

variable zone {
  default = "ap-northeast-2a"
}

variable "aws_instance_type" {
  description = "Machine Type. Includes 'Enhanced Networking' via ENA."
  default     = "t2.micro"
}

variable number_of_controller{
  description = "The number of controller, only acts as controller"
  default = 2
}

variable number_of_worker{
  description = "The number of worker nodes"
  default = 3
}

