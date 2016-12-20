Set up order

1. VPC
2. Cluster definition
3. IAM role for ec2 instance
5. EC2 Instances

Run cadvisor everywhere - define the task, run it on the instance in the 
start up script. On retrospect we can use cloud watch and AWS to monitor
what's going on at the EC2 level, so it's been removed from the install.
To add it reference ecs_setup_with_cadvisor.txt in cluster-instances.tf



