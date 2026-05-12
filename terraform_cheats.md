terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
terraform destroy -auto-approve

Sprawdza dostępnośc t3.micro w danym regione

```bash
aws ec2 describe-instance-type-offerings --location-type availability-zone --filters Name=instance-type,Values=t3.micro --region  eu-central-1 --output table

```

przy tworzeniu s3
trzeba na aws stworzyc bucket
