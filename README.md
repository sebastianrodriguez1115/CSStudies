# CSStudies

Repositorio personal de notas y practica sobre ciencias de la computacion, entrevistas tecnicas e ingenieria de software.

Funciona como archivo vivo: notas, ejercicios, soluciones, respuestas de entrevista, referencias y pequenos proyectos de aprendizaje.

## Estructura

- `code-signal/`: soluciones de practica por categoria de estructuras de datos y algoritmos.
- `personal/`: implementaciones propias de algoritmos y estructuras de datos para practicar lo aprendido.
- `languages/ruby/`: programa guiado para aprender Ruby, Rack, Rails, Devise y Grape.
- `software-engineering/`: base de conocimiento para arquitectura, sistemas distribuidos, entrevistas Staff+ y respuestas de estudio.

## Rutas De Estudio

### Algoritmos Y Estructuras De Datos

Usa estas carpetas para practicar implementaciones y problemas concretos:

- `code-signal/1. Arrays/`
- `code-signal/2. Linked lists/`
- `code-signal/3. Hash tables/`
- `code-signal/4. Trees/`
- `code-signal/5. Heaps/`
- `code-signal/6. Graphs/`
- `personal/Arrays/`
- `personal/Trees/`
- `personal/Heaps/`
- `personal/Graphs/`

### Ruby, Rack Y Rails

La ruta principal esta en `languages/ruby/`.

Documentos clave:

- `languages/ruby/README.md`: vision general del programa.
- `languages/ruby/roadmap.md`: fases, modulos y ritmo sugerido.
- `languages/ruby/progress/checklist.md`: avance actual.
- `languages/ruby/resources.md`: recursos de apoyo.

Comandos utiles:

```bash
cd languages/ruby
bundle install
bundle exec ruby 01-ruby-foundations/lab/expense_analyzer_test.rb
bundle exec rubocop
```

### Ingenieria De Software Y Entrevistas

La base esta en `software-engineering/`.

Documentos clave:

- `software-engineering/staff-interview-guide.md`: guia de preparacion Staff Engineer+.
- `software-engineering/staff-interview-questions.md`: workbook de preguntas.
- `software-engineering/respuestas/`: respuestas de practica por categoria.
- `software-engineering/fuentes/`: biblioteca de referencias.
- `software-engineering/scripts/progress.py`: generador de dashboard de progreso.

Regenerar dashboard:

```bash
cd software-engineering
python scripts/progress.py
```

## Estado Actual

- Ruby setup completado en `languages/ruby/00-setup`.
- Primer modulo Ruby completado: `languages/ruby/01-ruby-foundations`.
- La preparacion Staff+ tiene guia, workbook, dashboard y estructura de respuestas.
