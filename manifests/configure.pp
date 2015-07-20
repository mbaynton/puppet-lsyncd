# == Class: lsyncd::configure
#
class lsyncd::configure {

  File {
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $lsyncd::confdir: }
  file { $lsyncd::rundir: }
  file { $lsyncd::logdir: }

}
