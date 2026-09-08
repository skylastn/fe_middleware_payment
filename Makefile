include .env
export $(shell sed 's/=.*//' .env)

install:
	bun install

dev:
	bun run dev

build:
	bun run build

lint:
	bun run lint

clean:
	rm -rf .next node_modules

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down
