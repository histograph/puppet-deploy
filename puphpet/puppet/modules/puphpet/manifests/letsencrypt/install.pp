# Class for installing Let's Encrypt tool
#
# Generates SSL certs for Apache/Nginx vhosts
#
class puphpet::letsencrypt::install
  inherits puphpet::letsencrypt::params
{

  include nginx::params

  $letsencrypt = $puphpet::params::hiera['letsencrypt']
  $nginx       = $puphpet::params::hiera['nginx']

  if array_true($nginx, 'install') {
    $webserver_service = $::nginx::params::package_name
  }
  else {
    $webserver_service = false
  }

  if ! defined(Puphpet::Firewall::Port['80']) {
    puphpet::firewall::port { '80': }
  }

  include puphpet::letsencrypt::certbot

  puphpet::letsencrypt::generate_certs { 'from puphpet::letsencrypt::install':
    webserver_service => $webserver_service
  }

}
