test:
	docker-compose -f docker-compose.test.yml pull
	docker-compose -f docker-compose.test.yml up --build sut

run:
	docker-compose -f docker-compose.yml -f docker-compose.production.yml pull
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
