resource "aws_alb" "web" {
  name_prefix = var.name_prefix
  subnets = var.alb_subnets
}

output "alb_dns_name" {
  value = aws_alb.web.dns_name
}

resource "aws_alb_listener" "lambda" {
  load_balancer_arn = aws_alb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

data "aws_lambda_function" "app" {
  for_each = var.lambda_functions
  function_name = each.value
}

resource "aws_alb_target_group" "lambda" {
  for_each = var.lambda_functions
  target_type = "lambda"
}

resource "aws_lb_listener_rule" "static" {
  for_each = var.lambda_functions
  listener_arn = aws_alb_listener.lambda.arn
  priority = 100 + count.index

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.lambda[each.value]}"
  }

  condition {
    path_pattern {
      values = ["/lambda/${each.value}"]
    }
  }
}

resource "aws_lambda_permission" "alb_lambda" {
  for_each = var.lambda_functions
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}

resource "aws_alb_target_group_attachment" "lambda" {
  for_each = var.lambda_functions
  target_group_arn = aws_lb_target_group.lambda[each.value].arn
  target_id        = data.aws_lambda_function.app[each.value].arn
  depends_on       = [aws_lambda_permission.alb_lambda[each.value]]
}
