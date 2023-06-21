resource "aws_iam_role" "redshift-role" {
  name = "redshift-role"

  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "redshift.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
  }
  )
}

# Get the AmazonRedshiftAllCommandsFullAccess policy
data "aws_iam_policy" "redshift-full-access-policy" {
  name = "AmazonRedshiftAllCommandsFullAccess"
}

# Attach the policy to the Redshift role
resource "aws_iam_role_policy_attachment" "attach-s3" {
  role       = aws_iam_role.redshift-role.name
  policy_arn = data.aws_iam_policy.redshift-full-access-policy.arn
}