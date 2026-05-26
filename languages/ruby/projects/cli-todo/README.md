# CLI Todo

Proyecto de Ruby puro para practicar fundamentos, OOP, stdlib y testing.

## Uso

Ejecuta los comandos desde la raiz del repo:

```bash
projects/cli-todo/bin/todo add "Buy milk"
projects/cli-todo/bin/todo list
projects/cli-todo/bin/todo list pending
projects/cli-todo/bin/todo list completed
projects/cli-todo/bin/todo complete <id>
projects/cli-todo/bin/todo reopen <id>
projects/cli-todo/bin/todo rename <id> "Buy oat milk"
projects/cli-todo/bin/todo remove <id>
projects/cli-todo/bin/todo clear-completed
```

Ejemplo de salida:

```text
[ ] 72ee014d-96c9-4be1-9b10-09d96688012c Buy milk
```

Las tareas se guardan en:

```text
projects/cli-todo/todos.json
```

## Alcance

- Crear tareas.
- Listar tareas.
- Completar tareas.
- Filtrar por estado.
- Persistir en JSON.
- Testear reglas principales.

## Restriccion

No usar Rails. Si necesitas framework, estas saltando demasiado pronto.
