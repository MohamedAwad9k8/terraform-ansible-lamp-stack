# Deploying a Two-Tier LAMP Stack E-commerce App Using Terraform and Ansible

## Overview  
This project demonstrates how to automate the deployment and configuration of a **two-tier LAMP stack e-commerce application** using **Terraform** and **Ansible**.

- **Terraform** provisions the infrastructure on AWS, including the **VPC, subnets, security groups, and EC2 instances** for the web and database servers.
- **Ansible** configures the servers by installing and setting up **Apache, MySQL, PHP, and the e-commerce application**.

### Architecture  
The deployment consists of:  
- **Web Server (Public Subnet)** – Hosts the Apache web server and PHP application. Also provides **SSH access** to the private database server.  
- **Database Server (Private Subnet)** – Runs MySQL and is **accessible only from the web server** for security purposes.

By using **Terraform for infrastructure provisioning** and **Ansible for configuration management**, this project follows **Infrastructure as Code (IaC) principles** for efficient and repeatable deployments.

---

## Tools and Services Used  

### **Infrastructure**  
- **Terraform** – Automates AWS infrastructure provisioning.  
- **AWS VPC** – Provides network isolation.  
- **AWS Subnets & Routing** –  
  - Public subnet: Allows web server access from the internet.  
  - Private subnet: Keeps the database secure.  
- **AWS Internet Gateway (IGW)** – Enables internet access for the web server.  
- **AWS EC2** – Hosts the web and database servers.  
- **AWS Security Groups** – Enforces strict access controls.  
- **AWS Elastic IP** – Provides a static public IP for the web server.  

### **Configuration**  
- **Ansible** – Configures the web and database servers:  
  - Installs and sets up **Apache, MySQL, PHP, and the e-commerce application**.  

---

## Getting Started  

### **Prerequisites**  
Ensure you have the following installed on your local machine:  
- [Terraform](https://developer.hashicorp.com/terraform/downloads)  
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)  
- AWS CLI configured with valid credentials  

### **Deployment Steps**  

#### **Step 1: Clone the Repository**
```sh
git clone https://github.com/MohamedAwad9k8/lamp-ecommerce-deployment.git
cd lamp-ecommerce-deployment
```

#### **Step 2: Deploy the Infrastructure with Terraform**
```sh
terraform init
terraform apply -auto-approve
```

#### **Step 3: Configure Servers with Ansible**
```sh
ansible-playbook -i inventory playbook.yml
```

#### **Step 4: Access the Application**
Once the deployment is complete, access the web application using the Elastic IP assigned to the web server:
```sh
http://your-elastic-ip
```

#### **Step 5: CleanUp**
To destroy the deployed resources and avoid unnecessary AWS costs, run:
```sh
terraform destroy -auto-approve
```
