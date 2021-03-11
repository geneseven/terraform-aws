# trerraform-aws


## Directory Structure
In order to be able to expand in the future, we are creating the following directory structure in order to manage specific configuration in specific providers and regions. The directory structure is as follows:

terraform-aws
├── <cloud provider>
│   ├── <region> (ex. us-east-1)
│   │   ├── <envirnment> (ex. dev, staging, production)
│   │   │   ├── vpc
│   │   │   │   ├── terragrunt.hcl
│   │   │   ├── ...
│   │   │   └── <other applications>
│   │   ├── ...
│   │   └── <other environments>
│   ├── ...
│   └── <other regions>
