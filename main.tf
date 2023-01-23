terraform {
  cloud {
    organization = "pradeeporg1"
    workspaces {
      name = "test" 
      }
        }
  required_providers {
    conjur = {
      source = "cyberark/conjur"
      version = "0.6.3"
    }
  }
}

provider "conjur" {
  appliance_url = "https://104.154.202.145:443"
  account       = "conjur"
  login         = "admin"
  api_key       = "3ehgetm1v6amcf189g2qd2xj81j13b2qrysvevtjaaegt0d3k4jbrp"
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
