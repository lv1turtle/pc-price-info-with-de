from pyspark.sql import SparkSession

# 세션 생성
spark = SparkSession.builder \
    .appName("PySpark WordCount Example") \
    .getOrCreate()

# 입력 파일 경로
input_path = "/opt/spark/data/input.txt"

# 파일 읽기
text_rdd = spark.sparkContext.textFile(input_path)

# 단어 분할 및 집계
word_counts = text_rdd.flatMap(lambda line: line.split()) \
                      .map(lambda word: (word, 1)) \
                      .reduceByKey(lambda a, b: a + b)

# 결과 출력
word_counts.collect()

# 종료
spark.stop()
