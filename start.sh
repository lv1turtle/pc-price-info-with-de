minikube start --driver=docker --memory=12288 --cpus=4

# minkube 내로 dag 및 data 전송
minikube cp ./shared /opt/shared