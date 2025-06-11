minikube start --driver=docker --memory=12288 --cpus=4

# minkube 내로 dag 및 data 전송
tar -czf shared.tar.gz -C ./shared .
minikube cp shared.tar.gz minikube:/home/docker/shared.tar.gz
minikube ssh -- "mkdir -p /home/docker/shared && tar -xzf /home/docker/shared.tar.gz -C /home/docker/shared && rm -f /home/docker/shared.tar.gz"
rm -f shared.tar.gz