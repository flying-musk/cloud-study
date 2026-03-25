# Cloud Study: Go + Redis + Nginx App

This is a project for learning cloud deployment and basic microservice-style architecture.

It uses Docker Compose to connect a backend API, a Redis cache, and an Nginx reverse proxy, and is deployed on AWS EC2.

## Components

- **Nginx**
  - Entry point for HTTP requests
  - Runs on port `80`
  - Proxies traffic to the Go app

- **Go App**
  - Handles the main application logic
  - Updates and returns the visitor count

- **Redis**
  - Stores the visitor counter

- **RedisInsight**
  - Optional UI for viewing Redis data
  - Runs on port `5540`

## Request Flow

1. A user sends a request to **Nginx**
2. Nginx forwards the request to the **Go app**
3. The Go app updates the visitor count in **Redis**
4. The response is returned to the user

## Access

- **Main App**: `http://localhost`
- **RedisInsight**: `http://localhost:5540`

## Run Locally

```bash
docker-compose up -d
```

## Deployment

This project is deployed on **AWS EC2**.

A GitHub Actions CI/CD pipeline is to:
- build and push the Docker image
- connect to the EC2 instance
- pull the latest image
- restart the containers