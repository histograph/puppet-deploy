# == Class: puphpet::neo4j::install
#
# Installs Neo4j engine.
# Installs Java and opens ports
#
# Usage:
#
#  class { 'puphpet::neo4j::install': }
#
class puphpet::neo4j::install
  inherits puphpet::params
{

  $neo4j = $puphpet::params::hiera['neo4j']

  # if ! defined(Puphpet::Firewall::Port['7474']) {
  #   puphpet::firewall::port { '7474': }
  # }

  $settings = $neo4j['settings']

  # if ! defined(Class['java']) and $settings['java_install'] {
  #   class { 'java':
  #     distribution => 'jre',
  #   }
  # }

  # $merged = merge($settings, {
  #   'java_install' => false,
  #   'manage_repo'  => true,
  #   'repo_version' => '5.x',
  # })

  create_resources('class', { 'neo4j' => $settings })


}
