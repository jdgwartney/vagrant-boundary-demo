# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

#resources { 'firewall':
#  purge => true,
#}

#class my_fw::pre {
#    Firewall {
#      require => undef,
#    }
#     # Default firewall rules
#    firewall { '000 accept all icmp':
#      proto  => 'icmp',
#      action => 'accept',
#    }
#    firewall { '001 accept all to lo interface':
#      proto   => 'all',
#      iniface => 'lo',
#      action  => 'accept',
#    }
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
#  }

#class my_fw::post {
#  firewall { '999 drop all':
#    proto  => 'all',
#    action => 'drop',
#    before => undef,
#  }
#}


#Firewall {
#  before  => Class['my_fw::post'],
#  require => Class['my_fw::pre'],
#}

#class { ['my_fw::pre', 'my_fw::post']: }
#
#
#
#exec { 'update-packages':
#    command => '/usr/bin/yum update -y',
#    timeout => 0,
#}

file { 'bash_profile':
  path    => '/home/vagrant/.bash_profile',
  ensure  => file,
  source  => '/vagrant/manifests/bash_profile'
}

class { 'boundary':
    token => $api_token
}

node /^web/ {

  service { "iptables":
    ensure => "stopped",
  }
  service { "ip6tables":
    ensure => "stopped",
  }

#  class { 'firewall': }

  class {'apache':
  }

  class { 'apache::mod::status':
    allow_from      => ['127.0.0.1','::1'],
    extended_status => 'On',
    status_path     => '/server-status',
  }

  $webhost = $::hostname

  file { '/var/www/html/index.html':
    content => template('web/index.html.erb'),
    mode => '0444',
    require => Class['apache']
  }

#  exec { 'update-rpm-packages':
#    command => '/usr/bin/yum update -y',
#  }

  package {'epel-release':
    ensure => 'installed',
#    require => Exec['update-rpm-packages']
  }

  package { 'stress':
    ensure => 'installed',
    require => Package['epel-release']
  }

  package { 'sysstat':
    ensure => 'installed',
    require => Package['epel-release']
  }

}

node /^dbm/, /^dbs/ {

  package {'epel-release':
    ensure => 'installed',
  }

  class { '::mysql::server':
    root_password => 'root123',
  }

  class { '::mysql::server::monitor':
    mysql_monitor_username => 'monitor',
    mysql_monitor_password => 'monitor123',
    mysql_monitor_hostname => '127.0.0.1',
  }

  package { 'stress':
    ensure => 'installed',
    require => Package['epel-release']
  }

  package { 'sysstat':
    ensure => 'installed',
    require => Package['epel-release']
  }

}

node /^ns/ {

  package {'epel-release':
    ensure => 'installed',
  }

  package { 'stress':
    ensure => 'installed',
    require => Package['epel-release']
  }

  package { 'sysstat':
    ensure => 'installed',
    require => Package['epel-release']
  }

  include bind
  bind::server::conf { '/etc/named.conf':
    listen_on_addr    => [ 'any' ],
    listen_on_v6_addr => [ 'any' ],
    forwarders        => [ '8.8.8.8', '8.8.4.4' ],
    allow_query       => [ 'localnets' ],
  }

}

node /^mon/ {

  package {'nmap':
    ensure => 'installed'
  }

  host { 'web-1':
     comment => 'Web Server #1',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.11',
     ensure => 'present'
  }
  host { 'web-2':
     comment => 'Web Server #2',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.12',
     ensure => 'present'
  }
  host { 'web-3':
     comment => 'Web Server #3',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.13',
     ensure => 'present'
  }
  host { 'dbm-1':
     comment => 'Database Server #1',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.31',
     ensure => 'present'
  }
  host { 'dbm-2':
     comment => 'Database Server #2',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.32',
     ensure => 'present'
  }
  host { 'dbs-1':
     comment => 'Database Server #1',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.31',
     ensure => 'present'
  }
  host { 'dbs-2':
     comment => 'Database Server #2',
     target => '/etc/hosts',
     host_aliases => [],
     ip => '192.168.50.32',
     ensure => 'present'
  }
}
