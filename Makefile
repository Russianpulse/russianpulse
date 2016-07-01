build:
	docker-compose build
	touch build

test: build
	RAILS_ENV=test docker-compose run web spring rspec

run: build
	docker-compose up

clean:
	rm build

