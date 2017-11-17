# docker-hadoop-cluster
**Parallel Hadoop/Spark cluster virtualized through Docker containers**

This project was created primarily for experimentation with running clusters under the Docker architecture, particularly one with such an involved configuration such as the Hadoop stack.

The Dockerfile can be built into an image such that derivative containers will have preset hadoop and spark configurations. The only two things missing are the tar-balls for hadoop and spark, which because of size limitations I could not include in this repo. These can be downloaded from http://apache.claz.org/hadoop/common/hadoop-2.8.1/ and https://spark.apache.org/downloads.html respectively (after download they should be placed in the scripts directoty).


Futhermore, for the time being, this configuration requires that the user has created a docker private network as follows **docker network create --subnet=200.0.0.0/16 [NAME]**. 

After the network is configured build the image with the command **docker build -t hadoop-cluster .** From here you can run tha main script. 

The cluster can be stood up by running the build-cluster script with a specified number of worker nodes. **Usage: build-cluster [NUMBER_OF_WORKERS]**. Because passwordless ssh is not hardcoded, and the /etc/hosts files are created after container initialization, we can use this script to stand up a cluster of arbitrary size (upto 255 workers for now).

Once the script is executed you will have a namenode with hostname 'master' and ip 200.0.0.10. The Hadoop and Spark services can be addressed through their default ports (i.e. HDFS Namenode=50070, Spark Master=7077).

