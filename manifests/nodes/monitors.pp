node 'monitor-01' {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile'
  }

  class { 'boundary':
      token => $boundary_api_token,
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  host { 'web-01':
      comment => 'Test SNMP server #1',
       target => '/etc/hosts',
 host_aliases => [],
           ip => '192.168.50.11',
       ensure => 'present'
  }

}
