FROM bitnami/spark:3.5.0

USER root
RUN apt-get update && apt-get install -y python3-pip && pip3 install pandas

# 기본 작업 디렉토리
WORKDIR /opt/spark