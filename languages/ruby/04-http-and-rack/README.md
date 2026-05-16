# 04 HTTP And Rack

## Objetivo

Entender que recibe y devuelve una app web Ruby antes de usar Rails.

## Temas

- HTTP: method, path, query string, headers, body.
- Status codes.
- Rack como contrato: `call(env) -> [status, headers, body]`.
- `config.ru`.
- `Rack::Request` y `Rack::Response`.
- Respuestas JSON.
- Routing manual minimo.
- `rack-test`.

## Practica

- Crear una app Rack minima.
- Crear endpoints `GET /health`, `GET /hello`, `POST /echo`.
- Parsear params.
- Testear endpoints.

## Criterio De Cierre

Puedes explicar el contrato Rack y escribir una app Rack sin Rails.
