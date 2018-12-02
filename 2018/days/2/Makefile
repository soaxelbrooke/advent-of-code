
solution:
	sudo -Hu postgres psql -p 5435 -c "create role stuart with login superuser password 'password';"
	sudo -Hu postgres psql -p 5435 -c 'create database day_2 with owner stuart;'
	psql -p 5435 day_2 -c 'create table input (id text);'
	psql -p 5435 day_2 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_2 -f solution.sql
