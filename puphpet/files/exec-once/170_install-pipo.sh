#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING E&L PIPO %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

export MY_MODULE="pipo"
export MY_REPO="https://github.com/histograph"
export MY_WEBDIR="$(read_params nginx.vhosts.importeren_histograph.www_root)"

MY_WEBDIR=${MY_WEBDIR%/web}

# install e&L pipo
install_phpcode

cd ${SRC_HOME}/${MY_PLACE}

echo "CREATE DATABASE IF NOT EXISTS $(read_params mysql.databases.pipo.name) \
            DEFAULT CHARACTER SET = 'utf8' \
            DEFAULT COLLATE = 'utf8_general_ci' " | mysql --user="$(read_params mysql.users.pipo.name)" \
      --password="$(read_params mysql.users.pipo.password)" 

mysql --user="$(read_params mysql.users.pipo.name)" \
      --password="$(read_params mysql.users.pipo.password)" \
      "$(read_params mysql.databases.pipo.name)" < ./sql/pipo.sql



clean_webdir

cp -r app images web vendor src ${MY_WEBDIR}

cat > ${MY_WEBDIR}/app/config/parameters.php<<EOF
<?php

// SITE configs
\$app['sitename'] = 'Histograph - Pit Importer Part One';
\$app['upload_dir'] = __DIR__ . '/../storage/uploads';
\$app['export_dir'] = __DIR__ . '/../storage/exports';
\$app['api_user'] = '$(read_params histograph.users.api_user)';
\$app['api_pass'] = '$(read_params histograph.users.api_password)';

\$app['aws_key'] = '$(read_params histograph.aws.key)';
\$app['aws_secret'] = '$(read_params histograph.aws.secret)';
\$app['aws_bucket'] = '$(read_params histograph.aws.bucket)';
\$app['aws_region'] = '$(read_params histograph.aws.region)';

// BASIC USERS with PASSWORD
\$app['users'] = array(
    '$(read_params histograph.users.import_user)' => '$(read_params histograph.users.import_password)',
);

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
    'user'     => '$(read_params mysql.users.pipo.name)',
    'password' => '$(read_params mysql.users.pipo.password)',
    'dbname'   => '$(read_params mysql.databases.pipo.name)',
    'charset'   => 'utf8',
);

// MONOLOG
\$app->register(new Silex\Provider\MonologServiceProvider(), array(
    'monolog.logfile' => __DIR__ . '/../../app/storage/log/prod.log',
    'monolog.name'    => 'Pipo-app',
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

# pipo needs to write files to disk (exports, logs)
chmod -R u+w ${MY_WEBDIR}/app/storage