# Rack Reference

## Leer Primero

- Rack: https://github.com/rack/rack
- Rack SPEC: https://github.com/rack/rack/blob/main/SPEC.rdoc
- Rack Test: https://github.com/rack/rack-test
- Rails on Rack: https://guides.rubyonrails.org/rails_on_rack.html
- Warden: https://github.com/wardencommunity/warden

## Conceptos Clave

- Una app Rack responde a `call(env)`.
- La respuesta es `[status, headers, body]`.
- Middlewares envuelven apps.
- El orden de middlewares cambia comportamiento.
- Rails, Grape y Warden viven sobre Rack.

## Senales De Dominio

- Puedes escribir una app Rack sin Rails.
- Puedes crear un middleware propio.
- Puedes explicar por que Devise depende de Warden.
- Puedes leer `bin/rails middleware` sin perderte.
