test:
	docker-compose -f docker-compose.test.yml build sut
	docker-compose -f docker-compose.test.yml up sut

run:
	docker-compose -f docker-compose.yml -f docker-compose.production.yml pull
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d

base:
	docker build -t registry.gitlab.com/russianpulse/mazavr:base -f Dockerfile.base .
	docker push registry.gitlab.com/russianpulse/mazavr:base

