# create IAM policy

resource "aws_iam_policy" "web" {
  name        = "web_s3_policy"
  path        = "/myapp/"
  description = "s3 put and get for web application"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.web_s3}/*"
      },
    ]
  })
}

# Creatre IAM role for web

resource "aws_iam_role" "web_ec2_role" {
  name = "web_ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach IAM role with policy

resource "aws_iam_role_policy_attachment" "web-s3-attach" {
  role       = aws_iam_role.web_ec2_role.name
  policy_arn = aws_iam_policy.web.arn
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.web_ec2_role.name
}