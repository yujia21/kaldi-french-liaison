#!/bin/bash

. ./path.sh

local/prepare_lang_liaison.sh --sil-prob 0.7\
  data/local/dict_norep "!SIL" data/local/lang_liaison.7 data/lang_liaison.7

#fstdeterminizestar data/lang_liaison3/L_disambig.fst /dev/null
#fstisstochastic data/lang_liaison/L_disambig.fst
#fstisstochastic exp/liaison_mono00/graph_tgpr/HCLG.fst
