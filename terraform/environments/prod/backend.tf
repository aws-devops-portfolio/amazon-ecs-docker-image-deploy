terraform {
  backend "s3" {
    bucket       = "devhub164-state-demo"
    key          = "s3-github-actions/ecs/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}