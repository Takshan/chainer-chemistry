set -eu

# List of available graph convolution methods.
methods=(nfp ggnn schnet weavenet rsgcn relgcn relgat megnet)

prefix=eval_

# device identifier; set it to -1 to train on the CPU (default).
device=${1:--1}
# Number of training epochs (default: 1).
epoch=${2:-1}
label=${3:-all}

echo evaluating label ${label}

for method in ${methods[@]}
do
    result_dir=${prefix}${method}

    python train_qm9.py \
        --method ${method} \
        --device ${device} \
        --out ${result_dir} \
        --epoch ${epoch} \
        --label ${label}

    python predict_qm9.py \
        --in-dir ${result_dir} \
        --method ${method} \
        --label ${label}
done

python plot.py --prefix ${prefix} --methods ${methods[@]}
