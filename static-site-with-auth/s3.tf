# S3 for public 
resource "aws_s3_bucket" "root" {
  bucket = "${var.s3_bucket_name}"
  policy = "${data.aws_iam_policy_document.bucket_policy_document.json}"

  website {
    index_document = "index.html"
    # error_document = "error.html"
  }
}

# Bucket Policy
data "aws_iam_policy_document" "bucket_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }
}
