include .env
export  X=${PGPASSWORD} # bacasue of special characters usign it in-line does not work and I c.b.a. to figure it out
jekyll-serve:
	docker-compose run --rm jekyll-pwg jekyll serve
jekyll-build:
	docker-compose run --rm jekyll-pwg jekyll build
jekyll-shell:
	docker-compose run --rm jekyll-pwg /bin/bash
local-psql-up:
	docker-compose up php-bb-psql
local-psql-down:
	docker-compose down php-bb-psql
remote-psql-cli:
	psql -h ${PSQL_HOST} -U ${PSQL_USERNAME} -d ${PSQL_DATABASE}
psql-dump:
	pg_dump -F c -b -v -x -f "./_psql_dump/baza.dump" -h $PSQL_HOST -U $PSQL_USERNAME $PSQL_DATABASE
psql-restore:
	pg_restore -h localhost -U user -d dump -O ./_psql_dump/$$PSQL_DATABASE.dump