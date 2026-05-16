# Rack API

Proyecto para entender HTTP, Rack y middlewares.

## Alcance

- App Rack pura.
- `config.ru`.
- Endpoints JSON.
- Middlewares propios.
- Tests con `rack-test`.

## Endpoints Minimos

- `GET /health`
- `GET /tasks`
- `POST /tasks`
- `PATCH /tasks/:id/complete`

## Middlewares Minimos

- Request logger.
- Request ID.
- Response timer.
- Token auth.
- Error handler.
