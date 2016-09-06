test:
	docker-compose -f docker-compose.test.yml up --build sut

run:
	docker-compose -f docker-compose.yml -f docker-compose.production.yml pull
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
	docker-compose -f docker-compose.yml -f docker-compose.production.yml exec web bin/bootstrap
