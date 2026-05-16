# 05 Rack Middlewares

## Objetivo

Entender el pipeline que luego usan Rails, Grape y Devise/Warden.

## Temas

- Middleware Rack.
- Orden de ejecucion.
- `Rack::Builder`.
- `use`, `run`, `map`.
- Logging.
- Timing.
- Request ID.
- Error handling.
- Auth por token.
- CORS, cookies y sessions.
- Relacion con Rails middleware stack.
- Relacion con Warden y Devise.

## Practica

- Crear middlewares propios.
- Encadenar varios middlewares.
- Probar orden de ejecucion.
- Proteger endpoints con token.

## Criterio De Cierre

Puedes explicar como una request atraviesa middlewares antes de llegar a la app.
