1. manully change the vars in the single_diy_mtr.sh 
    #####################
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
    #####################

2. rm t1/ 
   cp $test .t1/ 
   ./single_diy_mtr.sh

   to run one or more test in the dir of t1

3. the diff result between mysql and kingshard in the dir of r_issue or r_diff,
   the result of the mysql in the r_m, the result of the kingshard in the r_k

4. the used functions are belows, and some function unused, you could change for your need.
    #clean
    getdir $test
    getmr $test
    getkr $test
    getdiff
    get_issue

