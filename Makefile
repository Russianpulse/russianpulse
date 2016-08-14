test:
	docker-compose -f docker-compose.test.yml up --build sut

run:
	docker-compose pull
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
