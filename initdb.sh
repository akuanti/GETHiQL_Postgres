#!/bin/bash

db=$(cat pgpass.conf | cut -d':' -f3)
user=$(cat pgpass.conf | cut -d':' -f4)
pass=$(cat pgpass.conf | cut -d':' -f5)
passfile=pgpass.conf
create_tables=create_tables.sql

echo "Creating db $db"
sudo -u postgres bash -c "createdb $db"
echo "Creating tables from $create_tables"
sudo -u postgres bash -c "psql -d $db -f $create_tables"
echo "Creating psql user $user with password $pass"
sudo -u postgres bash -c "psql -c \"CREATE USER $user WITH PASSWORD '$pass';\""
sudo -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $db TO $user;\""
sudo -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO $user;\""
sudo -u postgres bash -c "psql -c \"GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA PUBLIC TO $user;\""
echo "done"
