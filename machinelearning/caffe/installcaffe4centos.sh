#!/bin/sh

date
echo "## Step 1: install yum deps."
yum install -y  epel-release
yum install -y  protobuf-devel leveldb-devel snappy-devel opencv-devel boost-devel hdf5-devel
yum install -y  gflags-devel glog-devel lmdb-devel
yum install -y  gcc gcc-c++ python-pip 

echo "## Step 2: install python deps."
pip install scikit-image
pip install numpy

echo "## Step 3: git clone & config."
mkdir -p /usr/local/share
cd /usr/local/share
git clone https://github.com/BVLC/caffe.git
cd caffe/python
for req in $(cat requirements.txt); do pip install $req; done
cd ..
cp Makefile.config.example Makefile.config
sed -i s@"# CPU_ONLY"@" CPU_ONLY"@g Makefile.config
sed -i s@"# BLAS_INCLUDE := /path/to/your/blas"@"BLAS_INCLUDE := /usr/include/atlas"@g Makefile.config
sed -i s@"# BLAS_LIB := /path/to/your/blas"@"BLAS_LIB := /usr/lib64/atlas"@g Makefile.config
sed -i s@/usr/lib/python2.7/dist-packages/numpy/core/include@/usr/lib64/python2.7/site-packages/numpy/core/include@g Makefile.config
diff Makefile.config.example Makefile.config
cp Makefile Makefile.org
sed -i s@"LIBRARIES += cblas atlas"@"LIBRARIES += satlas tatlas"@g Makefile
diff Makefile Makefile.org

CURDIR=`pwd`
echo "export PYTHONPATH=${CURDIR}/python:\${PYTHONPATH}" >>/etc/profile
echo
echo "## Step 4: compile & runtest"
make clean
make all
make test
make runtest
make pycaffe
echo

echo "## Step 5: confirm the result"
export PYTHONPATH=`pwd`/python:${PYTHONPATH}
python -c "import caffe; exit()"
date
