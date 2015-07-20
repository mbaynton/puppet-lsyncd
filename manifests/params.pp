# == Class: lsyncd::params
#
class lsyncd::params {

  case $::osfamily {
    'Debian': {
      $confdir = '/etc/lsyncd'
      $rundir = '/var/run/lsyncd'
      $logdir = '/var/log/lsyncd'
    }
  }

}
