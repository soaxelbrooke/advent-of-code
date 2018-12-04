
solution:
	sudo -Hu postgres psql -p 5435 -c 'create database day_4 with owner stuart;'
	psql -p 5435 day_4 -c 'create table input (log text);'
	psql -p 5435 day_4 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_4 -f solution.sql
