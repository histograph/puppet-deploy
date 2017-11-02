#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  --- INSTALLING E&L STANDAARDISEREN ---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

export MY_MODULE="place-identificator"
export MY_REPO="https://github.com/histograph"
export MY_WEBDIR="$(read_params nginx.vhosts.standaardiseren_histograph.www_root)"

MY_WEBDIR=${MY_WEBDIR%/web}

# install e&L standaardiseren
install_phpcode

cd ${SRC_HOME}/${MY_PLACE}


echo "CREATE DATABASE IF NOT EXISTS $(read_params mysql.databases.standaardiseren.name) \
            DEFAULT CHARACTER SET = 'utf8' \
            DEFAULT COLLATE = 'utf8_general_ci' " | mysql --user="$(read_params mysql.users.standaardiseren.name)" \
      --password="$(read_params mysql.users.standaardiseren.password)" 

# echo "CREATE DATABASE IF NOT EXISTS standaardiseren_db \
#             DEFAULT CHARACTER SET = 'utf8' \
#             DEFAULT COLLATE = 'utf8_general_ci' " | mysql --user="standaardiseren_username" \
#       --password="standaardiseren_userpassword" 

mysql --user="$(read_params mysql.users.standaardiseren.name)" \
      --password="$(read_params mysql.users.standaardiseren.password)" \
      "$(read_params mysql.databases.standaardiseren.name)" < ./sql/pid3.sql



clean_webdir

cp -r app bin local-src web vendor src ${MY_WEBDIR}

cat > ${MY_WEBDIR}/app/config/parameters.php<<EOF
<?php

// SITE configs
\$app['sitename'] = 'E&L - Plaatsnamen standaardiseren';
\$app['upload_dir'] = __DIR__ . '/../storage/uploads';

// FOR DEVELOPMENT
//\$app['debug'] = true;

// FOR PRODUCTION
\$app['debug'] = false;


// LOCALE
\$app['locale'] = 'nl';
\$app['session.default_locale'] = \$app['locale'];


// DOCTRINE DBAL
\$app["db.options"] = array(
    'driver'   => 'pdo_mysql',
    'host'     => 'localhost',
    'user'     => '$(read_params mysql.users.standaardiseren.name)',
    'password' => '$(read_params mysql.users.standaardiseren.password)',
    'dbname'   => '$(read_params mysql.databases.standaardiseren.name)',
    'charset'   => 'utf8',
);

// MAILER
\$app['swiftmailer.options'] = array(
    'host' => 'localhost',
    'port' => 25
//    'username' => 'some-email@gmail.com',
//    'password' => 'xxx',
//    'encryption' => 'ssl',
//    'auth_mode' => 'login'
);

// MONOLOG
\$app->register(new Silex\Provider\MonologServiceProvider(), array(
    'monolog.logfile' => __DIR__ . '/../../app/storage/log/prod.log',
    'monolog.name'    => 'pid-app',
    'monolog.level'   => Monolog\Logger::WARNING,
    //'monolog.level'   => Monolog\Logger::DEBUG,
));

// CACHES
\$app['cache.path'] = __DIR__ . '/../storage/cache';
// Http cache
\$app['http_cache.cache_dir'] = \$app['cache.path'] . '/http';
// Twig cache
\$app['twig.options.cache'] = \$app['cache.path'] . '/twig';
EOF

set_PHP_webdirperm

# standaardiseren needs to write files to disk (exports, logs)
chmod -R u+w ${MY_WEBDIR}/app/storage