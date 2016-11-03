#Usage
#Step 1: Get easypack_kubernetes.sh
>git clone or download or copy-paste to create local easypack_kubernetes.sh
git clone https://github.com/liumiaocn/easypack

#Step 2: Create Master
>cd easypack/k8s
sh easypack_kubernetes.sh MASTER

#Step 3: Join Node
>git clone https://github.com/liumiaocn/easypack
>cd easypack/k8s
>sh easypack_kubernetes.sh NODE token MASTERIP

---
#使用方法
#Step 1: 取得easypack_kubernetes.sh
>使用git clone或者直接下载或者拷贝粘贴生成本地的easypack_kubernetes.sh文件
git clone https://github.com/liumiaocn/easypack

#Step 2: 
>需要记住Master创建时候所生成的Token，后面Node在Join的时候需要用到
>cd easypack/k8s
sh easypack_kubernetes.sh MASTER

#Step 3: Join Node
>在node所在节点执行，需要知道Master创建时候所生成的Token和Master的IP地址
>git clone https://github.com/liumiaocn/easypack
>cd easypack/k8s
>sh easypack_kubernetes.sh NODE token MASTERIP


#问题详细查询
>（LOG文件）：/tmp/k8s_install.$$.log
