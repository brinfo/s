#!/bin/bash

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "$(date) BEG"
/home/admin/bin/asrfromweb.sh
if [ $? -eq 0 ]; then
	echo "SKIP ASR TRAIN..."
	exit
fi
cd /home/admin/ASR/Rokid/prelm/bin
time ./doall.1103.sh
echo "$(date) STEP 1"

cd /home/admin/ASR/Rokid/wfstPart
time ./makesubfst.1103.sh
time ./run_lm_example_4bo_1103_opt.sh
echo "$(date) STEP 2"

cp /home/admin/ASR/Rokid/wfstPart/wfst_tmp/lm_example_4bo_1103_opt_tmp/myclg_m_lm_example_4bo_1103_opt_sort.dat /home/admin/SRServer/SRServerCn/models/model_haixin/myclg_m_lm_example_4bo_1103_opt_sort.dat
echo "$(date) STEP 3"

/home/admin/bin/asrrestart.sh
echo "$(date) END"

