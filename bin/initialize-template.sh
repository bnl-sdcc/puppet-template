#!/bin/bash
echo "Cloning current catalog..."
cd /etc/puppet

git clone https://webdocs.racf.bnl.gov/git/puppet/catalog

if [ $? -eq 128 ]
then
   echo "Catalog exists already, updating..."
   cd catalog
   git pull
fi

echo "Adjusting puppet.conf..."
cp -f /etc/puppet/puppet.conf /etc/puppet/puppet.conf.backup
cp -f ~/puppet-template/etc/puppet.conf /etc/puppet/puppet.conf

echo "Creating test.pp..."  
cp -f ~/puppet-template/etc/test.pp /etc/puppet/test.pp

echo "Run puppet apply --verbose /etc/puppet/test.pp"

