# Terraform Assignment

## Create credentials.tfvars file and add AWS credentials to it.
```AWS_ACCESS_KEY = "AKIAXXXXXXXXXXXXXXX"```

```AWS_SECRET_KEY = "fmEUXXXXXXXXXXXXXXXXXXXXXXXXXXX"```

## Create a bucket and configure your s3 bakend

```
terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "infracloud-test-state" #Change this bucket
    key    = "terraform.tfstate"
    region = "eu-west-2" # Change region
  }
}

```
## Run terraform code:
```terraform init```

```terraform apply --var-file=credentials.tfvars```

## Find Instance, ssh-key and RDS info in output