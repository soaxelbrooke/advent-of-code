
create-db:
	mkdir -p postgresql-data && sudo chown postgres postgresql-data
	sudo -Hu postgres pg_createcluster -d $$(pwd)/postgresql-data -p 5435 11 advent_of_code --start
	sudo -Hu postgres psql -p 5435 -c "create role stuart with login superuser password 'password';"

