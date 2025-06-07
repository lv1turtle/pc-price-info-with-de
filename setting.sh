# Spark

docker build -t my-spark .

# docker push (X)
# upload in minikube
minikube image load my-spark:latest

#----------------------------------------------------
# Airflow (1) : install

# After install helm
helm repo add apache-airflow https://airflow.apache.org
helm repo update

# cluster 내에 airflow 환경 생성
kubectl create namespace airflow

# pvc 등록
kubectl apply -f airflow/airflow-pvc.yaml

helm install airflow apache-airflow/airflow \
  -n airflow \
  -f airflow/airflow-values.yaml \
  -f airflow/secrets.yaml

# check status
kubectl get pods -n airflow
kubectl get pvc -n airflow
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow

#--------------------------------------------------------------
# Airflow (2) : Dag - KubernetesPodOperator