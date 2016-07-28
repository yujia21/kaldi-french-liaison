targetfile=$1
#testfile=$2
. ./path.sh

head -n -2 <$targetfile > tmp2
sed '1,6d' <tmp2 > tmp1
sed "s/ [<]UNK[>]//g" <tmp1 > tmp
sed '/LOG/d' <tmp > ${targetfile}.clean
rm -f tmp
rm -f tmp1
rm -f tmp2

local/remove_rep.sh ${targetfile}.clean ${targetfile}.clean.norep.txt

#compute-wer --text --mode=present ark:$testfile ark:${targetfile}.clean.norep.txt > ${targetfile}.cleannorep.wer.txt
