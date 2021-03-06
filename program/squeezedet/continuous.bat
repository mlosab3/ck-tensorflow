set ROOT=%CK_ENV_MODEL_SQUEEZEDET_ROOT%

set OUT_DIR=%cd%\out
rm -rf %OUT_DIR%

set PYTHONPATH=%PYTHONPATH%;%ROOT%\src

rem supress TF debug output
set TF_CPP_MIN_LOG_LEVEL=3

set IMAGES=%CK_ENV_DATASET_KITTI_IMAGE_DIR%
set LABELS=%CK_ENV_DATASET_KITTI_LABELS_DIR%
set CHECKPOINT="%ROOT%\data\model_checkpoints\squeezeDet\model.ckpt-87000"

"%CK_ENV_COMPILER_PYTHON_FILE%" "..\continuous.py" --image_dir="%IMAGES%" --label_dir="%LABELS%" --out_dir="%OUT_DIR%" --checkpoint="%CHECKPOINT%"
