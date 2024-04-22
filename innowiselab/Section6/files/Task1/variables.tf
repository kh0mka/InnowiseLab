variable "users_to_create" {
  type    = list(string)
  default = ["Givi", "Selin", "Slava", "Rita", "Kirill"]
}

variable "policy_to_dev_group" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StopInstances",
        "ec2:StartInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
