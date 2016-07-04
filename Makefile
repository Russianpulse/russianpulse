test:
	docker-compose build
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rspec

setup:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rake db:create db:migrate
	docker-compose -f docker-compose.yml -f docker-compose.override.yml run web rake db:create db:migrate

remote_restart:
	ssh $(SERVER) "cd /app && docker-compose -p mazavr -f docker-compose.yml -f docker-compose.prod.yml stop"
	ssh $(SERVER) "cd /app && docker-compose -p mazavr -f docker-compose.yml -f docker-compose.prod.yml up -d"

remote_update_configs:
	ssh $(SERVER) mkdir -p /app
	scp docker-compose.yml docker-compose.prod.yml $(SERVER):/app/
	scp .env.production $(SERVER):/app/.env

remote_pull_images:
	ssh $(SERVER) "cd /app && docker-compose -p mazavr -f docker-compose.yml -f docker-compose.prod.yml pull"

deploy: remote_update_configs remote_pull_images remote_restart
	ssh $(SERVER) "cd /app && docker-compose -p mazavr -f docker-compose.yml -f docker-compose.prod.yml exec web rake db:create db:migrate"
	ssh $(SERVER) "cd /app && docker-compose -p mazavr -f docker-compose.yml -f docker-compose.prod.yml restart web"
	ssh $(SERVER) curl 0.0.0.0:80
