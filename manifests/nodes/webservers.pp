node 'web-01', 'web-02', 'web-03' {
  class { 'boundary':
    token => $api_token,
  }

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile'
  }

  class my_fw::pre {
    Firewall {
      require => undef,
    }
     # Default firewall rules
    firewall { '000 accept all icmp':
      proto  => 'icmp',
      action => 'accept',
    }
    firewall { '001 accept all to lo interface':
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept',
    }
#    firewall { '002 reject local traffic not on loopback interface':
#      iniface     => '! lo',
#      proto       => 'all',
#      destination => '127.0.0.1/8',
#      action      => 'reject',
#    }
#    firewall { '003 accept related established rules':
#      proto  => 'all',
#      state  => ['RELATED', 'ESTABLISHED'],
#      action => 'accept',
#    }
  }

  class {'apache':
  }

  class { 'apache::mod::status':
    allow_from      => ['127.0.0.1','::1'],
    extended_status => 'On',
    status_path     => '/server-status',
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  package { 'stress':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  package { 'sysstat':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

}
