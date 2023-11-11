provider "aws" {
  shared_credentials_files = ["/Users/Admin/.aws/credentials"]
  profile                  = "default"
  region                   = var.region
}


resource "aws_cloud9_environment_ec2" "lab" {
  instance_type               = var.cloud9_instance_type
  name                        = var.studentname
  image_id                    = var.cloud9imageid
  owner_arn                   = aws_iam_user.studentname.arn
  automatic_stop_time_minutes = var.automatic_cloud9_stop_time_minutes


}

data "aws_instance" "cloud9_instance" {
  filter {
    name   = "tag:aws:cloud9:environment"
    values = [aws_cloud9_environment_ec2.lab.id]
  }
}
resource "aws_default_vpc" "default" {
  tags = {
    name = "test_default_vpc"
  }

}
resource "aws_iam_user" "studentname" {
  name = var.studentname
}

resource "aws_iam_user_login_profile" "student_user_login_profile" {
  user    = aws_iam_user.studentname.name
  pgp_key = var.admin_pgp_key

  password_reset_required = true
}

resource "aws_iam_group" "students_group" {
  name = "students_group"
}

resource "aws_iam_user_group_membership" "students_group_membership" {
  user   = aws_iam_user.studentname.name
  groups = [aws_iam_group.students_group.name]

}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  count      = length(var.policy_arns)
  group      = aws_iam_group.students_group.name
  policy_arn = var.policy_arns[count.index]
}

output "student_name" {
  value = aws_iam_user.studentname.name
}

output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.lab.id}"
}

output "student_ARN" {
  value = aws_iam_user.studentname.arn
}
output "machine_ARN" {
  value = aws_cloud9_environment_ec2.lab.arn
}
output "student_password" {
  value = aws_iam_user_login_profile.student_user_login_profile
  #the encrypted password may be decrypted using the command line, for example: terraform output password | base64 --decode | keybase pgp decrypt.
}
