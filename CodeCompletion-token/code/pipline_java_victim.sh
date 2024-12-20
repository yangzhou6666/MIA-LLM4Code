LANG=java 

LITFILE=../dataset/javaCorpus/literals.json
OUTPUTDIR=../save/javaCorpus
# PRETRAINDIR=microsoft/CodeGPT-small-java-adaptedGPT2
# PRETRAINDIR=NinedayWang/PolyCoder-0.4B
# PRETRAINDIR=NinedayWang/PolyCoder-160M
# PRETRAINDIR=bigcode/starcoderbase-1b
# PRETRAINDIR=facebook/incoder-1B
# PRETRAINDIR=Salesforce/codegen-350M-multi
PRETRAINDIR=EleutherAI/gpt-neo-125m
# PRETRAINDIR=EleutherAI/gpt-neo-1.3B
# PRETRAINDIR=codeparrot/codeparrot
# PRETRAINDIR=codeparrot/codeparrot-small
# PRETRAINDIR=bigcode/santacoder
PER_NODE_GPU=1
MASTER_PORT=90927 #change every time
export CUDA_VISIBLE_DEVICES=2 #specify GPU, change every time


for SAMPLE_RATIO in {100..100..10}
do
LOGFILE="logs/${PRETRAINDIR##*/}_${SAMPLE_RATIO}".log
DATADIR=../dataset/javaCorpus/token_completion/
echo $LOGFILE
python -u run_lm.py \
        --data_dir=$DATADIR \
        --lit_file=$LITFILE \
        --langs=$LANG \
        --output_dir=$OUTPUTDIR \
        --pretrain_dir=$PRETRAINDIR \
        --log_file=$LOGFILE \
        --model_type=codegen \
        --block_size=1024 \
        --do_train \
        --gpu_per_node $PER_NODE_GPU \
        --learning_rate=8e-5 \
        --weight_decay=0.01 \
        --per_gpu_train_batch_size=2 \
        --per_gpu_eval_batch_size=2 \
        --gradient_accumulation_steps=8 \
        --num_train_epochs=5 \
        --logging_steps=100 \
        --save_steps=100 \
        --seed=42 \
        --overwrite_output_dir \
        --not_pretrain \
        --sample_ratio $SAMPLE_RATIO \
        --save_sample \
        --MASTER_PORT $MASTER_PORT
done