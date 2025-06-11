# minikube start
#----------------------------------------------------
minikube start --driver=docker --memory=12288 --cpus=4

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

# minkube 내로 dag 및 data 전송
tar -czf shared.tar.gz -C ./shared .
minikube cp shared.tar.gz minikube:/opt/airflow/shared.tar.gz
minikube ssh -- "sudo tar -xzf /opt/airflow/shared.tar.gz -C /opt/airflow && sudo rm -f /opt/airflow/shared.tar.gz"
rm -f shared.tar.gz


# pv, pvc 등록
kubectl apply -f airflow/airflow-pv.yaml
kubectl apply -f airflow/airflow-pvc.yaml

helm install airflow apache-airflow/airflow \
  -n airflow \
  -f airflow/airflow-values.yaml \
  -f airflow/secrets.yaml

# helm 수정 시 재배포
helm upgrade airflow apache-airflow/airflow -f airflow/airflow-values.yaml -n airflow


# install 실패시 삭제
# helm uninstall airflow -n airflow

# check status
kubectl get pods -n airflow
kubectl get pvc -n airflow
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow

#--------------------------------------------------------------
# Airflow (2) : Dag - KubernetesPodOperator