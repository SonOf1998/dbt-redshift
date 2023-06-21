# IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name = "glue-role"
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  )
}

# Get the AWSGlueServiceRole policy
data "aws_iam_policy" "aws_glue_service_role_policy" {
  name = "AWSGlueServiceRole"
}

# Recommended policy to attach
resource "aws_iam_role_policy_attachment" "glue_service" {
    role = aws_iam_role.glue_role.id
    policy_arn = data.aws_iam_policy.aws_glue_service_role_policy.arn
}

resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "glue-s3-policy"
  role = aws_iam_role.glue_role.id

  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
		  "s3:ListBucket",
          "s3:GetObject*"
        ],
        "Resource": [
          "arn:aws:s3:::${var.tickit_bucket_name}",
          "arn:aws:s3:::${var.tickit_bucket_name}/*"
        ]
      }
    ]
  }
  )
}