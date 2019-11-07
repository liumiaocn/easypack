#!/bin/sh

echo "## No.1 : create a directory"
mkdir -p num1_file_dir

echo "## No.2 : create a soft link"
rm num2_file_link file_common >/dev/null 2>&1
touch file_common
ln -s file_common num2_file_link

echo "## No.3 : create a socket file"
rm num3_file_socket >/dev/null 2>&1
python -c "import socket as socket; sock = socket.socket(socket.AF_UNIX); sock.bind('num3_file_socket')"

echo "## No.4 : create a pipe file"
rm num4_file_pipe >/dev/null 2>&1
mkfifo num4_file_pipe

echo "## No.5 : create a file executable"
touch num5_file_executable
chmod 755 num5_file_executable

echo "## No.6 : create a block file"
rm num6_file_block >/dev/null 2>&1
mknod num6_file_block b 64 0x010000

echo "## No.7 : create a charact file"
rm num7_file_charact >/dev/null 2>&1
mknod num7_file_charact c 64 0x011000

echo "## No.8 : create a file with suid"
touch num8_file_suid
chmod 4777 num8_file_suid

echo "## No.9 : create a file with guid"
touch num9_file_guid
chmod 2777 num9_file_guid

echo "## No.10 : create dir with sbit"
mkdir -p num10_file_dir_sbit
chmod 777 num10_file_dir_sbit
chmod +t num10_file_dir_sbit

echo "## No.11 : create dir without sbit"
mkdir -p num11_file_dir_no_sbit
chmod 777 num11_file_dir_no_sbit
