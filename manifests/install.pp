# == Class: lsyncd::install
#
class lsyncd::install {

  package { 'lsyncd':
    ensure => installed,
  }

}
