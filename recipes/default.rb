#
# Cookbook Name:: meteor
# Recipe:: default
#

# Install dependencies
# The base vagrant images currently use chef version 10.14.2. This mean we need apt cookbook ver 1.7.0
# For more info, see http://community.opscode.com/cookbooks/apt
include_recipe "apt"
include_recipe "build-essential"
include_recipe "nodejs"

# Install Mongodb
if node['meteor'] && node['meteor']['install_mongodb']
	include_recipe "meteor::mongodb"
end

# Install Meteor
install_script = "meteor_install.sh"
meteor_install_file = File.join(Chef::Config[:file_cache_path], "/", install_script)

remote_file meteor_install_file do
  source node['meteor']['install_url']
  mode 0755
end

bash "install Meteor" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  	/bin/sh #{install_script}
  EOH
  not_if { ::FileTest.exists?("/usr/bin/meteor") }
end

if node['meteor']['install_meteorite']
	# Git and curl are requirements for Meteorite
	package "git"
	package "curl"
	execute "Install Meteorite" do
		command "npm install -g meteorite"
		not_if { ::FileTest.exists?("/usr/bin/mrt") }
	end
end

if node['meteor']['create_meteor_user']
	if node['meteor'] && node['meteor']['meteor_uid'] > 0
		# set the vagrant gid, if needed
		if node['meteor']['meteor_gid'] == nil || node['meteor']['meteor_gid'] <= 0
			node['meteor']['meteor_gid'] = node['meteor']['meteor_uid']
		end
		# set the vagrant home dir, if needed
		if node['meteor']['meteor_homedir'] == nil
			node['meteor']['meteor_homedir'] = "/home/meteor"
		end
		# check (and resolve gid conflict)
		# <--THERE HAS TO BE A BETTER WAY TO DO THIS!-->
		bash "Check for existing uid: #{node['meteor']['meteor_gid']}" do
		  code <<-EOH
			  foundGroup=$(getent group | grep ":#{node['meteor']['meteor_gid']}:" | cut -d: -f1)
			  if [[ $foundGroup ]]; then
			  	nextFreeGid=$(getent group | awk -F: '$3>500&&$3<20000{print $3}' | sort -n | tail -1 | awk '{print $1+1}')
			  	groupmod -g $nextFreeGid $foundGroup
			  fi
		  EOH
		  not_if "grep meteor /etc/group"
		end
		# </--THERE HAS TO BE A BETTER WAY TO DO THIS!-->
		group "meteor" do
			system true
			gid node['meteor']['meteor_gid']
			not_if "grep meteor /etc/group"
		end

		# change the vagrant uid, if needed
		# check (and resolve uid conflict)
		# <--THERE HAS TO BE A BETTER WAY TO DO THIS!-->
		bash "Check for existing uid: #{node['meteor']['meteor_uid']}" do
		  code <<-EOH
			  foundUser=$(getent passwd | grep ":#{node['meteor']['meteor_uid']}:" | cut -d: -f1)
			  if [[ $foundUser ]]; then
			  	nextFreeUid=$(getent passwd | awk -F: '$3>500&&$3<20000{print $3}' | sort -n | tail -1 | awk '{print $1+1}')
			  	usermod -u $nextFreeUid $foundUser
			  fi
		  EOH
		  not_if "grep meteor /etc/passwd"
		end
		# </--THERE HAS TO BE A BETTER WAY TO DO THIS!-->
		user "meteor" do
			system true
			comment "Meteor admin"
			uid node['meteor']['meteor_uid']
			gid "meteor"
			shell "/bin/bash"
			home node['meteor']['meteor_homedir']
			password "$6$TLBMP17X$nBmG1wKB0IqLIb/TaZWGFryMVpsY2FZzPF6X7r9iRME3SsYX4daKw6BUUyzhnujk3CMEXoYgMi7ZS4OH3kK5F1"
			supports :manage_home => node['meteor']['meteor_homedir'] ? true : false
			not_if "grep meteor /etc/passwd"
		end
	end
end
