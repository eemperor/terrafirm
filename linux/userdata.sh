#!/bin/bash

exec &> ${tfi_lx_userdata_log}

yum -y install bc

#sleep 20
start=`date +%s`

WATCHMAKER_INSTALL_GOES_HERE

end=`date +%s`
runtime=$((end-start))
echo "WAM install took $runtime seconds."

export S3_TOP_KEYFIX=$(echo ${tfi_build_id} | cut -d'_' -f 1)
export OS_VERSION=$(cat /etc/redhat-release | cut -c1-3)$(cat /etc/redhat-release | sed 's/[^0-9.]*\([0-9]\.[0-9]\).*/\1/')
export S3_KEYFIX=$(date +'%Y%m%d_%H%M%S_')$OS_VERSION

aws s3 cp ${tfi_lx_userdata_log} "s3://${tfi_s3_bucket}/$${S3_TOP_KEYFIX}/${tfi_build_id}/$${S3_KEYFIX}/userdata.log" || true
aws s3 cp /var/log "s3://${tfi_s3_bucket}/$${S3_TOP_KEYFIX}/${tfi_build_id}/$${S3_KEYFIX}/cloud-init/" --recursive --exclude "*" --include "cloud*log" || true
aws s3 cp /var/log/watchmaker "s3://${tfi_s3_bucket}/$${S3_TOP_KEYFIX}/${tfi_build_id}/$${S3_KEYFIX}/watchmaker/" --recursive || true

touch /tmp/SETUP_COMPLETE_SIGNAL
