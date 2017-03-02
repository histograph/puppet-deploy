# == Class: puphpet::elasticsearch::install
#
# Installs Elasticsearch engine.
# Installs Java and opens ports
#
# Usage:
#
#  class { 'puphpet::elasticsearch::install': }
#
class puphpet::elasticsearch::install
  inherits puphpet::params
{

  $elasticsearch = $puphpet::params::hiera['elasticsearch']

  # if ! defined(Puphpet::Firewall::Port['9200']) {
  #   puphpet::firewall::port { '9200': }
  # }

  $settings = $elasticsearch['settings']

  if ! defined(Class['java']) and $settings['java_install'] {
    class { 'java':
      distribution => 'jre',
    }
  }

  if array_true($settings, 'heap_size') {

    $heap_size = $settings['heap_size']
    $mergedsettings = merge(delete($settings,'heap_size'), { "jvm_options" => ["-Xms$heap_size", "-Xmx$heap_size"]})

    $merged = merge($mergedsettings, {
      'java_install' => false,
      'manage_repo'  => true,
      'repo_version' => '5.x',
    })
  }else{
    $merged = merge($settings, {
      'java_install' => false,
      'manage_repo'  => true,
      'repo_version' => '5.x',
    })
  }

  notify{"Dump of ES settings: ${merged}": }

  # create_resources('class', { 'elasticsearch' => $merged }, { 'require' => Class['java'] })
  create_resources('class', { 'elasticsearch' => $merged })

  # config file could contain no instance keys
  $instances = array_true($elasticsearch, 'instances') ? {
    true    => $elasticsearch['instances'],
    default => { }
  }

  each( $instances ) |$key, $instance| {
    $name = $instance['name']
    create_resources( elasticsearch::instance, { "${name}" => $instance })
  }

}
