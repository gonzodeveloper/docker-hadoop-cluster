# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Environment varibles required by Hadoop
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export HADOOP_PREFIX=/opt/hadoop/hadoop-2.8.1
export HADOOP_COMMON_HOME=/opt/hadoop/hadoop-2.8.1
export HADOOP_HDFS_HOME=/opt/hadoop/hadoop-2.8.1
export HADOOP_MAPRED_HOME=/opt/hadoop/hadoop-2.8.1
export YARN_HOME=/opt/hadoop/hadoop-2.8.1
export HADOOP_CONF_DIR=/opt/hadoop/hadoop-2.8.1/etc/hadoop

# Include Hadoop executables into PATH
export PATH=$PATH:$HADOOP_COMMON_HOME/bin
export PATH=$PATH:$HADOOP_COMMON_HOME/sbin

# Spark env and path requirements
export SPARK_HOME=/opt/spark
export SPARK_MASTER_HOST=master
export PATH=$PATH:$SPARK_HOME/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_COMMON_HOME/lib/native/
