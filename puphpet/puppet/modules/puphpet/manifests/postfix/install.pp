# Class for installing postfix
#
#
class puphpet::postfix::install {

  include ::puphpet::params

  $postfix  = $puphpet::params::hiera['postfix']
 
  # if array_true($redis['settings'], 'conf_port') {
  #   $port = $redis['settings']['conf_port']
  # } else {
  #   $port = $redis['settings']['port']
  # }

  # $settings = delete(deep_merge({
  #   'port'        => $port,
  #   'manage_repo' => $manage_repo,
  # }, $redis['settings']), 'conf_port')

  $settings = $postfix['settings']
  
  create_resources('class', { 'postfix' => $settings })

}
