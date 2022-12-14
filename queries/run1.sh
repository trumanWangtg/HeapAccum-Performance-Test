#!/bin/bash
#add gsql script to graph first

#print result to output

echo Results:"unit in ms" |& tee  /home/tigergraph/HeapAccum-Performance-Test/output
t=3


q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl --fail -u tigergraph:tigergraph -X POST -H "GSQL-TIMEOUT: 500000" "http://localhost:14240/gsqlserver/interpreted_query?k=100000" -d 'INTERPRET QUERY (INT k) FOR GRAPH ldbc_snb {TYPEDEF TUPLE<UINT forumID> RESULT;
HeapAccum<RESULT>(k, forumID ASC) @@result;
forums = SELECT f
        FROM Forum:f
        Accum @@result+=RESULT(f.id);
PRINT @@result.size();
 }') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo interpreted_push=100000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl --fail -u tigergraph:tigergraph -X POST -H "GSQL-TIMEOUT: 500000" "http://localhost:14240/gsqlserver/interpreted_query?k=1000000" -d 'INTERPRET QUERY (INT k) FOR GRAPH ldbc_snb {TYPEDEF TUPLE<UINT forumID> RESULT;
HeapAccum<RESULT>(k, forumID ASC) @@result;
forums = SELECT f
        FROM Forum:f
        Accum @@result+=RESULT(f.id);
PRINT @@result.size();
 }') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo interpreted_push=1000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl --fail -u tigergraph:tigergraph -X POST -H "GSQL-TIMEOUT: 5000000" "http://localhost:14240/gsqlserver/interpreted_query?k=5000000" -d 'INTERPRET QUERY (INT k) FOR GRAPH ldbc_snb {TYPEDEF TUPLE<UINT forumID> RESULT;
HeapAccum<RESULT>(k, forumID ASC) @@result;
forums = SELECT f
        FROM Forum:f
        Accum @@result+=RESULT(f.id);
PRINT @@result.size();
 }') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo interpreted_push=5000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


echo UDF and Distributed mode results |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=20') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit=20 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=100000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit=100000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=1000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit=1000000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit=5000000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#Orderby+limit+offset
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=20&j=10') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit+50%offset=20 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=100000&j=50000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit+50%offset=100000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=1000000&j=500000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit+50%offset=1000000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/OrderLimit?k=5000000&j=2500000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo orderby+limit+50%offset=5000000 avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#orderby only
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET 'http://127.0.0.1:9000/query/ldbc_snb/orderOnly') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo order by only avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#pop Distributed global for various capacity limits
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_DG?k=20') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_DG=20 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_DG?k=100000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_DG=100000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_DG?k=1000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_DG=1000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_DG?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_DG=5000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#pop Distributed local accumulator 
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_DL') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_DL avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#pop distributed large tuple 
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_LTUPLE?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_LTUPLE avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#pop single global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_SG?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_SG avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#pop single local
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/pop_SL') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo pop_SL avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=20') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=20 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=100000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=100000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=1000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=1000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=5000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_DG') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_DG avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_DL') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_DL avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_LTUPLE?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_LTUPLE avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


#push single global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_SG') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_SG avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push single local
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_SL') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_SL avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#resize
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/resize') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo resize avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#top
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/top') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo top avg:  $q_time |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

echo single_GPR mode results |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output
set single_gpr = true
#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=20') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=20 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=100000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=100000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_d_global?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_d_global=5000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output


#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_s_global?k=20') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_UDF_global=20 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_s_global?k=100000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_UDF_global=100000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output

#push distributed global
q_start=$(date +%s%N | cut -b1-13)
for i in $(seq 1 $t)
do
(curl -X GET -H "GSQL-TIMEOUT: 500000" 'http://127.0.0.1:9000/query/ldbc_snb/push_s_global?k=5000000') &> /dev/null
done
q_end=$(date +%s%N | cut -b1-13)
q_time=$((($q_end-$q_start)/$t))
echo push_UDF_global=5000000 avg:  $q_time  |& tee -a /home/tigergraph/HeapAccum-Performance-Test/output
