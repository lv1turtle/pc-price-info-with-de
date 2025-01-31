FROM cluster-base

ARG HADOOP_VERSION=3.4.1

# Install Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN tar -zxvf hadoop-${HADOOP_VERSION}.tar.gz -C /opt
RUN mv /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# core-site.xml, hdfs-site.xml, yarn-site.xml
COPY conf/hadoop/* $HADOOP_HOME/etc/hadoop/
