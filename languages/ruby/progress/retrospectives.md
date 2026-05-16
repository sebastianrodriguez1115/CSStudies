# Retrospectives

Usa esta plantilla al cerrar cada modulo.

## 00 Setup

Nombre: entorno Ruby/Rails reproducible

Fecha: 2026-05-14

## Que Aprendi

- El entorno ya estaba avanzado: `rbenv`, Ruby `4.0.4`, Bundler, Rails, RuboCop y PostgreSQL estaban disponibles.
- Faltaba SQLite, ya quedo instalado y verificado.
- Conviene fijar el programa con `.ruby-version` para evitar cambios silenciosos de Ruby.
- RuboCop necesita `TargetRubyVersion: 4.0`; sin eso puede analizar con una version objetivo incorrecta.

## Que Todavia No Entiendo

- Decidir si los proyectos Rails usaran SQLite al inicio o PostgreSQL desde el inicio.

## Codigo Que Escribi

- `.ruby-version`
- `.rubocop.yml`
- `00-setup/environment-audit.md`
- `00-setup/sandbox/Gemfile`
- `00-setup/sandbox/Rakefile`
- `00-setup/sandbox/hello.rb`

## Errores Interesantes

- `bundle exec rake check` fallo al inicio por reglas de estilo de RuboCop.
- La correccion fue ajustar strings, frozen string literals y desactivar sugerencias de extensiones en RuboCop.

## Siguiente Paso

- Iniciar `01-ruby-foundations` con ejercicios de sintaxis, colecciones, bloques y `Enumerable`.

## 01 Ruby Foundations

Nombre: fundamentos de Ruby, colecciones, bloques y Enumerable

Fecha: 2026-05-15

## Que Aprendi

- Usar `map`, `select`, `reduce`, `group_by`, `transform_values` y `max` para transformar colecciones.
- Pasar bloques a metodos propios con `yield`.
- Crear hashes acumuladores con `Hash.new(0)`.
- Separar codigo ejecutable de codigo importable con `$PROGRAM_NAME == __FILE__`.
- Escribir tests basicos con Minitest.

## Que Todavia No Entiendo

- Profundizar cuando conviene `reduce`, `sum`, `each_with_object` o `transform_values`.
- Practicar mas la diferencia entre `max` con `<=>` y `max_by`.

## Codigo Que Escribi

- `01-ruby-foundations/exercises/01_slugs.rb`
- `01-ruby-foundations/exercises/02_word_frequencies.rb`
- `01-ruby-foundations/exercises/03_group_transactions.rb`
- `01-ruby-foundations/exercises/04_block_filters.rb`
- `01-ruby-foundations/exercises/05_enumerable_rewrite.rb`
- `01-ruby-foundations/lab/expense_analyzer.rb`
- `01-ruby-foundations/lab/expense_analyzer_test.rb`

## Errores Interesantes

- `Hash.new([])` puede ser peligroso porque el valor default puede compartirse si se muta.
- `puts` imprime cada elemento de un array en lineas separadas; `p` muestra la estructura completa.
- RuboCop estaba configurado para analizar como Ruby `3.4`; se actualizo a `TargetRubyVersion: 4.0`.

## Siguiente Paso

- Iniciar `02-ruby-oop` con clases, objetos, inicializacion y metodos de instancia.

## Modulo

Nombre:

Fecha:

## Que Aprendi

- 

## Que Todavia No Entiendo

- 

## Codigo Que Escribi

- 

## Errores Interesantes

- 

## Siguiente Paso

- 
