#! /usr/bin/env bash

cd ../ > /dev/null

download() {
    URL=$1
    MD5=$2
    TARGET=$3

    if [ -e $TARGET ]; then
        md5_result=`md5sum $TARGET | awk -F[' '] '{print $1}'`
        if [ $MD5 == $md5_result ]; then
            echo "$TARGET already exists, download skipped."
            return 0
        fi
    fi

    wget -c $URL -O "$TARGET"
    if [ $? -ne 0 ]; then
        return 1
    fi

    md5_result=`md5sum $TARGET | awk -F[' '] '{print $1}'`
    if [ ! $MD5 == $md5_result ]; then
        return 1
    fi
}

mkdir models

# Download pretrained model
#URL='https://deepspeech.bj.bcebos.com/demo_models/baidu_cn1.2k_model_fluid.tar.gz'
URL='http://192.168.1.118:55000/baidu_cn1.2k_model_fluid.tar.gz'
MD5=4e4e64dea5f83703ea4b8d601df91000
TARGET=./models/baidu_cn1.2k_model_fluid.tar.gz


echo "Download baidu_cn1.2k_model_fluid  model ..."
download $URL $MD5 $TARGET
if [ $? -ne 0 ]; then
    echo "Fail to download pretrained model model!"
    exit 1
fi
tar -zxvf $TARGET ./models/baidu_cn1.2k_model_fluid/


# Download language model
#URL='https://deepspeech.bj.bcebos.com/zh_lm/zhidao_giga.klm'
URL='http://192.168.1.118:55000/zhidao_giga.klm'
MD5=1cf449f2123d80504e99f9b97d965418
TARGET=./models/zhidao_giga.klm

echo "Download language model ..."
download $URL $MD5 $TARGET
if [ $? -ne 0 ]; then
    echo "Fail to download language model!"
    exit 1
fi


exit 0
