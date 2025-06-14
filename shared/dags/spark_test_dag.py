from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from kubernetes.client.models import V1Volume, V1VolumeMount, V1PersistentVolumeClaimVolumeSource
from airflow.utils.dates import days_ago

volume = V1Volume(
    name="airflow-pvc",
    persistent_volume_claim=V1PersistentVolumeClaimVolumeSource(claim_name="airflow-pvc")
)
volume_mount = V1VolumeMount(
    name="airflow-pvc",
    mount_path="/opt/bitnami/spark/shared",
    sub_path=None,
    read_only=False
)

# Default DAG arguments
default_args = {
    'start_date': days_ago(1) # 실행 시작 일을 어제로 지정
}

# Define the DAG
with DAG(
    dag_id="spark_test_dag",
    default_args=default_args,
    schedule_interval=None,
    catchup=False
) as dag:
    spark_task = KubernetesPodOperator(
        task_id="spark_submit_job",
        name="spark-test",            # Pod name
        namespace="airflow",          # Kubernetes namespace to launch pod in
        image="my-spark:latest",      # Spark image
        cmds=["/opt/bitnami/spark/bin/spark-submit"],
        arguments=[
            "--master", "k8s://https://kubernetes.default.svc:443",
            "--deploy-mode", "cluster",
            "local:///opt/spark/jobs/wordcount_example.py"
        ],
        volumes=[volume],
        volume_mounts=[volume_mount],
        in_cluster=True, # k8s 내부에서 실행
        is_delete_operator_pod=False,
        get_logs=True,
        image_pull_policy='IfNotPresent' #  Minikube 내부에 이미지가 있을 경우 다시 pull하지 않고 바로 사용
    )
