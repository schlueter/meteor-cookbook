#
# Cookbook Name:: meteor
# Attributes:: meteor
#

default['meteor']['install_url'] = 'https://install.meteor.com'
default['meteor']['install_meteorite'] = true # http://oortcloud.github.com/meteorite/
default['meteor']['install_mongodb'] = true

# The following is useful if you are using Vagrant (http://vagrantup.com) and want the uid and gid to match 
# your local user uid/gid. Since Meteor does not run correctly on the normal Vagrant file sharing. NFS needs  
# to be enabled (see below). If you are sharing files and need access to modify or execute files in the shared
# area (/vagrant), you will either need to sudo to root OR change the vagrant uid and gid to match those of your  
# current user. By default, the /vagrant shared directory is owned by your local user (the one that is 
# running 'vagrant up'). So when you try to create or execute files in /vagrant, you will not have the 
# correct permissions. For example, on my Mac, my username is davidk and my uid is 501 and my gid is 20. 
# When I run 'vagrant up' and login to my vagrant VM, the owner/group of /vagrant is 501/20 respectively.
# Therefore, by changing the vagrant (default user in Vagrant VMs) uid/gid, we are essentially making 
# the vagrant user the owner of the /vagrant directory, thus giving you full permissions.
# You can get your current local uid/gid like this:
#    On a Mac
# 		dscl . -read /Users/<your username> | grep UniqueID         # <-- this will display your uid
# 		dscl . -read /Users/<your username> | grep PrimaryGroupID   # <-- this will display your gid
#
#    On Linux
# 		id -u   # <-- this will display your uid 
# 		id -g   # <-- this will display your gid 
#
# If you set create_meteor_user to true, then you can su to 'meteor' to have full access to the meteor files
#
# To enable NFS and share a 'projects' folder in your Vagrantfile:
# config.vm.share_folder("v-root", "/vagrant", "projects", :nfs => true, :create => true)
#

default['meteor']['create_meteor_user'] = true
default['meteor']['meteor_homedir'] = "/home/meteor" # set to "/vagrant" if you're using Vagrant; set to nil to skip creating home dir
default['meteor']['meteor_uid'] = 1111 # set to nil to leave the uid alone, set to a number to set the uid
default['meteor']['meteor_gid'] = 1111 # set to nil to leave the gid alone, set to a number to set the gid
