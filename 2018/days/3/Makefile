
solution:
	sudo -Hu postgres psql -p 5435 -c 'create database day_3 with owner stuart;'
	psql -p 5435 day_3 -c 'create table input (claim text);'
	psql -p 5435 day_3 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_3 -f solution.sql
