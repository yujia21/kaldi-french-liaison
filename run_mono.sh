#!/bin/bash

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"
nj=4
njdecode=2
trial=06
step=1
pre=liaison2_ #naming in exp/ #model of liaison
post=_liaison50 #lang folder in data #percentage liaison prob

if [ $step -le 0 ]; then
	echo
	echo "# Take subset"
	echo
	utils/subset_data_dir.sh data/train 200 data/train_200 || exit 1
	utils/subset_data_dir.sh data/train 2000 data/train_2000 || exit 1
fi

if [ $step -le 1 ]; then
	echo
	echo "# Mono training"
	echo
	steps/train_mono.sh --nj $nj --cmd "$train_cmd" \
	  --config conf/mono00.config \
	  data/train_2000 data/lang$post exp/${pre}mono${trial} || exit 1
fi

if [ $step -le 2 ]; then
	echo
	echo "# Graph compilation"
	echo
	utils/mkgraph.sh --mono data/lang$post exp/${pre}mono${trial} exp/${pre}mono${trial}/graph_tgpr || exit 1
fi

if [ $step -le 3 ]; then
	echo
	echo "# Decoding"
	echo
	local/decode_liaison.sh --nj $njdecode --cmd "$decode_cmd" \
	    exp/${pre}mono${trial}/graph_tgpr data/test exp/${pre}mono${trial}/decode_test || exit 1
fi

if [ $step -le 4 ]; then
	echo
	echo "# Writing Stats"
	echo
	echo "===== Mono (Train set = 200, $post) =====" >> stats_all.txt
	grep WER exp/${pre}mono${trial}/decode_test/wer* | utils/best_wer.sh >> stats_all.txt
fi
