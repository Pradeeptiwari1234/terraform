variable "conjur_api_key" {}

terraform {
  cloud {
    organization = "pradeeporg1"
    workspaces {
      name = "test" 
      }
        }
  required_providers {
    conjur = {
      source = "registry.terraform.io/cyberark/conjur"
      version = "0.6.3"
    }
  }
}

provider "conjur" {
  appliance_url = "https://conjur-server"
  account       = "myaccount"
  login         = "admin"
  api_key       = var.conjur_api_key
  # ssl_cert_path = "/etc/conjur.pem"
}

data "conjur_secret" "dbpass" {
  name = "terraform-example/dbpass"
}

output "dbpass-to-output" {
  value     = data.conjur_secret.dbpass.value
  sensitive = true
}

resource "local_file" "dbpass-to-file" {
  content         = data.conjur_secret.dbpass.value
  filename        = "${path.module}/../dbpass"
  file_permission = "0664"
}
