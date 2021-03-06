#! /bin/bash

# CK installation script for the squeezeDet package (TensorFlow model).
# See LICENCE.md in the squeezeDet package folder for the model license.
#
# Developer(s):
# - Vladislav Zaborovskiy, vladzab@yandex.ru, 2017
# - Anton Lokhmotov, anton@dividiti.com, 2017
#

# PACKAGE_DIR
# INSTALL_DIR
# SQUEEZEDET_URL
#
# DEMO_URL
#
# SQUEEZENET_INCLUDED, CNN_SQUEEZENET_URL
# RESNET50_INCLUDED, CNN_RESNET50_URL
# VGG16_INCLUDED, CNN_VGG16_URL
#
# TENSORFLOW_URL

export SQDT_INSTALL=${INSTALL_DIR}/squeezeDet
export SQDT_ROOT=${SQDT_INSTALL}
export SQDT_DATA=${SQDT_ROOT}/data

######################################################################################
echo ""
echo "Removing everything from '${INSTALL_DIR}' ..."
rm -rf ${INSTALL_DIR}/*
mkdir ${SQDT_INSTALL}

######################################################################################
echo ""
echo "Cloning SqueezeDet from '${SQUEEZEDET_URL}' to '${SQDT_INSTALL}' ..."
git clone ${SQUEEZEDET_URL} ${SQDT_INSTALL}
if [ "${?}" != "0" ] ; then
  echo "Error: Cloning SqueezeDet from '${SQUEEZEDET_URL}' failed!"
  exit 1
fi

######################################################################################
echo ""
echo "Downloading demo model parameters to '${SQDT_DATA}' ..."
wget -P ${SQDT_DATA} ${DEMO_URL}
if [ "${?}" != "0" ] ; then
  echo "Error: Downloading demo archive from '${DEMO_URL}' failed!"
  exit 1
fi

######################################################################################
echo ""
echo "Extracting demo archive '${SQDT_DATA}'/model_checkpoints.tgz ..."
tar -xzvf ${SQDT_DATA}/model_checkpoints.tgz -C ${SQDT_DATA}/
if [ "${?}" != "0" ] ; then
  echo "Error: Extracting demo archive '${SQDT_DATA}'/model_checkpoints.tgz failed!"
  exit 1
fi
rm ${SQDT_DATA}/model_checkpoints.tgz

######################################################################################
echo ""
echo "Downloading pretrained CNN models to '${SQDT_DATA}'/ ..."

if [ "$SQUEEZENET_INCLUDED" != "0" ] ; then
  echo "Downloading pretrained SqueezeNet CNN archive from '${CNN_SQUEEZENET_URL}' ..."
  wget -P ${SQDT_DATA} ${CNN_SQUEEZENET_URL}
  if [ "${?}" != "0" ] ; then
    echo "Error: Downloading SqueezeNet CNN archive from '${CNN_SQUEEZENET_URL}' failed!"
    echo "To skip downloading this CNN archive, set the 'SQUEEZENET_INCLUDED' parameter in 'tensorflowmodel-squeezedet/.cm/meta.json' to 0."
    exit 1
  fi

  echo ""
  echo "Extracting '${SQDT_DATA}'/SqueezeNet.tgz ..."
  tar -xzvf ${SQDT_DATA}/SqueezeNet.tgz -C ${SQDT_DATA}/
  if [ "${?}" != "0" ] ; then
    echo "Error: Extracting CNN archive '${SQDT_DATA}'/SqueezeNet.tgz failed!"
    exit 1
  fi

  rm ${SQDT_DATA}/SqueezeNet.tgz
fi


if [ "$RESNET50_INCLUDED" != "0" ] ; then
  echo ""
  echo "Downloading pretrained ResNet50 CNN archive from '${CNN_RESNET50_URL}' ..."
  wget -P ${SQDT_DATA} ${CNN_RESNET50_URL}
  if [ "${?}" != "0" ] ; then
    echo "Error: Downloading ResNet50 CNN archive from '${CNN_RESNET_URL}' failed!"
    echo "To skip downloading this CNN archive, set the 'RESNET50_INCLUDED' parameter in 'tensorflowmodel-squeezedet/.cm/meta.json' to 0."
    exit 1
  fi

  echo ""
  echo "Extracting '${SQDT_DATA}'/ResNet.tgz ..."
  tar -xzvf ${SQDT_DATA}/ResNet.tgz -C ${SQDT_DATA}/
  if [ "${?}" != "0" ] ; then
    echo "Error: Extracting CNN archive '${SQDT_DATA}'/ResNet.tgz failed!"
    exit 1
  fi

  rm ${SQDT_DATA}/ResNet.tgz
fi

if [ "$VGG16_INCLUDED" != "0" ] ; then
  echo ""
  echo "Downloading pretrained VGG16 CNN archive from '${CNN_VGG16_URL}' ..."
  wget -P ${SQDT_DATA} ${CNN_VGG16_URL}
  if [ "${?}" != "0" ] ; then
    echo "Error: Downloading VGG16 CNN archive from '${CNN_VGG16_URL}' failed!"
    echo "To skip downloading this CNN archive, set the 'VGG16_INCLUDED' parameter in 'tensorflowmodel-squeezedet/.cm/meta.json' to 0."
    exit 1
  fi

  echo ""
  echo "Extracting '${SQDT_DATA}'/VGG16.tgz ..."
  tar -xzvf ${SQDT_DATA}/VGG16.tgz -C ${SQDT_DATA}/
  if [ "${?}" != "0" ] ; then
    echo "Error: Extracting CNN archive '${SQDT_DATA}'/VGG16.tgz failed!"
    exit 1
  fi

  rm ${SQDT_DATA}/VGG16.tgz
fi

######################################################################################
# Some minor text editing to temporarily address point 1 in issue #10
# (https://github.com/ctuning/ck-tensorflow/issues/10).
echo ""
echo "Making a minor source code change ..."
sed -i 's/reduction_indices/axis/g' ${SQDT_ROOT}/src/nn_skeleton.py
git -C ${SQDT_ROOT} diff

######################################################################################
echo ""
echo "Cleaning ..."

exit 0
