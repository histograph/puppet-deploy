sudo su stefano

read_params () {
    hiera --hash --format json --config /vagrant/puphpet/puppet/hiera.yaml $1 | jq ".${2}" | tr -d '"'
}


cd /home/stefano/backup


## BACKUP

# THISCOPY="$(date +%Y%m%d_%H%M%S)"
THISCOPY="$(date +%d)"

mysqldump --databases $(read_params mysql databases.pipo.name ) \
                        -h localhost -u $(read_params mysql users.pipo.name ) \
                        -p$(read_params mysql users.pipo.password ) > pipo_${THISCOPY}.sql

mysqldump --databases $(read_params mysql databases.standaardiseren.name ) \
                        -h localhost -u $(read_params mysql users.standaardiseren.name ) \
                        -p$(read_params mysql users.standaardiseren.password )  > standaardiseren_${THISCOPY}.sql



sudo tar -cvf pipo_${THISCOPY}.tar /var/www/importeren/app/storage

sudo tar -cvf standaardiseren_${THISCOPY}.tar /var/www/standaardiseren/app/storage

tar --exclude='/uploads/datasets/bag' -cvf uploads_${THISCOPY}.tar /uploads

ALL_BK_FILES="pipo_${THISCOPY}.sql standaardiseren_${THISCOPY}.sql pipo_${THISCOPY}.tar standaardiseren_${THISCOPY}.tar uploads_${THISCOPY}.tar"

tar -zcvf all_${THISCOPY}.tar.gz ${ALL_BK_FILES}

/home/stefano/bin/aws s3 cp all_${THISCOPY}.tar.gz s3://histograph-backups

rm -rf ${ALL_BK_FILES}
