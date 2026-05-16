# Environment Audit

Fecha: 2026-05-15

## Estado Actual

- Ruby: `4.0.4`
- Version activa de rbenv: `4.0.4`
- Version Ruby usada por este programa: `4.0.4`
- RubyGems: `4.0.10`
- Bundler: `4.0.10`
- Rails: `8.1.3`
- RuboCop: `1.86.2`
- PostgreSQL client: `17.9`
- SQLite CLI: `3.46.1`

## Rutas Relevantes

- Ruby activo: `/home/sebastian/.rbenv/shims/ruby`
- Ruby resuelto por rbenv: `/home/sebastian/.rbenv/versions/4.0.4/bin/ruby`
- Gem home: `/home/sebastian/.rbenv/versions/4.0.4/lib/ruby/gems/4.0.0`

## Decisiones

- El programa queda fijado a Ruby `4.0.4` con `.ruby-version`.
- RuboCop queda configurado con `TargetRubyVersion: 4.0` para analizar con la version objetivo actual.
- Rails ya esta instalado, pero no se usara hasta completar Ruby y Rack.
- SQLite esta disponible para seguir el flujo default de Rails.
- PostgreSQL queda disponible para practicas mas cercanas a produccion.

## Pendiente

- Decidir si los proyectos Rails usaran SQLite al inicio o PostgreSQL desde el inicio.
- Repetir esta auditoria si se cambia la version de Ruby, Rails o la base de datos principal.

## Verificacion Ejecutada

- `bundle exec rake check` en `00-setup/sandbox`: pasa.
