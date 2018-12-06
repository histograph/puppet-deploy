sudo su stefano

read_params () {
    hiera --hash --format json --config /vagrant/puphpet/puppet/hiera.yaml $1 | jq ".${2}" | tr -d '"'
}


cd /home/stefano/backup

## RESTORE

WHATCOPY=

gunzip pipo_${WHATCOPY}.sql.gz | mysql -h localhost -u $(read_params mysql users.pipo.name ) \
                        -p$(read_params mysql users.pipo.password ) \
                        $(read_params mysql databases.pipo.name ) 

gunzip standaardiseren_${WHATCOPY}.sql.gz | mysql -h localhost -u $(read_params mysql users.standaardiseren.name ) \
                        -p$(read_params mysql users.standaardiseren.password ) \
                        $(read_params mysql databases.standaardiseren.name )


tar xvf pipo_{WHATCOPY}.tar.gz

sudo cp -r var/www/importeren/app/storage/uploads/* /var/www/importeren/app/storage/uploads

sudo cp -r var/www/importeren/app/storage/exports/* /var/www/importeren/app/storage/exports

sudo chown -R www-user:www-data /var/www/importeren/app/storage

tar xvf standaardiseren_{WHATCOPY}.tar.gz

sudo cp -r var/www/standaardiseren/app/storage/uploads/* /var/www/standaardiseren/app/storage/uploads

sudo chown -R www-user:www-data /var/www/standaardiseren/app/storage

rm -rf var

#curl -X POST -d "{\"query\":\"MERGE (admin:Owner { name: }) ON CREATE SET admin.password = {password}') return node\"}" --header "Content-Type:application/json" localhost:7474/db/data/cypher