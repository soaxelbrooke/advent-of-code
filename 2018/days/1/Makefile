
.phony: solution
solution:
	sudo -Hu postgres psql -p 5435 -c 'create database day_1 with owner stuart;'
	psql -p 5435 day_1 -c 'create table input (operation text);'
	psql -p 5435 day_1 -c "copy input from '$(shell pwd)/input.txt';"
	psql -p 5435 day_1 -f solution.sql

