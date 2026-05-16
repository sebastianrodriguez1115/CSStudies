# 00 Setup

## Objetivo

Preparar y auditar un entorno Ruby/Rails reproducible.

Este modulo no empieza desde cero: ya existe `rbenv`, Ruby, Bundler, Rails y RuboCop. El foco es fijar versiones, detectar huecos y crear un sandbox minimo.

## Temas

- Ruby con `rbenv`.
- Bundler y RubyGems.
- `irb`, `pry`, `ruby`, `bundle`, `rake`.
- Editor, formatter y linter.
- SQLite para practica local.
- PostgreSQL para proyectos Rails mas cercanos a produccion.

## Estado Actual

Ver `environment-audit.md`.

Resumen:

- Ruby `4.0.4` activo via `rbenv`.
- Bundler `4.0.10` disponible.
- Rails `8.1.3` disponible.
- RuboCop `1.86.2` disponible.
- PostgreSQL client disponible.
- SQLite CLI `3.46.1` disponible.

## Practica

- Verificar que `.ruby-version` use Ruby `4.0.4`.
- Usar `sandbox/` como proyecto Ruby minimo.
- Ejecutar un script Ruby desde terminal.
- Ejecutar RuboCop con `TargetRubyVersion: 4.0`.
- Crear una tarea `Rake` simple.
- Confirmar SQLite y PostgreSQL como opciones de base de datos local.

## Criterio De Cierre

Puedes crear un proyecto Ruby minimo, instalar gems, correr un script, ejecutar una tarea `Rake` y pasar RuboCop sin depender de Rails.

## Comandos Utiles

```bash
ruby -v
rbenv version
gem -v
bundle -v
rubocop -V
rails -v
psql --version
sqlite3 --version
```

## Nota Sobre SQLite

SQLite ya esta disponible. Esto permite seguir ejemplos Rails con el default local y reservar PostgreSQL para practicas mas cercanas a produccion.

## Que Documentar Aqui

- Versiones activas de herramientas: Ruby, Bundler, Rails, RuboCop y bases de datos.
- Decisiones de entorno: version fijada en `.ruby-version`, linter y base de datos preferida.
- Comandos de verificacion que deben seguir funcionando.
- Problemas encontrados durante setup y como se resolvieron.
- Pendientes reales, no teoria ni tutoriales copiados.

## Sandbox

El directorio `sandbox/` existe para verificar el entorno sin Rails.

```bash
cd 00-setup/sandbox
bundle install
ruby hello.rb Sebastian
bundle exec rake check
```
