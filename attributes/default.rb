include_attribute "kagent"
include_attribute "ndb"
include_attribute "apache_hadoop"
include_attribute "kzookeeper"

default.hive2.user                    = "hive"
default.hive2.group                   = node.apache_hadoop.group
default.hive2.version                 = "2.2.0-SNAPSHOT"
default.hive2.url                     = "alfred.sics.se:8000/apache-hive-#{node.hive2.version}-bin.tar.gz"
default.hive2.port                    = "2222"
default.hive2.dir                     = "/srv"
default.hive2.home                    =  node.hive2.dir + "/apache-hive-" + node.hive2.version + "-bin"
default.hive2.base_dir                =  node.hive2.dir + "/apache-hive"
default.hive2.keystore                = "#{node.kagent.base_dir}/node_server_keystore.jks"
default.hive2.keystore_password       = "changeit"

default.hive2.mysql_user              = "hive"
default.hive2.mysql_password          = "hive"

default.hive2.server2.pid_file        = "/tmp/hiveserver2.pid"
default.hive2.metastore.pid_file      = "/tmp/hivemetastore.pid"
default.hive2.metastore.log           = "#{node.hive2.base_dir}/hive-metastore.log"
default.hive2.metastore.port         = "9083"
default.hive2.server2.log              = "#{node.hive2.base_dir}/hive-server2.log"
default.hive2.systemd                 = "true"


default.tez.user                    = "tez"
default.tez.group                   = node.apache_hadoop.group
default.tez.version                 = "0.8.4"
default.tez.url                     = "#{node.download_url}/apache-tez-#{node.tez.version}-bin.tar.gz"
default.tez.dir                     = "/srv"
default.tez.home                    =  node.tez.dir + "/apache-tez-" + node.tez.version + "-bin"
default.tez.base_dir                =  node.tez.dir + "/apache-tez"


default.hive2.metastore.public_ips                   = ['']
default.hive2.metastore.private_ips                  = ['']
default.hive2.server2.public_ips                     = ['']
default.hive2.server2.private_ips                    = ['']
