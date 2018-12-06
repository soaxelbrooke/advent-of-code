
solution:
	sudo -Hu postgres psql -p 5435 -c 'create database day_6 with owner stuart;'
	psql -p 5435 day_6 -c 'create table input (line text);'
	psql -p 5435 day_6 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_6 -f solution.sql
