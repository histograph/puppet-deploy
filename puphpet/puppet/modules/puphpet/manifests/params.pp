class puphpet::params (
  $extra_config_files = []
) {

  $puphpet_base_dir     = '/vagrant/puphpet'
  $puphpet_manifest_dir = "${puphpet_base_dir}/puppet/manifests/puphpet"

  $base_configs = [
    "${puphpet_base_dir}/config.yaml",
    "${puphpet_base_dir}/config-${::provisioner_type}.yaml",
  ]

  $custom_config = ["${puphpet_base_dir}/config-custom.yaml"]

  $yaml = merge_yaml($base_configs, $extra_config_files, $custom_config)

  notify{"Dump of all yaml values: ${yaml}": }

  $hiera = {
    vm             => hiera_hash('vagrantfile', {}),
    apache         => $yaml['apache'],
    beanstalkd     => hiera_hash('beanstalkd', {}),
    blackfire      => hiera_hash('blackfire', {}),
    cron           => hiera_hash('cron', {}),
    drush          => hiera_hash('drush', {}),
    elasticsearch  => hiera_hash('elastic_search', {}),
    firewall       => hiera_hash('firewall', {}),
    hhvm           => hiera_hash('hhvm', {}),
    java           => hiera_hash('java', {}),
    letsencrypt    => hiera_hash('letsencrypt', {}),
    locales        => hiera_hash('locale', {}),
    mailhog        => hiera_hash('mailhog', {}),
    mariadb        => hiera_hash('mariadb', {}),
    mongodb        => hiera_hash('mongodb', {}),
    mysql          => hiera_hash('mysql', {}),
    nginx          => $yaml['nginx'],
    nodejs         => hiera_hash('nodejs', {}),
    neo4j          => hiera_hash('neo4j', {}),
    php            => hiera_hash('php', {}),
    postgresql     => hiera_hash('postgresql', {}),
    postfix        => hiera_hash('postfix', {}),
    python         => hiera_hash('python', {}),
    rabbitmq       => hiera_hash('rabbitmq', {}),
    redis          => hiera_hash('redis', {}),
    ruby           => hiera_hash('ruby', {}),
    server         => hiera_hash('server', {}),
    solr           => hiera_hash('solr', {}),
    sqlite         => hiera_hash('sqlite', {}),
    users_groups   => hiera_hash('users_groups', {}),
    wpcli          => hiera_hash('wpcli', {}),
    xdebug         => hiera_hash('xdebug', {}),
    xhprof         => hiera_hash('xhprof', {}),
  }

}
