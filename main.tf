resource "aws_alb" "web" {
//  name_prefix = "k-omoto"
  subnets = [
    "subnet-05e5c73f14acf466f",
    "subnet-022f569e0077232fb",
    "subnet-09509f59c476b3643"
  ]
}

output "alb_dns_name" {
  value = aws_alb.web.dns_name
}
resource "aws_lb_target_group" "lambda" {
  target_type = "lambda"
}

resource "aws_alb_listener" "web" {
  load_balancer_arn = aws_alb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }
}

resource "aws_lambda_permission" "alb_lambda" {
//  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}

resource "aws_alb_target_group_attachment" "lambda" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = aws_lambda_function.app.arn
  depends_on       = [aws_lambda_permission.alb_lambda]
}
