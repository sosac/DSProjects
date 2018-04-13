#!/bin/bash  

### connie sosa: ds730 : spring 2016 semester

### inst_hadoop.sh : hadoop installation script


## This script was tested on ubuntu linux

### step 1-41
### aws ec2 linux vm 

uname -v | grep -i ubuntu
if [ $? -ne 0 ]
then
    echo "not ubuntu system"
    echo "this install script uses apt package tools to install packages."
    exit
fi

### check user privilege
whoami | groups | grep sudo
if [ $? -ne 0 ] 
then
    echo "sorry, user `whoami` has no sudo privilege, goodbye."
    exit
fi

### turn off interactive
export DEBIAN_FRONTEND=noninteractive  

### step 43
### update package index
sudo apt-get update 

### step 44
java -version ### check if java is already installed 
if [ $? -ne 0 ]
then
    echo "installing java ..."
    sudo apt-get install default-jdk -y
fi
echo "java version: "
java -version

### step 46-49
### create hadoop group hduser prior to running this install script

### step 50-51 ssh installed
echo "ssh version installed."
ssh -V
echo ""

### step 52
### allow hduser to be a superuser and do all sorts of fun stuff
echo "adding hduser to sudo"
sudo adduser hduser sudo
su - hduser

### switch to hduser and invoke login shell
su - hduser


### step 55-56
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
### specify the name of key file and provide a empty new pass phrase
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

### step 57
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  
### change mod to user rw only
chmod 0600 ~/.ssh/authorized_keys

### step 58-60  
### ssh localhost
ssh-add  

hadoop version
if [ $? -eq 0 ]
then
    echo "--->>> hadoop is already installed. goodbye."
    exit
fi

### step 61
### download and install hadoop version 2.7.1 latest stable release as of April 
2016
cd /tmp
sudo wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-2.7.1/hadoop-2.7.
1.tar.gz  

### step 62
### extract from tape archive
tar xvzf hadoop-2.7.1.tar.gz  

### step 63
cd /usr/local  
sudo mv /tmp/hadoop-2.7.1 hadoop  

### step 64
### change ownership of /usr/local/hadoop to user: hduser and group: hadoop
sudo chown -R hduser:hadoop /usr/local/hadoop

### step 65-66
update-alternatives --config java

### step 67-71
echo "add java and hadoop related environment variabls to .bashrc file"  
cat >> ~/.bashrc << HEREDOC
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export HADOOP_INSTALL=/usr/local/hadoop  
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native  
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
export PATH=$PATH:/usr/local/hadoop/sbin:/usr/local/hadoop/bin:$JAVA_PATH/bin  
export HADOOP_HOME=/usr/local/hadoop  
HEREDOC

### step 72
source ~/.bashrc  

### step 73-75
### make a backup copy of hadoop-env.sh 
### set JAVA_HOME environment variable
cp /usr/local/hadoop/etc/hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoo
p-env.sh.bak  
cat >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh << HEREDOC
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64  
HEREDOC

### step 76
### cannot create /app/hadoop/tmp, put tmp under /home/hadoop
sudo mkdir -p /home/hadoop/tmp
sudo chown hduser:hadoop /home/hadoop/tmp

### step 77
cd /usr/local/hadoop/etc/hadoop  
### make a backup copy of core-site.xml
cp core-site.xml core-site.xml.bak 
ech "modifying core-site.xml file ... "
cat >> core-site.xml << HEREDOC
<configuration>  
 <property>
    <name>hadoop.tmp.dir</name>
    <value>/home/hadoop/tmp</value>
    <description>A base for other temporary directories.</description>
  </property>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:54310</value>
    <description>The name of the default file system. A URI whose scheme and 
    authority determine the FileSystem implementation. The uri's scheme 
    determines the config property (fs.SCHEME.impl) naming the FileSystem 
    implementation class.  The uri's authority is used to determine the host, 
    port, etc. for a filesystem.
    </description>
  </property>
</configuration>  
HEREDOC

### step 78-79
### keep a copy of the original template
cp mapred-site.xml.template mapred-site.xml  
ech "modifying mapred-site.xml file ... "
cat >> mapred-site.xml << HEREDOC
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>localhost:54311</value>
    <description>The host and port that the MapReduce job tracker runs at.
    </description>
  </property>
</configuration>
HEREDOC

### step 80
### single node cluster, pseudo distributed mode
echo "creating directoreis for namenode and datanode ... "
sudo mkdir -p /usr/local/hadoop_store/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_store/hdfs/datanode
sudo chown -R hduser:hadoop /usr/local/hadoop_store

### step 81
### configure single node hadoop cluster
cp hdfs-site.xml hdfs-site.xml.bak
echo "modifying hdfs-site.xml file ... "
cat >> hdfs-site.xml << HEREDOC
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
    <description>Default block replication.
    The actual number of replications can be specified when the file is created.
    The default is used if replication is not specified in create time.
    </description>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/usr/local/hadoop_store/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/usr/local/hadoop_store/hdfs/datanode</value>
  </property>
</configuration>
HEREDOC

### step 82
echo "format file system hadoop name node"
echo "start formatting in 5 seconds ..."
sleep 5
hdfs namenode -format  

### step 83
echo "Hadoop configured. starting hadoop ... "
start-all.sh  

### step 85
### java virtual machine process status
jps

### step 86
echo "To stop hadoop use following scripts."  
echo "stop-all.sh"  

echo "hadoop installation done."
exit
### end
