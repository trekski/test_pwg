serve:
	docker-compose run --rm jekyll-pwg jekyll serve -l
build:
	docker-compose run --rm jekyll-pwg jekyll build