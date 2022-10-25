## Creating an infrastructure in GPC using Terraform



### Create file terraform.tfvars on root directory before start

``` tf
project_id = "project_name"
credentials_file_path = "./your_key.json"
service_account = "your-service_account@project_name.iam.gserviceaccount.com"
region = "europe-west1"
main_zone = "europe-west1-b"
cluster_name = "cluster_name"
cluster_node_zones = ["europe-west1-b","europe-west1-c","europe-west1-d"]
```

### Terraform commands

```sh
terraform plan
terraform apply
terraform destroy 
```

### References
- [Terraform docs for CGP](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [How to install and configure gcloud cli](https://cloud.google.com/sdk/docs/install#deb)
- [About VPC Peering](https://cloud.google.com/vpc/docs/vpc-peering)
- [How to create a private gke cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
- [How to access private cluster from bastion host](https://cloud.google.com/kubernetes-engine/docs/tutorials/private-cluster-bastion)
- [About subnets masks](https://www.freecodecamp.org/portuguese/news/ficha-informativa-de-sub-redes-mascara-de-sub-rede-24-30-26-27-29/)
- [Kubernetes cheat sheet](https://kubernetes.io/pt-br/docs/reference/kubectl/cheatsheet/)