#!/usr/bin/env bash

HOME=~/ClusterOn/ali
CON_HOME=$HOME/conproxy

function run_ckv {
SERVER=$1
PORT=$2
#NUM_PROC=$3
JOB_DIR=$HOME/conrun/con_jobs
JOBFILE=_runckv.job
BIN=${CON_HOME}/apps/ckv/conkv
mkdir -p ${JOB_DIR}
rm ${JOB_DIR}/$JOBFILE

echo "$SERVER: $BIN -t 1 -l ${SERVER} -p ${PORT}"
echo "LD_LIBRARY_PATH=/usr/local/lib $BIN -t 1 -l ${SERVER} -p ${PORT}" \
> ${JOB_DIR}/$JOBFILE
parallel --gnu -S $SERVER -a ${JOB_DIR}/$JOBFILE
}

function run_ckv_wrapper {
run_ckv hulk0 11111 &
sleep 0.5
run_ckv hulk0 11112 &
sleep 0.5
run_ckv hulk0 11113 &
sleep 0.5

run_ckv hulk1 11111 &
sleep 0.5
run_ckv hulk1 11112 &
sleep 0.5
run_ckv hulk1 11113 &
sleep 0.5

run_ckv hulk2 11111 &
sleep 0.5
run_ckv hulk2 11112 &
sleep 0.5
run_ckv hulk2 11113 &
sleep 0.5

run_ckv hulk3 11111 &
sleep 0.5
run_ckv hulk3 11112 &
sleep 0.5
run_ckv hulk3 11113 &
sleep 0.5

run_ckv hulk4 11111 &
sleep 0.5
run_ckv hulk4 11112 &
sleep 0.5
run_ckv hulk4 11113 &
sleep 0.5

run_ckv hulk5 11111 &
sleep 0.5
run_ckv hulk5 11112 &
sleep 0.5
run_ckv hulk5 11113 &
sleep 0.5
}

function kill_conkv {
SERVER=$1
JOB_DIR=$HOME/conrun/con_jobs
JOBFILE=_killckv.job
mkdir -p ${JOB_DIR}
rm ${JOB_DIR}/$JOBFILE
echo "pkill -9 conkv" >> ${JOB_DIR}/$JOBFILE
parallel --gnu -S $SERVER -a ${JOB_DIR}/$JOBFILE
}

function kill_ckv_wrapper {
kill_conkv hulk0
sleep 0.5
kill_conkv hulk1
sleep 0.5
kill_conkv hulk2
sleep 0.5
kill_conkv hulk3
sleep 0.5
kill_conkv hulk4
sleep 0.5
kill_conkv hulk5
sleep 0.5
}

function run_clusteron {
SERVER=$1
PORT=$2
#SHARD_PREFIX=$3
SHARD=$3
CONF=$4
#DL_PREFIX=$5
DL=$5
#NUM_PROC=$6
CONF_DIR=$HOME/conrun/conf
JOB_DIR=$HOME/conrun/con_jobs
JOBFILE=_runcon.job
BIN=${CON_HOME}/src/conproxy
mkdir -p ${CONF_DIR}
mkdir -p ${JOB_DIR}
rm ${JOB_DIR}/$JOBFILE

#SERVER_PORT=`echo "scale=0;$PORT+$id"|bc -l`
#SERVER_PORT=$(($PORT+$id))

echo "$SERVER: $BIN --config $CONF_DIR/$CONF --datalets $CONF_DIR/${DL} \
--shard ${SHARD} --proxyAddr $SERVER --proxyClientPort ${PORT}" 
echo "LD_LIBRARY_PATH=/usr/local/lib:$HOME/conproxy/src/redlock-cpp/hiredis:$HOME/conproxy/src/kafka/src:$HOME/conproxy/src/kafka/src-cpp:/usr/lib \
$BIN --config $CONF_DIR/$CONF --datalets $CONF_DIR/${DL} \
--shard ${SHARD} --proxyAddr $SERVER --proxyClientPort ${PORT}" \
>> ${JOB_DIR}/$JOBFILE
parallel --gnu -S $SERVER -a ${JOB_DIR}/$JOBFILE
}

function run_clusteron_wrapper {
# strong
run_clusteron hulk0 12345 aas1 aa-s1.json aas-d00 &
sleep 0.5
run_clusteron hulk0 12346 aas2 aa-s2.json aas-d10 &
sleep 0.5
run_clusteron hulk0 12347 aas3 aa-s3.json aas-d20 &
sleep 0.5


run_clusteron hulk1 12345 aas1 aa-s1.json aas-d01 &
sleep 0.5
run_clusteron hulk1 12346 aas2 aa-s2.json aas-d11 &
sleep 0.5
run_clusteron hulk1 12347 aas3 aa-s3.json aas-d21 &
sleep 0.5


run_clusteron hulk2 12345 aas1 aa-s1.json aas-d02 &
sleep 0.5
run_clusteron hulk2 12346 aas2 aa-s2.json aas-d12 &
sleep 0.5
run_clusteron hulk2 12347 aas3 aa-s3.json aas-d22 &
sleep 0.5


run_clusteron hulk3 12345 aas4 aa-s4.json aas-d33 &
sleep 0.5
run_clusteron hulk3 12346 aas5 aa-s5.json aas-d43 &
sleep 0.5
run_clusteron hulk3 12347 aas6 aa-s6.json aas-d53 &
sleep 0.5


run_clusteron hulk4 12345 aas4 aa-s4.json aas-d34 &
sleep 0.5
run_clusteron hulk4 12346 aas5 aa-s5.json aas-d44 &
sleep 0.5
run_clusteron hulk4 12347 aas6 aa-s6.json aas-d54 &
sleep 0.5

run_clusteron hulk5 12345 aas4 aa-s4.json aas-d35 &
sleep 0.5
run_clusteron hulk5 12346 aas5 aa-s5.json aas-d45 &
sleep 0.5
run_clusteron hulk5 12347 aas6 aa-s6.json aas-d55 &
sleep 0.5
}

function kill_clusteron {
SERVER=$1
JOB_DIR=$HOME/conrun/con_jobs
JOBFILE=_killcon.job
mkdir -p ${JOB_DIR}
rm ${JOB_DIR}/$JOBFILE
echo "pkill -9 conproxy" >> ${JOB_DIR}/$JOBFILE
parallel --gnu -S $SERVER -a ${JOB_DIR}/$JOBFILE
}

function kill_clusteron_wrapper {
kill_clusteron hulk0 &
sleep 0.5
kill_clusteron hulk1 &
sleep 0.5
kill_clusteron hulk2 &
sleep 0.5
kill_clusteron hulk3 &
sleep 0.5
kill_clusteron hulk4 &
sleep 0.5
kill_clusteron hulk5 &
sleep 0.5
}																

function gen_conf {
ZK_HOST=$1
ZK_PORT=$2
KAFKA_HOST=$3
KAFKA_PORT=$4
CONSISTENCY_MODEL=$5
CONSISTENCY_TECH=$6
TOPOLOGY=$7
NUM_REPLICAS=$8
CONF=$9
CONF_DIR=$HOME/conrun/conf
mkdir -p ${CONF_DIR}
machine=${10}

echo "
{
	\"zk_host\": \"${ZK_HOST}:${ZK_PORT}\",
	\"kafka_broker\": \"${KAFKA_HOST}:${KAFKA_PORT}\",
	\"consistency_model\": \"${CONSISTENCY_MODEL}\",
	\"consistency_tech\": \"${CONSISTENCY_TECH}\",
	\"topology\": \"${TOPOLOGY}\",
	\"num_replicas\": \"${NUM_REPLICAS}\",
	\"rl_host\": \"hulk0:12121\",
} " > ${CONF_DIR}/$CONF

echo -e "hulk0:11111:0\nhulk1:11111:1\nhulk2:11111:1" > ${CONF_DIR}/aas-d00
echo -e "hulk1:11111:0\nhulk0:11111:1\nhulk2:11111:1" > ${CONF_DIR}/aas-d01
echo -e "hulk2:11111:0\nhulk0:11111:1\nhulk1:11111:1" > ${CONF_DIR}/aas-d02

echo -e "hulk0:11112:0\nhulk1:11112:1\nhulk2:11112:1" > ${CONF_DIR}/aas-d10
echo -e "hulk1:11112:0\nhulk0:11112:1\nhulk2:11112:1" > ${CONF_DIR}/aas-d11
echo -e "hulk2:11112:0\nhulk0:11112:1\nhulk1:11112:1" > ${CONF_DIR}/aas-d12

echo -e "hulk0:11113:0\nhulk1:11113:1\nhulk2:11113:1" > ${CONF_DIR}/aas-d20
echo -e "hulk1:11113:0\nhulk0:11113:1\nhulk2:11113:1" > ${CONF_DIR}/aas-d21
echo -e "hulk2:11113:0\nhulk0:11113:1\nhulk1:11113:1" > ${CONF_DIR}/aas-d22


echo -e "hulk3:11111:0\nhulk4:11111:1\nhulk5:11111:1" > ${CONF_DIR}/aas-d33
echo -e "hulk4:11111:0\nhulk3:11111:1\nhulk5:11111:1" > ${CONF_DIR}/aas-d34
echo -e "hulk5:11111:0\nhulk3:11111:1\nhulk4:11111:1" > ${CONF_DIR}/aas-d35

echo -e "hulk3:11112:0\nhulk4:11112:1\nhulk5:11112:1" > ${CONF_DIR}/aas-d43
echo -e "hulk4:11112:0\nhulk3:11112:1\nhulk5:11112:1" > ${CONF_DIR}/aas-d44
echo -e "hulk5:11112:0\nhulk3:11112:1\nhulk4:11112:1" > ${CONF_DIR}/aas-d45

echo -e "hulk3:11113:0\nhulk4:11113:1\nhulk5:11113:1" > ${CONF_DIR}/aas-d53
echo -e "hulk4:11113:0\nhulk3:11113:1\nhulk5:11113:1" > ${CONF_DIR}/aas-d54
echo -e "hulk5:11113:0\nhulk3:11113:1\nhulk4:11113:1" > ${CONF_DIR}/aas-d55

}																										


function gen_conf_wrapper {
gen_conf 192.168.0.173 2181 192.168.0.173 9092 strong rl aa 0 aa-s.json hulk0
CONF_DIR=$HOME/conrun/

echo $HOME
scp -r $CONF_DIR hulk0:$HOME
scp -r $CONF_DIR hulk1:$HOME
scp -r $CONF_DIR hulk2:$HOME
scp -r $CONF_DIR hulk3:$HOME
scp -r $CONF_DIR hulk4:$HOME
scp -r $CONF_DIR hulk5:$HOME


#gen_conf 192.168.0.173 2181 192.168.0.173 9092 eventual cr aa 0 aa-ev.json hulk1
#CONF_DIR=$HOME/conrun/conf/
#scp -r $CONF_DIR hulk0:$HOME
#
#gen_conf 192.168.0.173 2181 192.168.0.173 9092 eventual cr aa 0 aa-ev.json hulk2
#CONF_DIR=$HOME/conrun/conf/
#scp -r $CONF_DIR hulk0:$HOME
#
#gen_conf 192.168.0.173 2181 192.168.0.173 9092 eventual cr aa 0 aa-ev.json hulk3
#CONF_DIR=$HOME/conrun/conf/
#scp -r $CONF_DIR hulk0:$HOME
#
#gen_conf 192.168.0.173 2181 192.168.0.173 9092 eventual cr aa 0 aa-ev.json hulk4
#CONF_DIR=$HOME/conrun/conf/
#scp -r $CONF_DIR hulk0:$HOME
#
#gen_conf 192.168.0.173 2181 192.168.0.173 9092 eventual cr aa 0 aa-ev.json hulk5
#CONF_DIR=$HOME/conrun/conf/
#scp -r $CONF_DIR hulk0:$HOME

}

case "$1" in
run_ckv_all)
	run_ckv_wrapper $*
	;;
kill_ckv_all)
	kill_ckv_wrapper $*
	;;
run_con_all)
	run_clusteron_wrapper $*
	;;
kill_con_all)
	kill_clusteron_wrapper $*
	;;
gen_conf_all)
	gen_conf_wrapper $*
	;;
*)
	echo "Usage: $0 (run_ckv_all|kill_ckv_all|run_con_all|kill_con_all|gen_conf_all|...)"
	;;
esac
