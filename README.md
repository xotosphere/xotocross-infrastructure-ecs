# ECS Service Module

This repository contains the Terraform module for creating a scalable and highly available ECS service on AWS. 
This module is designed to be used with external services.

## Features 🔥

This module creates the following AWS resources:

- **Cloudwatch**: This section includes all CloudWatch resources related to EC2. It contains the configuration for CloudWatch alarms, metrics, and dashboards. Alarms are set up to monitor key metrics such as CPU utilization and network traffic. Metrics are collected for analysis and to provide data for the alarms. Dashboards are configured to provide a visual representation of the metrics and alarms, allowing for easy monitoring of the EC2 instances.

- **Cross**: This section contains the configuration for cross-application dependencies. It ensures that all services and applications are properly linked and can communicate with each other as needed.

- **Elb**: This section includes the configuration for the Elastic Load Balancer (ELB). The ELB automatically distributes incoming application traffic across multiple targets, such as EC2 instances, to increase the availability and fault tolerance of your applications.

- **Route53**: This section includes the configuration for Amazon Route 53, a highly available and scalable cloud Domain Name System (DNS) web service. It is designed to give developers and businesses an extremely reliable and cost-effective way to route end users to Internet applications.

- **Scheduletask**: This section contains the configuration for scheduled tasks. These are tasks that are set to run at specific times or at regular intervals. They can be used to automate routine tasks and ensure that they are performed consistently.

- **Service**: This section includes the configuration for the various services that make up the application. This could include web servers, databases, caching systems, and more. Each service is configured to meet the specific needs of the application.
