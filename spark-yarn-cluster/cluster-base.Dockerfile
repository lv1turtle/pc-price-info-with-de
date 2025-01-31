# debian + jdk 8 이상은 class 접근 제한 발생 + jre + slim
FROM openjdk:8-jre-slim

RUN apt-get update
RUN apt-get install -y wget vim procps
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN rm -rf /var/lib/apt/lists/*