from airflow.sdk import DAG
from airflow.sdk.operators.kubernetes import KubernetesPodOperator
#from airflow.sdk.triggers.base import Trigger 
from airflow.sdk.time import datetime
from airflow.kubernetes.volume import Volume
from airflow.kubernetes.volume_mount import VolumeMount

volume = Volume(
    name='shared-volume',
    configs={'persistentVolumeClaim': {'claimName': 'airflow-pvc'}}
)

volume_mount = VolumeMount(
    name='shared-volume',
    mount_path='/opt/spark/',
    sub_path=None,
    read_only=False
)

with DAG(
    dag_id="spark_test_dag",
    start_date=datetime(2025, 6, 7),
    schedule=None,
    catchup=False,
    tags=["spark", "k8s"],
) as dag:

    spark_submit = KubernetesPodOperator(
        task_id="spark_test_task",
        name="spark-submit",
        namespace="airflow",  # Helm 설치한 namespace와 동일
        image="my-spark:latest",
        cmds=["/opt/spark/bin/spark-submit"],
        arguments=[
            "--master", "k8s://https://kubernetes.default.svc:443",
            "--deploy-mode", "cluster",
            "--conf", "spark.kubernetes.container.image=my-spark:latest",
            "local:///opt/spark/jobs/wordcount_example.py"
        ],
        volumes=[volume],
        volume_mounts=[volume_mount],
        get_logs=True,
        is_delete_operator_pod=True,
    )
