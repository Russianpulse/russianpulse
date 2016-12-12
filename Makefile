test:
	docker-compose -f docker-compose.test.yml up --build sut

run:
	docker-compose -f docker-compose.yml -f docker-compose.production.yml pull
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d

base:
	docker build -f Dockerfile.base -t registry.gitlab.com/sergio-fry/mazavr-engine:base .
	docker push registry.gitlab.com/sergio-fry/mazavr-engine:base
