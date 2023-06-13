#resource "aws_iam_role_policy" "platform_api_cloudwatch_logs_policy" {
#  name = "cloudwatch-logs-streaming"
#  role = module.beanstalk.instance_role.id
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = ["logs:CreateLogGroup"]
#        Effect = "Allow"
#        Resource = "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
#      }
#    ]
#  })
#}
