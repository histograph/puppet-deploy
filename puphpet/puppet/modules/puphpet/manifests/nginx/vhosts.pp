define puphpet::nginx::vhosts (
  $vhosts
) {

  include puphpet::nginx::params

  $nginx = $puphpet::params::hiera['nginx']

  each( $vhosts ) |$key, $vhost| {
    # Could be proxy vhost
    if array_true($vhost, 'www_root') and $vhost['www_root'] != '' {
      exec { "exec mkdir -p ${vhost['www_root']} @ key ${key}":
        command => "mkdir -p ${vhost['www_root']}",
        user    => $puphpet::nginx::params::webroot_user,
        group   => $puphpet::nginx::params::webroot_group,
        creates => $vhost['www_root'],
        require => File[$puphpet::nginx::params::www_location],
      }

      if ! defined(File[$vhost['www_root']]) {
        file { $vhost['www_root']:
          ensure  => directory,
          mode    => '0775',
          require => Exec["exec mkdir -p ${vhost['www_root']} @ key ${key}"],
        }
      }
    }

    # the gui passes "server_name" and "server_aliases"
    # "server_aliases" is not actually in puppet-nginx
    $server_names = unique(flatten(
      concat([$vhost['server_name']], $vhost['server_aliases'])
    ))

    $ssl = array_true($vhost, 'ssl') ? {
      true    => true,
      default => false,
    }
    $ssl_cert = array_true($vhost, 'ssl_cert') ? {
      true    => $vhost['ssl_cert'],
      default => $puphpet::nginx::params::ssl_cert_location,
    }
    $ssl_key = array_true($vhost, 'ssl_key') ? {
      true    => $vhost['ssl_key'],
      default => $puphpet::nginx::params::ssl_key_location,
    }
    $ssl_port = array_true($vhost, 'ssl_port') ? {
      true    => $vhost['ssl_port'],
      default => '443',
    }
    $ssl_protocols = array_true($vhost, 'ssl_protocols') ? {
      true    => $vhost['ssl_protocols'],
      default => 'TLSv1 TLSv1.1 TLSv1.2',
    }
    $ssl_ciphers = array_true($vhost, 'ssl_ciphers') ? {
      true    => $vhost['ssl_ciphers'],
      default => join($puphpet::nginx::params::allowed_ciphers, ':'),
    }
    $ssl_redirect = $ssl and array_true($vhost, 'ssl_redirect') ? {
      true    => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
      default => undef,
    }

    $ssl_hostname = array_true($vhost, 'ssl_hostname') ? {
      true    => $vhost['ssl_hostname'],
      default => $vhost['server_name']
    }

    $ssl_cert_real = ($ssl_cert == 'LETSENCRYPT') ? {
      true    => "/etc/letsencrypt/live/${ssl_hostname}/fullchain.pem",
      default => $ssl_cert,
    }
    $ssl_key_real = ($ssl_key == 'LETSENCRYPT') ? {
      true    => "/etc/letsencrypt/live/${ssl_hostname}/privkey.pem",
      default => $ssl_key,
    }

    $server_cfg_append = deep_merge(
      {'server_cfg_append' => {'sendfile' => 'off'}},
      $vhost
    )

    # rewrites
    $rewrites = array_true($vhost, 'rewrites') ? {
      true    =>  $vhost['rewrites'],
      default =>  []
    }

    $vhost_rewrites_append = deep_merge($server_cfg_append, {
      'rewrite_rules'  => $rewrites
    })

    if ($ssl_redirect){

      # puppet-nginx is stupidly strict about ssl value datatypes
      $merged = delete(merge($vhost_rewrites_append, {
        'server_name'          => $server_names,
        'use_default_location' => false,
        'ssl'                  => $ssl,
        'ssl_cert'             => $ssl_cert_real,
        'ssl_key'              => $ssl_key_real,
        'ssl_port'             => $ssl_port,
        'ssl_protocols'        => $ssl_protocols,
        'ssl_ciphers'          => "\"${ssl_ciphers}\"",
        'ssl_redirect'     => $ssl_redirect,
      }), ['server_aliases', 'proxy', 'locations','ssl_hostname'])

    }else{

      # puppet-nginx is stupidly strict about ssl value datatypes
      $merged = delete(merge($vhost_rewrites_append, {
        'server_name'          => $server_names,
        'use_default_location' => false,
        'ssl'                  => $ssl,
        'ssl_cert'             => $ssl_cert_real,
        'ssl_key'              => $ssl_key_real,
        'ssl_port'             => $ssl_port,
        'ssl_protocols'        => $ssl_protocols,
        'ssl_ciphers'          => "\"${ssl_ciphers}\"",
      }), ['server_aliases', 'proxy', 'locations', 'ssl_redirect','ssl_hostname'])

    }

    # notify{"Dump of all nginx values: ${key} => $merged": }

    create_resources(nginx::resource::server, { "${key}" => $merged })

    # config file could contain no vhost.locations key
    $locations = array_true($vhost, 'locations') ? {
      true    => $vhost['locations'],
      default => { }
    }

    # notify{"locations ${key}: ${locations}":}

    puphpet::nginx::locations { "from puphpet::nginx::vhosts, ${vhost['www_root']} @ key ${key}":
      locations => $locations,
      ssl       => $ssl,
      www_root  => $vhost['www_root'],
      vhost_key => $key
    }

    if ! defined(Puphpet::Firewall::Port["${vhost['listen_port']}"]) {
      puphpet::firewall::port { "${vhost['listen_port']}": }
    }
  }

  if array_true($nginx['settings'], 'default_vhost') {
    $default_vhost_index_file =
      "${puphpet::nginx::params::webroot_location}/index.html"

    $default_vhost_source_file =
      "${puphpet::params::puphpet_manifest_dir}/files/webserver_landing.html"

    exec { "Set ${default_vhost_index_file} contents":
      command => "cat ${default_vhost_source_file} > ${default_vhost_index_file} && \
                  chmod 644 ${default_vhost_index_file} && \
                  chown root ${default_vhost_index_file} && \
                  chgrp ${puphpet::nginx::params::webroot_group} ${default_vhost_index_file} && \
                  touch ${puphpet::params::puphpet_state_dir}/default_vhost_index_file_set",
      returns => [0, 1],
      creates => "${puphpet::params::puphpet_state_dir}/default_vhost_index_file_set",
      require => File[$puphpet::nginx::params::webroot_location],
    }
  }

}
