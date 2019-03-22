# terraform-ECS
  
  Follow the below mentioned steps:
  
  1. Initially we need to install the terraform on desired machine

  2. To allow 443 port to ALB we have to generate certificates, which can be done by using below commands
      a.Generate Private Key
      command: openssl genrsa 2048 > my-private-key.pem

      b. Generate Self Signed Certificate
      command: openssl req -new -x509 -nodes -sha256 -days 365 -key my-private-key.pem -outform PEM -out my-certificate.pem

      c. Upload Self Signed Certificate to AWS IAM
         Upload Certificate
      command: aws iam upload-server-certificate --server-certificate-name MyCertificate --certificate-body file://my-certificate.pem --private-key file://my-private-key.pem

      d. To list ssl:
      command: aws iam list-server-certificates


  3. git clone https://gitlab.gerdau.digital/phani.chekuri/terraform-ECS.git
  4. cd terraform-ECS
  5. Here we need to change the terraform.tfvars file according to our requirement/configurations
  6. Next do following terraform commands 
  `
          terraform init
          terraform plan
          terraform apply
  `
