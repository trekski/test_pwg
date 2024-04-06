include .env
x:
	echo '${PGPASSWORD}'
jekyll-serve:
	docker-compose run --rm jekyll-pwg jekyll serve
jekyll-build:
	docker-compose run --rm jekyll-pwg jekyll build
jekyll-shell:
	docker-compose run jekyll-pwg /bin/bash
local-psql-up:
	docker-compose up php-bb-psql
local-psql-down:
	docker-compose down php-bb-psql
remote-psql-cli:
	psql -h ${PSQL_HOST} -U ${PSQL_USERNAME} -d ${PSQL_DATABASE}
psql-dump:
	pg_dump -F c -b -v -x -f "./_psql_dump/${PSQL_DATABASE}.dump" -h ${PSQL_HOST} -U ${PSQL_USERNAME} ${PSQL_DATABASE}
psql-restore:
	pg_restore -h localhost -U user -d ${PSQL_DATABASE} -O ./_psql_dump/${PSQL_DATABASE}.dump