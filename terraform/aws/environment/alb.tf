module "alb_backend" {
  source = "./modules/alb/single"

  name            = local.backend_name
  certificate_arn = data.terraform_remote_state.remote_state_immutable.outputs.acm_certificate_arn_northeast
  vpc_id          = aws_vpc.vpc.id
  public_subnet_ids = [
    aws_subnet.subnet_public_a.id,
    aws_subnet.subnet_public_c.id,
  ]
  port                 = var.app.container_port
  health_check_matcher = "200"
  health_check_path    = "/api/health"
  allow_http_headers = [
    {
      name   = local.x_origin_access_key
      values = [var.origin_access_key]
    }
  ]
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public_a,
    aws_subnet.subnet_public_c,
  ]
}
