DESCRIPTION
===========

Installs Meteor, an open-source platform for building top-quality, real-time web apps in a fraction of the time. Optionally, this
will install MongoDB and Meteroite - a Meteor version manager and package manager (http://oortcloud.github.com/meteorite/).

See http://meteor.com for more information.

REQUIREMENTS
============

Requires nodejs, apt, and build-essential cookbooks. This is currently only tested on Ubuntu 12.04.

**Note** If you are using Vagrant, the base vagrant images currently use chef version 10.14.2. This mean we need apt cookbook ver 1.7.0. For more info, see http://community.opscode.com/cookbooks/apt

### Platform

"Should" work on Debian 5+, Ubuntu 9.10+, OpenBSD and FreeBSD.

This is currently only tested on Ubuntu 12.04.

### Cookbooks

* apt
* build-essential
* nodejs

ATTRIBUTES
==========

* `default['meteor']['install_url']` - *STRING* The install URL for Meteor. This is the URL in the Meteor documentation to the installer shell script.
* `default['meteor']['install_mongodb']` - *BOOLEAN* Set to `true` to install mongodb.
* `default['meteor']['create_meteor_user']` - *BOOLEAN* Set to `true` to create the `meteor` user (the default password is `meteor`)
* `default['meteor']['meteor_homedir']` - *STRING* If create_meteor_user is `true`, this will be the users home directory
* `default['meteor']['meteor_uid']` - *INTEGER* The uid for the `meteor` user
* `default['meteor']['meteor_gid']` - *INTEGER* The gid for the `meteor` user

If you set `default['meteor']['create_meteor_user']` to true, you can switch to the `meteor` user like so:
`sudo su -l meteor`

RECIPES
=======

### default

Installs Meteor by using the shell script found at the install_url attribute.

### mongodb

Installs mongodb by using adding the 10gen apt repository and then using apt-get to install (currently no yum support).

