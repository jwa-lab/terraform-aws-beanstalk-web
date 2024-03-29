output "instances_security_group_id" {
  value = module.beanstalk.instances_security_group_id
}

output "instance_role" {
  value = module.beanstalk.instance_role
}

output "load_balancer_arn" {
  value = module.beanstalk.beanstalk_env.load_balancers[0]
}

output "beanstalk_env_cname" {
  value = module.beanstalk.beanstalk_env.cname
}