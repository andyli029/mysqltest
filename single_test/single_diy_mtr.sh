#!/bin/bash

root_dir=`pwd`

test="${root_dir}/t1"
mysql_result="${root_dir}/r_m"
ks_result="${root_dir}/r_k"
diff_result="${root_dir}/r_d"
diff_result_dir="${root_dir}/r_diff/"
diff_result_dir_again="${root_dir}/r_diff"
diff_issue="${root_dir}/r_issue"

mysql_db="lizhiang"
mysql_ip="10.0.2.9"
mysql_port="3306"
mysql_user="root"
mysql_pass="abfiqwoLs7Z"

ks_db="lizhiang"
ks_ip="127.0.0.1"
ks_port="9696"
ks_user="root"
ks_pass="abfiqwoLs7Z"

function getdir1(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
            echo $dir_or_file
        fi  
    done
}

function getdir(){
    for element in `ls $1`
    do
        echo $element
    done
}

i=0
function getmr(){
    for element in `ls $1`
    do
	i=$(($i+1))
	echo "get mysql result.............the index: $i"
	echo $element
	#192.168.56.101
	b=$(( $i % 100 ))
	if [ $b = 0 ] ; then 
		#/code/mysql-server-mysql-5.6.28/scripts/mysqld_multi --defaults-extra-file=/code/mysql-server-mysql-5.6.28/scripts/mysqld_multi.conf start
		echo "...........sleep......"
		sleep 3
	fi
	
    	mysql_cmd="mysqltest -h $mysql_ip -P $mysql_port -u $mysql_user -p$mysql_pass $mysql_db < $test/$element >/$mysql_result/$element.result 2>&1"
        #echo $mysql_cmd
        sh -c "$mysql_cmd"
        #`$mysql_cmd`
    done
}

j=0
function getkr(){
    for element in `ls $1`
    do

	j=$(($j+1))
        echo "get ks result.............the index: $j"
	echo $element

        b=$(( $j % 50 ))
        if [ $b = 0 ] ; then
                echo "...........sleep......"
                sleep 2
        fi

        ks_cmd="mysqltest -h $ks_ip -P $ks_port -u $ks_user -p$ks_pass $ks_db < $test/$element >/$ks_result/$element.result 2>&1"
        #echo $ks_cmd
        sh -c "$ks_cmd"
        #mv $test/$element $test/.ks_finished/
    done
}

function getdr(){
    echo "in diff"
    for element in `ls $ks_result`
    do
	    echo $element
        `diff $mysql_result/$element $ks_result/$element > $diff_result/$element.diff 2>&1`
    done
}

function getdiff(){
    echo "in diff"
    for element in `ls $ks_result`
    do
        echo $element
        `diff $mysql_result/$element $ks_result/$element > $diff_result_dir/$element 2>&1`
    done
}

function get_same(){
    echo "in diff same"
    for element in `ls -l $diff_result_dir | grep " 0  1  2" |awk '{print $9}'`
    do
        echo $element
        cp $diff_result_dir/$element $diff_result_dir_again 
    done
}

function get_content(){
    echo "in diff same"
    echo `ls -l $diff_result_dir_again |wc -l`
    for element in `ls -l $diff_result_dir_again |awk '{print $9}'`
    do
        echo $element
        #grep "not ok" $element
    done
    echo `ls -l $diff_result_dir_again |wc -l`
}

function get_issue(){
    echo "in diff same"
    for element in `ls $diff_result_dir`
    do
        if [[ -s $diff_result_dir/$element ]];then
            echo $element
            cp $diff_result_dir/$element $diff_issue
        fi
    done
}

function clean(){
    echo "clean"
    `rm  $mysql_result/*`
    `rm $ks_result/*`
    `rm $diff_result_dir/*`
    `rm $diff_issue/*`
}

clean
getdir $test
getmr $test
getkr $test
getdiff
get_issue
