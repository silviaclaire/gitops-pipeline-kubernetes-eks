# Jenkins CI/CD pipelines for Kubernetes Appilication: Continuously Build and Deliver to Amazon EKS Cluster
End-to-End Jenkins CI/CD pipelines for Kubernetes application.
Use blue/green deployment strategy to deliver/deploy to a cluster on Amazon Elastic Kubernetes Service.

## Helpful Files

* `bin/setup_jenkins_ubuntu.sh`
  - All the commands to setup an EKS-ready Jenkins.
  - **This file is for reference only. DON'T RUN!**
* `bin/create_cluster_eks.sh`
  - Automatically create/update the roles & network used by EKS, and then create/update the cluster & its node group.
  - Same code is used in Jenkinsfile.
* `bin/deploy_k8s_app.sh`
  - Deploy the Kubernetes application using `kubectl`.
  - Same code is used in Jenkinsfile.

## How to Roll out a New Version

In the `develop` branch:
1. Commit the changes for the new version.
1. Update the `VERSION` variable in Jenkinsfile and commit.
1. Push `develop` to trigger CI stages in pipeline.

In the `staging` branch:
1. Pull and merge the latest `develop` branch.
1. Push `staging` to trigger CD stages in pipeline (will be deployed to **a copy of production environment**).

If everything is ready for production:
1. Checkout a `release/**` branch from `staging` branch.
1. Push and merge the branch to `master`
1. Push `master` to trigger CI+CD stages in pipeline (will be deployed to **the ACTUAL production environment**).

## An Example for CI

1. Assume that you already have an app running at version `1.0`.
1. And you make the following changes for a newer version `1.1`.
    ```bash
    sed -i "s/World/New World" app/app.py
    sed -i "s/World/New World" tests/test_app.py
    ```
1. **Update the version from `1.0` to `1.1` in Jenkinsfile.**

    _Otherwise the existing version will be OVERWRITTEN after running the pipeline._

    ```bash
    sed -i "s/VERSION = '1.0'/VERSION = '1.1'/" Jenkinsfile
    ```
1. Commit changes to `develop`, push to trigger the pipeline for CI.
