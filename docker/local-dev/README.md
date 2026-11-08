# Local dev services

Runs on OrbStack. Ports listen on `127.0.0.1` only, since MongoDB and Redis have no auth.
Postgres allows 200 connections; keep each project's pool at about 5–10.

One shared instance of each backing service for every project on this machine.
Databases are separated by name inside a single instance — do not add per-project containers.

```sh
cd ~/docker/local-dev
docker compose up -d      # start everything
docker compose ps         # status
docker compose down       # stop (data survives)
```

## Endpoints

| Service  | Host port     | Credentials             | Notes                          |
| -------- | ------------- | ----------------------- | ------------------------------ |
| MongoDB  | `27017`       | none (no auth)          | `mongo:8.2` (8.3 needs a kernel fix) |
| Postgres | `5432`        | `postgres` / `postgres` | `postgres:18`                  |
| Redis    | `6380`        | none                    | `redis:8-alpine`, AOF on       |
| RabbitMQ | `5672`        | `dev` / `dev`           | delayed-message plugin enabled |
| — mgmt   | `15672`       | `dev` / `dev`           | http://localhost:15672         |
| MinIO    | `9000`        | `minioadmin` / same     | S3 API, `cgr.dev/chainguard/minio` |
| — console| `9001`        | `minioadmin` / same     | http://localhost:9001          |

**Redis is on 6380, not 6379.** 6379 is often taken by a `kubectl port-forward` to a remote Redis.
Anything on `localhost:6379` that wants a password is that remote instance, not this one.

## Version ceilings

RabbitMQ is pinned to the **4.2** line because `rabbitmq_delayed_message_exchange` is a
community plugin released per server line, and v4.2.0 is its newest release. Do not bump
RabbitMQ past 4.2 until a matching plugin release exists.

## Databases

The volumes were reset on 2026-11-08 (Docker Desktop to OrbStack), so every project starts
empty and creates its database on first use.

Add a new project by creating a new database inside the existing instance, e.g.
`mongodb://localhost:27017/my-new-project`.
