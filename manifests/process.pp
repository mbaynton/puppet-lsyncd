# == Class: lsyncd::process
#
# Manage a lsyncd process
#
# === Parameters
#
# [*name*]
#   Symbolic name of the process
#
# [*source*]
#   Lsyncd compatible configuration file source
#
# [*content*]
#   Lsyncd compatible configuration file content
#
# [*owner*]
#   Owner of the config file and the process, requires sudo
#
# [*group*]
#   Group of the config file
#
define lsyncd::process (
  $source  = undef,
  $content = undef,
  $owner   = 'root',
  $group   = 'root',
) {

  include lsyncd

  if ! ($source or $content) {
    err('Must specify a configuration $source or $content')
  }

  if $source and $content {
    err('Must specify only one of $source or $content')
  }

  $cfgfile = "${lsyncd::confdir}/${name}.lua"
  $process = "lsyncd ${cfgfile}"

  file { $cfgfile:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    source  => $source,
    content => $content,
  } ~>

  service { "lsyncd-${name}":
    ensure   => running,
    provider => 'init',
    start    => "sudo -u ${owner} ${process}",
    status   => "pgrep -f '^${process}$'",
    stop     => "pkill --signal KILL -f '^${process}$'",
  }

}
