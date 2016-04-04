# == Class: kibana4
#
# Package Installation Method
#
class kibana4::install::package {

  if $kibana4::package_use_official_repo {

    case $::osfamily {

      'RedHat': {
        yumrepo { "kibana-${kibana4::package_repo_version}":
        baseurl  => "http://packages.elastic.co/kibana/${kibana4::package_repo_version}/centos",
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
        descr    => "Kibana repository for ${kibana4::package_repo_version}.x packages",
        before   => Package['kibana4'],
        }
      }

      'Debian': {
        if !defined(Class['apt']) {
          class { 'apt': }
        }
        apt::source { "kibana-${kibana4::package_repo_version}":
          location => "http://packages.elastic.co/kibana/${kibana4::package_repo_version}/debian",
          release  => 'stable',
          repos    => 'main',
          key      => {
            'source' => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
            'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
          },
          include  => {
            'src' => false,
          },
          before   => Package['kibana4'],
        }
      }

      'Suse' : {
        zypprepo { "kibana-${kibana4::package_repo_version}":
          baseurl     => "http://packages.elastic.co/kibana/${kibana4::package_repo_version}/centos",
          enabled     => '1',
          gpgcheck    => '1',
          autorefresh => '1',
          gpgkey      => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
          descr       => "Kibana repository for ${kibana4::package_repo_version}.x packages",
          before      => Package['kibana4'],
          name        => 'kibana4',
          type        => 'yum',
        }
      }

      default: {
        fail("${::osfamily} not supported")
      }

    }

  }

  package { 'kibana4':
    ensure => $kibana4::version,
    name   => $kibana4::package_name,
  }

}
