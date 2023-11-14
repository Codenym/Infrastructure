# Datasette Deploy to Lambda Function 

## Background

Basically all of this is from the steps described [here](https://til.simonwillison.net/awslambda/asgi-mangum) by datasette creator [Simon Willison](https://simonwillison.net/).  I converted some of his stuff to terraform and structured it for convenience, but there's no new concepts here that aren't in his guide.  If you want to understand this, it'd be best to start with his walkthrough first.

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

This script runs will run the requirements.txt file and package those dependencies with the sqlite database and the lambda function in the format required by AWS lambda.  All deploy and infrastructure is done in terraform and not here.

```bash
docker build -t requirements_binaries . # Only if you haven't built recently
create_deployment_package.sh <folder> requirements_binaries
```

## Deploy in Terraform

Add module to `Datanym/main.tf`.  It will look at this to give a name and point to the deployment directory that was created by the scrip in the build module section.

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
2. Run `Terraform apply`.  Terraform hashes the directory when zipping and will detect if new deploy is needed based on state

