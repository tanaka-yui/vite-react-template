resource "aws_iam_user" "deploy_user" {
  name = "deploy-user"
}

// show access key:  terraform state pull | jq '.resources[] | select(.type == "aws_iam_access_key") | .instances[0].attributes'
resource "aws_iam_access_key" "deploy_user_key" {
  user = aws_iam_user.deploy_user.name

  depends_on = [aws_iam_user.deploy_user]
}

resource "aws_iam_user_policy_attachment" "deploy_user_policy_ecr" {
  user       = aws_iam_user.deploy_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"

  depends_on = [aws_iam_user.deploy_user]
}

resource "aws_iam_user_policy_attachment" "deploy_user_policy_S3" {
  user       = aws_iam_user.deploy_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

  depends_on = [aws_iam_user.deploy_user]
}
