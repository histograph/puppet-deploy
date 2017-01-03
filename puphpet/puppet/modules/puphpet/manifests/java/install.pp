# == Class: puphpet::java::install
#
# Installs java
#
# Usage:
#
#  class { 'puphpet::java::install': }
#
class puphpet::java::install
  inherits puphpet::params
{

  $java = $puphpet::params::hiera['java']

  # if ! defined(Puphpet::Firewall::Port['7474']) {
  #   puphpet::firewall::port { '7474': }
  # }

  $settings = $java['settings']

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

  create_resources('class', { 'java' => $settings })


}
