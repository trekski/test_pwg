serve:
	docker-compose run --rm jekyll-pwg jekyll serve
build:
	docker-compose run --rm jekyll-pwg jekyll build
run_psql:
	psql -h $$PSQL_HOST -U $$PSQL_USERNAME -d $$PSQL_DATABASE