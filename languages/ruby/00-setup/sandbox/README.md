# Setup Sandbox

Sandbox minimo para validar que Ruby, Bundler, Rake y RuboCop funcionan fuera de Rails.

## Comandos

```bash
bundle install
ruby hello.rb Sebastian
bundle exec rake
bundle exec rake check
```

## Resultado Esperado

- `ruby hello.rb Sebastian` imprime un saludo.
- `bundle exec rake` ejecuta la tarea default.
- `bundle exec rake check` valida sintaxis Ruby y RuboCop.
