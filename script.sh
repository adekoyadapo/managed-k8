#!/bin/bash
read -p "Enter provisioner - [fargate/autopilot]: " prov

if [[ $prov == "autopilot" ]]; then
  read -p "Create or Delete Autopilot Cluster? [enter create/delete]: " status 
  if [[ $status == "create" ]]; then
    read -p 'Cluster Name?: ' cluster_name
    read -p 'Region?: ' region
    read -p 'Project ID?: ' PROJECT_ID
    export PROJECT_ID=$PROJECT_ID
    if [[ $(gcloud container clusters list --filter=name:$cluster_name --format='value(name)') ]]; then
       echo "Cluster already exists"
       exit 0
    else
      echo "Creating auto pilot cluster"
      gcloud container clusters \
          create-auto $cluster_name \
          --region=$region \
          --project $PROJECT_ID
    fi
  elif [[ $status == "delete" ]]; then
     read -p 'Cluster Name?: ' cluster_name
     read -p 'Region?: ' region
     read -p 'Project ID?: ' PROJECT_ID
     export PROJECT_ID=$PROJECT_ID
     echo "Deleting $cluster_name ..."
     gcloud container clusters delete $cluster_name --region=$region --quiet
  else
     echo "Enter either create or delete and try again"
     exit 1
  fi
elif [[ $prov == "fargate" ]]; then
  read -p "Create or Delete Fargate Cluster? [enter create/delete]: " status 
  if [[ $status == "create" ]]; then
    read -p 'Cluster Name?: ' cluster_name
    read -p 'Region?: ' region
    read -p "AWS_KEY?: "$'\n' -s AWS_KEY
    read -p "AWS_ACCESS_KEY?: "$'\n' -s AWS_SECRET
    export AWS_ACCESS_KEY_ID=$AWS_KEY
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET
    export AWS_DEFAULT_REGION=$region
    if [[ $(eksctl get cluster --region $region --name $cluster_name ) ]]; then
       echo "Cluster already exists"
       exit 0
    else
      echo "Creating Fargate cluster"
      eksctl create cluster --name $cluster_name --fargate --region $region
    fi
  elif [[ $status == "delete" ]]; then
     read -p 'Cluster Name?: ' cluster_name
     read -p 'Region?: ' region
     read -p "AWS_KEY?: "$'\n' -s AWS_KEY
     read -p "AWS_ACCESS_KEY?: "$'\n' -s AWS_SECRET
     export AWS_ACCESS_KEY_ID=$AWS_KEY
     export AWS_SECRET_ACCESS_KEY=$AWS_SECRET
     echo "Deleting $cluster_name ..."
     eksctl delete cluster --force  --name $cluster_name --region $region
  else
     echo "Enter either create or delete and try again"
     exit 1
  fi
else
  echo "Enter either autopilot or fargate and try again"
  exit 1
fi