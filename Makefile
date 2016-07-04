test:
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rspec

setup:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rake db:create db:migrate
	docker-compose run web rake db:create db:migrate
