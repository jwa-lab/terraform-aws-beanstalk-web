module "beanstalk" {
  source = "jwa-lab/beanstalk/aws"
  version = "0.1.2"

  beanstalk_env_name = var.beanstalk_env_name
  beanstalk_app_name = var.beanstalk_app_name

  tier = "WebServer"
  solution_stack_name = var.solution_stack_name
  vpc_id = var.vpc_id

  production = var.production
  ha = var.ha

  description = "WebServer environment for ${var.beanstalk_app_name}"

  profile_permissions_boundary_arn = var.profile_permissions_boundary_arn
  instance_type = var.instance_type

  beanstalk_settings = [
    {
      namespace = "aws:autoscaling:asg"
      name = "MaxSize"
      value = var.production ? 20 : 2
    },
    {
      namespace = "aws:autoscaling:asg"
      name = "MinSize"
      value = var.ha ? 2 : 1
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name = "RollingUpdateType"
      value = "Health"
    },
    {
      namespace = "aws:ec2:instances"
      name = "InstanceTypes"
      value = var.instance_type != null ? var.instance_type : (var.production ? "t4g.small" : "t4g.micro")
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name = "EnvironmentType"
      value = "LoadBalanced"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name = "LoadBalancerType"
      value = "application"
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "DeregistrationDelay"
      value = 10
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckInterval"
      value = 30
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckPath"
      value = var.health_check_path
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckTimeout"
      value = 2
    },
    {
      namespace = "aws:elbv2:listener:443"
      name = "Protocol"
      value = "HTTPS"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name = "SSLCertificateArns"
      value = aws_acm_certificate.certificate.arn
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "IdleTimeout"
      value = 10
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "ManagedSecurityGroup"
      value = aws_security_group.load_balancer_security_group.id
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "SecurityGroups"
      value = aws_security_group.load_balancer_security_group.id
    }
  ]

  beanstalk_env_vars = var.webserver_env_vars
}