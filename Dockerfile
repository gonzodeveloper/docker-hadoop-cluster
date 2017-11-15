FROM centos
MAINTAINER kylehart@hawaii.edu

# Install java, openssh, and other tools
RUN yum clean all \
    && yum update -y \
    && yum install sudo which wget openssh-server openssh-clients rsync -y \
    && yum install java-1.8.0-openjdk -y

# Install Hadoop
COPY scripts/hadoop-2.8.1.tar.gz /

RUN mkdir /opt/hadoop \
    && tar -xzf hadoop-2.8.1.tar.gz \
    && rm -f hadoop-2.8.1.tar.gz \
    && mv hadoop-2.8.1 /opt/hadoop

# Create User and get permissions
RUN useradd hadoop \
    && chown -R hadoop:hadoop /opt/hadoop

# Install Spark
COPY scripts/spark-2.2.0-bin-hadoop2.7.tgz /

RUN tar -xzf spark-2.2.0-bin-hadoop2.7.tgz >> /dev/null \
    && mv spark-2.2.0-bin-hadoop2.7 /opt/spark \
    && rm -f spark-2.2.0-bin-hadoop2.7.tgz

# Set environment variables
COPY scripts/.bashrc /root/.bashrc
COPY scripts/.bashrc /home/hadoop/.bashrc

# Environment variables required by Hadoop
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV HADOOP_PREFIX=/opt/hadoop/hadoop-2.8.1
ENV HADOOP_COMMON_HOME=/opt/hadoop/hadoop-2.8.1
ENV HADOOP_HDFS_HOME=/opt/hadoop/hadoop-2.8.1
ENV HADOOP_MAPRED_HOME=/opt/hadoop/hadoop-2.8.1
ENV YARN_HOME=/opt/hadoop/hadoop-2.8.1
ENV HADOOP_CONF_DIR=/opt/hadoop/hadoop-2.8.1/etc/hadoop

# Include Hadoop executables into PATH
ENV PATH=$PATH:$HADOOP_COMMON_HOME/bin
ENV PATH=$PATH:$HADOOP_COMMON_HOME/sbin

# Spark environment vars
ENV SPARK_HOME=/opt/spark
ENV SPARK_MASTER_HOST=master
ENV PATH=$PATH:$SPARK_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_COMMON_HOME/lib/native/

# Copy in Hadoop config files
COPY scripts/*.xml $HADOOP_PREFIX/etc/hadoop/

# Fix SSHD and SSH config
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config \
    && echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "StrictHostKeyChecking no" >> etc/ssh/ssh_config

# Get SSH Keys and start daemon
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN mkdir /init

# HDFS Required ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# YARN Required ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# SSH
EXPOSE 22
# Spark Required ports
EXPOSE 7077 8080 8081 4040

CMD ["/bin/bash"]
