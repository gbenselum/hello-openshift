#! /usr/bin/env bash

# Create the environments (DEV, TEST & PROD)
oc new-project hello-dev
oc new-project hello-test
oc new-project hello-prod

# Create the build objects
oc create -f src/main/resources/build.yaml -n hello-dev

# Create a Jenkins instance to run the pipeline in DEV environment
oc new-app --template=jenkins-ephemeral -n hello-dev

# Give edit permissions to Jenkins Service Account on TEST and PROD environments 
oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-test
oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-prod

oc new-build https://github.com/leandroberetta/hello-openshift.git --name hello-openshift-pipeline --strategy=pipeline -n hello-dev