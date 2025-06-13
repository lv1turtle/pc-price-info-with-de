from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from datetime import datetime
from airflow.providers.cncf.kubernetes.volume import Volume
from airflow.providers.cncf.kubernetes.volume_mount import VolumeMount

# Volume 정의
volume = Volume(
    name='shared-volume',
    configs={
        'persistentVolumeClaim': {
            'claimName': 'airflow-pvc'
        }
    }
)

# VolumeMount 정의
volume_mount = VolumeMount(
    name='shared-volume',
    mount_path='/opt/spark/',
    sub_path=None,
    read_only=False
)

# DAG 정의
with DAG(
    dag_id="spark_test_dag",
    start_date=datetime(2025, 6, 7),
    schedule_interval=None,
    catchup=False,
    tags=["spark", "k8s"],
) as dag:

    spark_submit = KubernetesPodOperator(
        task_id="spark_test_task",
        name="spark-submit",
        namespace="airflow",
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
