# ECS Application Creation Demo

## Set Up

1. VPC (vpc)
2. Cluster definition (ecs-cluster)
3. IAM role for ec2 instance (iam-role)
4. EC2 Instances (ec2-instances)
5. Health check task def (hc) - Note this is a demo proxy for a service to be served via HTTP
6. Application load balancer (alb) 
7. ECS service


## Running a Task on Each Cluster Member

Not sure if this will auto restart... will need some more research.

Run cadvisor everywhere - define the task, run it on the instance in the 
start up script. On retrospect we can use cloud watch and AWS to monitor
what's going on at the EC2 level, so it's been removed from the install.
To add it reference ecs_setup_with_cadvisor.txt in cluster-instances.tf



## Notes

Console sequence - load balanced service

0. Security group allowing external ingres
1. lb def - port 80 listener, vpc, public subnets, reference sg
2. new target group - use container ports and health check uri
3. Register targets (cluster instances)
4. ECS console - create service def
5. Service lb config - IAM role is ecsServiceRole, elbname, container with
port mapping hc:15000:5000
listener port - pick 80, pick service-target group, path is /, health is /health, create

Parts:

* Security group to allow ingress on load balancer
* ECS instance security group that grants access to the lb ingress security group
* 

alb script, add health check :15000/health, register instances as targets (80),
create service - ref load balance, hc:15000:5000 add alb sg to instances sg
==> works

Next: create lb sg in the instances script, reference in the alb script and instances
script, then add health check config to target group