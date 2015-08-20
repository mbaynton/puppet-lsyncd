# == Class: lsyncd::configure
#
class lsyncd::configure {

  File {
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { $lsyncd::confdir:
    mode => '0755',
  }

  file { $lsyncd::rundir:
    mode => '0777',
  }

  file { $lsyncd::logdir:
    mode => '0777',
  }

}
