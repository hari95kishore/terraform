# terraform

Terraform code in the repo showcases creation of AWS resources with use of community modules and resources.

I have chosen community module terraform-aws-modules/vpc/aws and terraform-aws-modules/ecr/aws for creation of vpc and ecr respectively. 
I have opted to create ecs cluster, alb and its respective components using resources. So that both examples are covered. 

This repo uses circle CI for implementing CI-CD. Any change to infrastructure, triggers CI pipeline which does terraform init, plan and holds 
for manual approval. Up on approving the pipeline manually, it runs terraform apply and deploys infrastructure delta in AWS. 

The repo has been designed in a way, where you can reuse the code to deploy multiple ECS services by creating a <service>.tfvars file and 
changing the variables as per application need. Note that we need add a circle CI job for a new ECS service to automate the deploy.

Repo has 2 modules - ecs and network module, which are being called and used in main.tf. 

Currently the calculator service is available here - http://calculator-alb-1948783607.eu-central-1.elb.amazonaws.com/

Calculator application is deployed using the terraform code with fargate as capacity provider and has autoscaling based on ALB request count.
