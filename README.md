An attempt to use the following together:  
* Amazon S3
* AWS Glue
* Amazon Redshift serverless
* dbt (data build tool)
  
<br>

# virtualenv

### creation & activation
```
make create-venv
source ./venv/bin/activate
make install-packages
```

### deactivation & deletion
```
deactivate
rm -rf venv
```