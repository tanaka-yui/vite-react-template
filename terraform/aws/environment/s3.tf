resource "aws_s3_bucket" "s3_bucket_front" {
  bucket = local.front_name
  acl    = "private"
}

resource "aws_s3_bucket_policy" "s3_bucket_front_policy" {
  bucket = aws_s3_bucket.s3_bucket_front.id
  policy = templatefile("${path.module}/template/s3/policy/bucket_policy.json", {
    bucket     = aws_s3_bucket.s3_bucket_front.bucket
    identifier = aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity_front.iam_arn
  })

  depends_on = [
    aws_s3_bucket.s3_bucket_front,
    aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity_front,
  ]
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity_front" {
  comment = "origin access identity for s3"
}
