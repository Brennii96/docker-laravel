start:
	docker compose up -d

start-build:
	docker compose up -d --build

stop:
	docker compose down

cc:
	docker compose exec app bash -c "php artisan optimize:clear"

migrate:
	docker compose exec app bash -c "php artisan migrate"

composer-install:
	docker compose exec app bash -c "composer install"

composer-dumpautoload:
	docker compose exec app bash -c "composer dumpautoload"
