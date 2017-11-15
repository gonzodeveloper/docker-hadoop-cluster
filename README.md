# docker-hadoop-cluster
Parallel Hadoop/Spark cluster virtualized through docker containers

This project was created primarily for experimentation with running clusters under the docker architecture, particularly one with such an involved configuration such as the hadoop framework.

The Dockerfile can be built into an image such that derivative containers will have preset hadoop and spark configurations. The only two things missing are the tar-balls for hadoop and spark, which because of size limitations I could not include in this repo. These can be downloaded from http://apache.claz.org/hadoop/common/hadoop-2.8.1/ and https://spark.apache.org/downloads.html respectively (after download they should be placed in the scripts directoty).

Futhermore, for the time being, this configuration requires that the user has created a docker private network as follows docker network create --subnet=200.0.0.0/16 [NAME]. Aside from that, there is nothing further required.

The cluster can be stood up by running the build-cluster script with a specified number of worker nodes. Usage: build-cluster [NUMBER_OF_WORKERS]. Because password ssh is not hardcoded, and the /etc/hosts files are created after container initialization, we can use this script to stand up a cluster of arbitrary size (upto 255 workers for now).

Once the script is ran you will have a namenode with hostname 'master' and ip 200.0.0.10. The Hadoop and Spark services can be addressed through their default ports (i.e. HDFS Namenode=50070, Spark Master=7077).
