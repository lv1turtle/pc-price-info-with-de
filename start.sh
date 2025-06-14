minikube start --driver=docker --memory=12288 --cpus=4

# minkube 내로 dag 및 data 전송
tar -czf shared.tar.gz -C ./shared .
minikube cp shared.tar.gz minikube:/opt/airflow/shared.tar.gz
minikube ssh -- "sudo tar -xzf /opt/airflow/shared.tar.gz -C /opt/airflow && sudo rm -f /opt/airflow/shared.tar.gz"
rm -f shared.tar.gz