#!/bin/bash
scriptbin="$(cd "$(dirname "$0")"; pwd)/$(basename "$0")"
dn=`dirname $scriptbin`
srcdir=`dirname $dn` 
devdir=/root/src/puppet/myclass

echo "Cloning current catalog..."
cd /etc/puppet
git clone https://webdocs.racf.bnl.gov/git/puppet/catalog

if [ $? -eq 128 ]
then
   echo "Catalog exists already, updating..."
   cd catalog
   git pull
fi

echo "Setting up dev dir..."
mkdir -p $devdir
cp -vrn $srcdir/manifests $devdir/
cp -vrn $srcdir/files $devdir/
cp -vrn $srcdir/templates $devdir/
cp -vrn $srcdir/lib $devdir/

echo "Adjusting puppet.conf..."
if [ ! -f /etc/puppet/puppet.conf.backup ] ; then
    cp -f /etc/puppet/puppet.conf /etc/puppet/puppet.conf.backup
fi
cp -f $srcdir/etc/puppet.conf /etc/puppet/puppet.conf

echo "Setting up hiera and local.yaml..."
cp -f $srcdir/etc/hiera.yaml  /etc/puppet/hiera.yaml
if [ ! -f /etc/puppet/defaults.yaml ] ; then
    cp -f $srcdir/etc/defaults.yaml /etc/puppet/
fi

echo "Creating test.pp..."  
cp -f $srcdir/etc/test.pp /etc/puppet/test.pp






echo "Run puppet apply --verbose /etc/puppet/test.pp"

