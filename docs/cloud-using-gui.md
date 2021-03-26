---
id: cloud-using-gui
title: Using KeyDB Cloud
sidebar_label: Using KeyDB Cloud
---

## Launch a Deployment

A deployment is defined as a set of common nodes with shared properties. In this case it defines a cluster of KeyDB nodes/servers. In order to create a cluster simply click "Create Deployment" and fill out the parameters. See below for detailed descriptions of each setting

![image](/img/hosted/create_deployment.PNG)

* Name: This is the name of your deployment and is just a general description/identifier for the deployment
* Server Type: This is the type of dedicated server you can select from. You can select based on GB Memory or Ops/sec depending on your limiting factor. Keep in mind the GB value is the actual limit of data you can store. The actual server size has additional capacity for background tasks and saving. The Ops/sec value is a relative indicator of what a basic memtier workload achieves. Results for you may vary depending on the specific workload being run. For more information on the different offerings please see the Cloud spec
* Number of Masters: This is the number of master nodes in the cluster. Master nodes can accept reads and writes and each serve part of the workload.
* Number of Replicas: Replica nodes can accepts read requests and serve as highly available backup nodes to the master nodes. Should its master node go down, the replica will automatically be promoted to master to take its place while the failed master is restarted. It is highly recommended to have a replica node for each master should you wish to have a highly available cluster
* Allow Access from AWS services: This option essentially exposes any AWS nodes to port 6379 of the deployments nodes. This is useful for new processes spawning on AWS that require access to KeyDB. Password protection of the nodes is used to prevent unwanted access. Should you want to clamp down on security access and know the clients requiring access please do not select this option and add client IPs below
* Additional Access IP Addresses: this field allows you to enter all the ip addresses that require access to the KeyDB Cloud deployment. These IP addresses will be added to the associated security groups for access.

