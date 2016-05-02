# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

file { 'bash_profile':
  path    => '/home/vagrant/.bash_profile',
  ensure  => file,
  content => file('bash/bash_profile'),
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
