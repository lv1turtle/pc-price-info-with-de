docker build -t my-spark .

# docker push (X)
# upload in minikube
minikube image load my-spark:latest

# After install helm
helm repo add apache-airflow https://airflow.apache.org
helm repo update
kubectl create namespace airflow

# pvc 등록
kubectl apply -f airflow/airflow-dags-pvc.yaml

helm install airflow apache-airflow/airflow \
  -n airflow \
  -f airflow/airflow-values.yaml \
  -f airflow/secrets.yaml

# check status
kubectl get pods -n airflow
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow