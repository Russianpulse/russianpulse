LOCAL_ENV := DOCKER_TLS_VERIFY="1" DOCKER_HOST="tcp://192.168.99.101:2376" DOCKER_CERT_PATH="/Users/sergei/.docker/machine/machines/default" DOCKER_MACHINE_NAME="default"
PRODUCTION_ENV := DOCKER_TLS_VERIFY="1" DOCKER_HOST="tcp://192.168.99.101:2376" DOCKER_CERT_PATH="/Users/sergei/.docker/machine/machines/default" DOCKER_MACHINE_NAME="default"

test:
	$(LOCAL_ENV) RAILS_ENV=test docker-compose exec web rspec

run:
	$(LOCAL_ENV) docker-compose up

deploy:
	$(PRODUCTION_ENV) docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
	$(PRODUCTION_ENV) docker-compose -f docker-compose.yml -f docker-compose.prod.yml restart -d
