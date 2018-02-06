# == Class: myclass
# Full description of class here.
#
# === Parameters
# Document parameters here.
# [*is_boolean*]
# A boolean argument
# [*str_something*]
# A string argument
# [*n_something*]
# An integer argument
# [*hostname*]
# An argument with a Facter fact value set at runtime.
#
# === Authors
#
# Author Name <author@bnl.gov>
#


# Class definition with example argument/parameter types. 
# Rename or comment out as needed....
#
class myclass ( $is_something = false,
                $str_something = 'default',
                $n_something = 10,
                $path_something = '/path/to/something',
                $hostname = $::fqdn
                ) {
                   
      # Facter fact  operatingsystemmajrelease => 7
      # renaming for clarity
      $major_release = $::operatingsystemmajrelease

      # You can use notify anywhere to log activity. Any block can be made conditional. 
      if $is_something {
        notify { 'A useful log message for myclass...': withpath => true } 
      }
                 
      # If packages are in an external repo, define it. Otherwise comment. 
      yumrepo { 'repo-name':
                descr    => "Some RPM Repository for Redhat Enterprise Linux ${major_release}",
                baseurl  => "http://research.cs.wisc.edu/htcondor/yum/stable/rhel${major_release}",
                enabled  => 1,
                gpgcheck => 0,
                exclude  => 'mypackage.i386, mypackage.i686',
                before => [Package['mypackage']],
            }         
            
    # Install a particular RPM package.       
    package {'mypackage':
        ensure => installed,
    }
    
    # Create a directory, potentially a tree...
    file { ['/etc/mypackage', '/etc/mypackage/config.d']:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        recurse => true,
    }         
    
    # Place a un-interpolated file from /files directory
    file {'/path/on/target/myfile.txt':
        ensure => file,
        owner => 'root',
        # file permission default is ugo+r
        
        # executable
        # mode  => '0555',
        
        # root-only
        # mode => '0600', 
        source => "puppet:///modules/myclass/myfile.txt"
    }           
    
    # Interpolate and place a file from /templates directory
    file {'/etc/mypackage/config.d/myprogram.conf':
        ensure  => file,
        owner   => 'root',
        # mode => '0600',
        content => epp('myclass/myprogram.conf.epp'),
        notify  => Service["myservice"],  
    }
    
    # Create service user, e.g. if the RPM doesn't. 
    user {["myservice" ] :
       ensure     => "present",
       managehome => true,
    } 

    # Start service provided by mypackage automatically. 
    service {'myservice':
            ensure    => running,
            enable    => true,
    }   
    
}