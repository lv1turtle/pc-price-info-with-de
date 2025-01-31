FROM cluster-base

ARG SPARK_VERSION=3.5.3

RUN apt-get update
RUN apt-get install -y python3-pip
RUN pip3 install pyspark

# Install Spark
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz
RUN tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt
RUN mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark
RUN rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

ENV PYSPARK_PYTHON=/usr/bin/python3
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
# foreground에서 실행 (container 유지 목적)
ENV SPARK_NO_DAEMONIZE=true

COPY conf/spark/* $SPARK_HOME/conf/

