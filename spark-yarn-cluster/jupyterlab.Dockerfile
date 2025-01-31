FROM cluster-base

RUN apt-get update
RUN apt-get install -y python3-pip
RUN pip3 install wget pyspark
RUN pip3 install jupyterlab==2.1.5

ENV PYSPARK_PYTHON=/usr/bin/python3
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token="]