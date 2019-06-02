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
  $source           = undef,
  $content          = undef,
  $owner            = 'root',
  $group            = 'root',
  $systemd_template = 'lsyncd/systemd_unit.epp',
) {

  include lsyncd

  if ! ($source or $content) {
    err('Must specify a configuration $source or $content')
  }

  if $source and $content {
    err('Must specify only one of $source or $content')
  }

  $cfgfile = "${lsyncd::confdir}/${name}.lua"
  file { $cfgfile:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    source  => $source,
    content => $content,
  }

  if ($facts['systemd']) {
    $process = $facts['os']['family'] ? {
      'RedHat' => '/bin/lsyncd',
      default  => '/usr/local/bin/lsyncd'
    }

    $template_hash = {
      'name'        => $name,
      'lsyncd_path' => $process,
      'user'        => $owner,
      'lua_file'    => $cfgfile,
    }
    systemd::unit_file { "lsyncd-${name}.service":
      content => epp($systemd_template, $template_hash)
    }
    ~>
    service { "lsyncd-${name}":
      ensure => 'running',
      enable => true,
    }
  } else {
    $process = "lsyncd ${cfgfile}"

    service { "lsyncd-${name}":
      ensure   => running,
      provider => 'debian',
      start    => "sudo -u ${owner} ${process}",
      status   => "pgrep -f '^${process}$'",
      stop     => "pkill --signal KILL -f '^${process}$'",
      require  => File[$cfgfile]
    }

  }
}
