# == Class: neo4j::config
#
# Config Neo4J (http://www.neo4j.com) on RHEL/Ubuntu/Debian from their
# distribution tarballs downloaded directly from their site.
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
#
# === Copyright
#
# Copyright 2016 Marc Lambrichs, unless otherwise noted.
#
class neo4j::config (
  $config_dir = $neo4j::config_dir
)
{

  File {
    ensure  => file,
    mode    => '0644',
    before  => Service['neo4j'],
    notify  => Service['neo4j'],
  }

  $config_file = "${config_dir}/neo4j.conf"

  concat { $config_file :
    owner  => $neo4j::user,
    group  => $neo4j::group,
    mode   => '0644',
    before => Service['neo4j'],
    notify => Service['neo4j'],
  }


  ### neo4j.conf - general
  concat::fragment{ 'neo4j config general':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.general.erb'),
    order   => 01,
  }

  ### neo4j.conf - network
  concat::fragment{ 'neo4j network connector config':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.network.connector.erb'),
    order   => 02,
  }

  ### neo4j.conf - logging
  concat::fragment{ 'neo4j logging config':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.logging.erb'),
    order   => 03,
  }

  ### neo4j.conf - HA
  concat::fragment{ 'neo4j HA config':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.ha.erb'),
    order   => 04,
  }

  ### neo4j.conf - miscellaneous
  concat::fragment{ 'neo4j miscellaneous config':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.misc.erb'),
    order   => 05,
  }

  ### neo4j.conf - VM
  concat::fragment{ 'neo4j VM config':
    target  => $config_file,
    content => template('neo4j/neo4j.conf.vm.erb'),
    order   => 06,
  }

  concat::fragment{ 'neo4j conf footer':
    target  => $config_file,
    content => "\n\n#End of file\n",
    order   => 99,
  }
}
