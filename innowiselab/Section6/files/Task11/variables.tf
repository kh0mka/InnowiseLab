variable "bucket_policy" {
  default = <<EOF
{
    "Version": "2012-10-17",
    "Id": "PublicDataStoragePolicy",
    "Statement": [
        {
            "Sid": "PublicDataStorageStatement",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::inno-public-data-storage/*"
            ]
        }
    ]
}
EOF
}
