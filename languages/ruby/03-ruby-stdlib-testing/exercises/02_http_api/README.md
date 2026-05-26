# HTTP API

Ejercicio pequeño para practicar consumo HTTP, parseo JSON y tests sin red real.

## Objetivo

Consumir el endpoint `/books` de una API local compatible con `jkaninda/simple-api`, convertir la respuesta a objetos Ruby y manejar errores HTTP.

## Diseno

- `SimpleApiClient` usa `Net::HTTP` por defecto.
- Los tests inyectan un fake HTTP para evitar depender de Docker o internet.
- `Book` representa el objeto de dominio y valida sus invariantes.
- `SimpleApiClient::HttpError` representa fallos HTTP no exitosos.

## Archivos

- `book.rb`: objeto de dominio con validaciones y `to_h`.
- `simple_api_client.rb`: cliente HTTP para `/books`.
- `book_test.rb`: tests de invariantes de `Book`.
- `simple_api_client_test.rb`: tests del cliente con fake HTTP.
- `http_api_suite_test.rb`: corre todos los tests del ejercicio.

## Comandos

```bash
bundle exec ruby http_api_suite_test.rb
bundle exec rubocop 03-ruby-stdlib-testing/exercises/02_http_api
```
