import sys
import re
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import current_timestamp
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame

args = getResolvedOptions(sys.argv, ["JOB_NAME", "tables"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

for table in args["tables"].replace(" ", "").split(","):
    input_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
        database="tickit_raw",
        table_name=f"{table}_txt",
        transformation_ctx="extract",
    )
    
    dataframe = input_dynamic_frame.toDF()
    schema_ddl = ", ".join([f"{field.name} {field.dataType.simpleString()}" for field in dataframe.schema.fields])
    
    # Changing PySpark DDL to Redshift DDL
    string_pattern = re.compile("string", re.IGNORECASE)
    long_pattern = re.compile("long", re.IGNORECASE)
    double_pattern = re.compile("double", re.IGNORECASE)
    float_pattern = re.compile("float", re.IGNORECASE)
    
    schema_ddl = string_pattern.sub("VARCHAR", schema_ddl)
    schema_ddl = long_pattern.sub("BIGINT", schema_ddl)
    schema_ddl = double_pattern.sub("DOUBLE PRECISION", schema_ddl)
    schema_ddl = float_pattern.sub("REAL", schema_ddl)
    
    schema_ddl += ",ingestion_timestamp TIMESTAMP"
    print(schema_ddl)

    dataframe = dataframe.withColumn("ingestion_timestamp", current_timestamp())
    output_dynamic_frame = DynamicFrame.fromDF(dataframe, glueContext, "output_dynamic_frame")
    
    glueContext.write_dynamic_frame.from_options(
        frame=output_dynamic_frame,
        connection_type="redshift",
        connection_options={
            "redshiftTmpDir": "s3://aws-glue-assets-102606406933-eu-central-1/temporary/",
            "useConnectionProperties": "true",
            "dbtable": f"tickit_raw.{table}",
            "connectionName": "glue-redshift-connection",
            "preactions": f"DROP TABLE IF EXISTS tickit_raw.{table}; CREATE TABLE tickit_raw.{table} ({schema_ddl});",
            "aws_iam_user": "arn:aws:iam::102606406933:role/glue-role",
        },
        transformation_ctx="load",
    )

    job.commit()