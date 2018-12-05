
solution:
	sudo -Hu postgres psql -p 5435 -c 'create database day_5 with owner stuart;'
	psql -p 5435 day_5 -c 'create table input (line text);'
	psql -p 5435 day_5 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_5 -f solution.sql
