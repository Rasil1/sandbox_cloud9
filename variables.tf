variable "region" {
  description = "default region"
  type        = string
  default     = "us-east-2"
}

variable "studentname" {
  description = "The name of the user"
  type        = string
  default     = "student"
}

variable "cloud9_instance_type" {
  description = "cloud9 instance size possible options t2.micro t3.small m5.large"
  type        = string
  default     = "t2.micro"
}
variable "cloud9imageid" {
  type        = string
  description = "possible options: resolve:ssm:/aws/service/cloud9/amis/ubuntu-22.04-x86_64 resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64"
  default     = "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64"
}

variable "automatic_cloud9_stop_time_minutes" {
  description = "time to stop cloud9 instance"
  type        = number
  default     = 30
}

variable "policy_arns" {
  description = "The list of ARNs of policies directly assigned to the IAM group"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AWSCloud9User", "arn:aws:iam::aws:policy/job-function/SystemAdministrator", "arn:aws:iam::aws:policy/IAMUserChangePassword"]
}


