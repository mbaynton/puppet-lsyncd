# == Class: lsyncd
#
# Installs a basic lsyncd infrastructure
#
# === Parameters
#
# [*confdir*]
#   Location to store configuration files
#
# [*rundir*]
#   Where lsyncd should store its status files
#
# [*logdir*]
#   Where lsyncd should store its log files
#
class lsyncd (
  $confdir = $lsyncd::params::confdir,
  $rundir = $lsyncd::params::rundir,
  $logdir = $lsyncd::params::logdir,
) inherits lsyncd::params {

  include ::lsyncd::install
  include ::lsyncd::configure


  Class['::lsyncd::install'] ->
  Class['::lsyncd::configure'] ->
  Lsyncd::Process <||>

}
