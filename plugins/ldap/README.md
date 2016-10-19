README - LDAP (LDAP Plugin)
================================

LDAP is a plugin to allow ldap authentication to noosfero


INSTALL
=======

Dependences
-----------

See the Noosfero install file. After install Noosfero, install LDAP dependences:

$ gem install net-ldap -v 0.3.1
$ sudo apt-get install ruby-magic

Enable Plugin
-------------

Also, you need to enable LDAP Plugin at you Noosfero:

cd <your_noosfero_dir>
./script/noosfero-plugins enable ldap

Active Plugin
-------------

As a Noosfero administrator user, go to administrator panel:

- Click on "Enable/disable plugins" option
- Click on "LDAP Plugin" check-box


DEVELOPMENT
===========

Get the LDAP (Noosfero with LDAP Plugin) development repository:

$ git clone https://gitorious.org/+noosfero/noosfero/ldap

Running LDAP tests
--------------------

Configure the ldap server creating the file 'plugins/ldap/fixtures/ldap.yml'.
A sample file is offered in 'plugins/ldap/fixtures/ldap.yml.dist'

$ rake test:noosfero_plugins:ldap


Get Involved
============

If you found any bug and/or want to collaborate, please send an e-mail to leandronunes@gmail.com

LICENSE
=======

Copyright (c) The Author developers.

See Noosfero license.


AUTHORS
=======


CONFIGURATION
=============
Ldap plugin settings can be set in /admin/plugin/ldap
The plugin has the following fields. Fields without (*) are optional

* Host: LDAP server IP. i.e. "164.41.5.10" or "localhost"
* Port: Service port, usually "389" or "386" to configure server with SSL
- Account: Any account with access to make search queries on LDAP server, i.e."cn=admin,dc=fga,dc=unb,dc=br"
- Account Password: Account's password
- Base DN: Root directory of LDAP server, i.e. "dc=fga,dc=unb,dc=br"
- LDAP Filter: This field describes filters to be applied in search queries, i.e. ou=teachers. Multiple filters can be passed separated with spaces
- On the fly creation: When not activated, new users will not get the fullname and email from the LDAP server. Rather, these attributes will be defined on the fly.
- LDAPS: Use safe protocol. LDAP server must provide this option and port number must be set to the safe protocol port
- Override email: Always override user's email with email that came from LDAP. If LDAP does not provide an email, the default email will be "user_login@ldapuser". If false, the user's email will be kept.
- Login: it's used as an OR filter in the user search and has to be separated with spaces to create several concatenations over the user login. Example: uid=login OR cn=login.
- Fullname: Tells in which LDAP attribute the user name is. Example: cn.
- Mail: Same as name. Ex: mail.

 Leandro Nunes dos Santos (leandronunes at gmail.com)


Creating a local ldap for testing
-------------

First, you need to install the dependencies. Those are:
- slapd
- ldap-utils
On debian based systems, those can be obtained with 'sudo apt-get install'. The
next step is to configure slapd with the domain's data. This can be done with

$ dpkg-reconfigure slapd

An example can be found in:

Omit OpenLDAP server configuration: No
DNS domain name: example.com
Organization name: example
Administrator password: any password you would like
Confirm password: same as above
Database backend to use: HDB
Do you want the database to be removed when slapd is purged: No
Move old database: Yes
Allow LDAPv2 protocol: No

As from now, you can add users to your LDAP database. They will be needed later.
You can do this by creating a LDIF file with the content:

dn: cn=John Doe,dc=example,dc=com
cn: John Doe
sn: Doe
mail: johndoe@example.com
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
uid: johndoe
userPassword: pass

Next, run the command:
$ ldapadd -x -W -D "cn=admin, dc=example, dc=com" -f yourfile.ldif

If you wish to see if everything was created correctly, you can type in terminal:
$ ldapsearch -x -b dc=example,dc=com


ACKNOWLEDGMENTS
===============

The author have been supported by Serpro
