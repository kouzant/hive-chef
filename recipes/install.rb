include_recipe "java"
include_recipe "hops::wrap"

my_ip = my_private_ip()

group node.hive2.group do
  action :create
  not_if "getent group #{node.hive2.group}"
end

user node.hive2.user do
  home "/home/#{node.hive2.user}"
  action :create
  shell "/bin/bash"
  manage_home true
  not_if "getent passwd #{node.hive2.user}"
end

group node.hive2.group do
  action :modify
  members ["#{node.hive2.user}"]
  append true
end

# Install packages
apt_package 'git'
apt_package 'maven'
apt_package 'vim'

package_url = "#{node.hive2.url}"
base_package_filename = File.basename(package_url)
cached_package_filename = "/tmp/#{base_package_filename}"

remote_file cached_package_filename do
  source package_url
  owner "#{node.hive2.user}"
  mode "0644"
  action :create_if_missing
end

# Extract Hive
hive_downloaded = "#{node.hive2.home}/.hive_extracted_#{node.hive2.version}"

bash 'extract-hive' do
        user "root"
        group node.hive2.group
        code <<-EOH
                set -e
                tar zxf #{cached_package_filename} -C /tmp
                mv /tmp/apache-hive-#{node.hive2.version}-bin #{node.hive2.dir}
                # remove old symbolic link, if any
                rm -f #{node.hive2.base_dir}
                ln -s #{node.hive2.home} #{node.hive2.base_dir}
                chown -R #{node.hive2.user}:#{node.hive2.group} #{node.hive2.home}
                chown -R #{node.hive2.user}:#{node.hive2.group} #{node.hive2.base_dir}
                touch #{hive_downloaded}
                chown -R #{node.hive2.user}:#{node.hive2.group} #{hive_downloaded}
        EOH
     not_if { ::File.exists?( "#{hive_downloaded}" ) }
end




group node.tez.group do
  action :create
  not_if "getent group #{node.tez.group}"
end

user node.tez.user do
  home "/home/#{node.tez.user}"
  action :create
  shell "/bin/bash"
  manage_home true
  not_if "getent passwd #{node.tez.user}"
end

group node.tez.group do
  action :modify
  members ["#{node.tez.user}"]
  append true
end



package_url = "#{node.tez.url}"
base_package_filename = File.basename(package_url)
cached_package_filename = "/tmp/#{base_package_filename}"

remote_file cached_package_filename do
  source package_url
  owner "#{node.tez.user}"
  mode "0644"
  action :create_if_missing
end

# Extract Hive
tez_downloaded = "#{node.tez.home}/.tez_extracted_#{node.tez.version}"

bash 'extract-tez' do
        user "root"
        group node.tez.group
        code <<-EOH
                set -e
                tar zxf #{cached_package_filename} -C /tmp
                mv /tmp/apache-tez-#{node.tez.version}-bin #{node.tez.dir}
                # remove old symbolic link, if any
                rm -f #{node.tez.base_dir}
                ln -s #{node.tez.home} #{node.tez.base_dir}
                chown -R #{node.tez.user}:#{node.tez.group} #{node.tez.home}
                chown -R #{node.tez.user}:#{node.tez.group} #{node.tez.base_dir}
                touch #{tez_downloaded}
                chown -R #{node.tez.user}:#{node.tez.group} #{tez_downloaded}
        EOH
     not_if { ::File.exists?( "#{tez_downloaded}" ) }
end

# Download and compile hive-testbench
git '/home/glassfish/hive-testbench' do
   repository 'https://github.com/SirOibaf/hive-testbench.git'
   revision 'hive14'
   action :sync
   user 'glassfish'
   group 'glassfish'
end

bash 'compile hive-testbench' do
    user 'glassfish'
    group 'glassfish'
    code <<-EOH
        cd /home/glassfish/hive-testbench
        ./tpcds-build.sh
    EOH
end
