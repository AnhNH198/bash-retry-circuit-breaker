#!/bin/bash
printf -v date '%(%Y-%m-%d)T\n' -1
echo $date
aws s3api list-objects-v2 --bucket product-demo-13323 --query 'Contents[?LastModified>=`$date`].Key'
