#
# Cookbook Name:: meteor
# Recipe:: mongodb
#

# In order for apt_repository to work with Chef < 10.16.4, you need the apt cookbook 1.7.0
# ** We can probably get around this limitation by manually adding the repo with bash or execute...

# Add the 10gen MongoDB repository to APT
apt_repository "mongodb-10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
  cache_rebuild true
end

# Install mongodb
package "mongodb-10gen"

