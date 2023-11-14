# Datasette Deploy to Lambda Function 

## Setup

You should have a directory with three items in it for your datasette deploy.  Once you run the scrip below you will have a new directory automatically created for you (`deployment_package`).  For example, for the `fixtures` project it would looke like this.

```
- fixtures (dir)
    - lambda_function.py 
    - requirements.txt # requirements for this deploy, must include pysqlite-binary, datasette, magnum
    - fixtures.db # Sqlite database to be deployed
    - deployment_package/ # Created by script and will only exist after the first deploy
        - datasette
        - mangum
        - lambda_function.py
        - fixtures.db
        - pysqlite-binary
        - etc.
```

## Build Module

```bash
docker build -t requirements_binaries . 
create_deployment_package.sh <folder> requirements_binaries
```

## Deploy in Terraform

Add module to Datanym/main.tf.  It will look at this to give a name and point to the deployment directory that was created by the scrip int he build module section.

```terraform
module "fixtures_datasette1" {
  source             = "./datasette" # Module source, Do not change
  function_name      = "fixtures_datasette" # Internal name of lambda function in AWS
  deployment_directory = "inputs/datasette_deployment/fixtures/deployment_package" # Path to directory with dependencies
  lambda_role_arn    = module.iam.lambda_role_arn # role with permissions, Do not change 
}
```

You will then need to initialize and deploy using `terraform init` and `terraform apply`.


## Updating the deploy

1. Update the deployment directory by following the steps in the Build Module section
2. Run Terraform apply.  Terraform hashes the directory when zipping so will detect if new deploy is needed

