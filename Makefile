serve:
	docker-compose run --rm jekyll-pwg jekyll serve
build:
	docker-compose run --rm jekyll-pwg jekyll build
psql_server:
	docker-compose up php-bb-psql
stop_server:
	docker-compose down php-bb-psql
run_psql_cli:
	psql -h $$PSQL_HOST -U $$PSQL_USERNAME -d $$PSQL_DATABASE
restore:
	pg_restore -h localhost -U user -d dump -O ./_psql_dump/baza.dump