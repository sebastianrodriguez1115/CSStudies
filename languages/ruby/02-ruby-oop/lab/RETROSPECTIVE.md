# Retrospective

## Sintesis

Este lab practico POO como modelado de reglas, no como acumulacion de clases. El mini sistema de biblioteca obligo a distinguir conceptos del dominio: libro, usuario, prestamo, disponibilidad y operaciones invalidas.

La idea central fue que un objeto no solo guarda datos. Un objeto protege decisiones. `Book`, `User` y `BorrowedBook` representan datos con reglas minimas de validez. `LibraryService` coordina el caso de uso: agregar recursos, prestar, devolver y consultar disponibilidad.

El resultado importante no es que el sistema tenga muchas clases, sino que las reglas tienen nombres: `BookNotFoundError`, `UserNotFoundError`, `BookNotAvailableError`, `BookNotBorrowedError` y `WrongBorrowerError`. Ese vocabulario hace que el codigo explique por que una operacion no puede cumplirse.

## Objetos Del Dominio

`Book` y `User` funcionan como entidades simples: tienen identidad por `id` y atributos propios. `BorrowedBook` representa una relacion entre libro y usuario. Aunque es pequeno, tiene una responsabilidad clara: expresar que existe un prestamo activo.

La leccion transferible es que no toda clase necesita mucha logica para justificar su existencia. A veces basta con dar nombre a una relacion importante del dominio. Pero ese nombre debe reducir ambiguedad. Si una clase solo envuelve datos sin proteger ninguna regla o mejorar el lenguaje, probablemente es ruido.

## Encapsulamiento

El cambio mas importante de diseno fue ocultar detalles internos del prestamo. `borrowed?` y `find_borrowed_book` quedaron privados porque no forman parte del API que otro objeto deberia consumir.

Ese punto es clave: encapsular no significa esconder metodos por reflejo. Significa controlar que otros objetos no dependan de detalles que podrian cambiar. La biblioteca puede representar prestamos con un array hoy, con una tabla manana o con otro objeto despues. El consumidor solo deberia preguntar por disponibilidad o ejecutar comandos del dominio.

## Commands Y Queries

El lab separo metodos que preguntan de metodos que cambian estado.

Queries:

- `find_book` devuelve un libro o `nil`.
- `find_user` devuelve un usuario o `nil`.
- `book_available?` devuelve booleano.
- `available_books` devuelve una coleccion filtrada.

Commands:

- `add_book` modifica el catalogo.
- `add_user` modifica los usuarios registrados.
- `borrow_book` registra un prestamo.
- `return_book` elimina un prestamo activo.

La decision mas interesante fue `borrow_book`: cambia estado y devuelve el libro prestado. Eso lo vuelve un command-query hibrido. No es automaticamente malo, pero exige que el contrato sea explicito. Por eso el test verifica que devuelve el mismo `Book` del catalogo.

`return_book`, en cambio, quedo como comando puro de uso fluido: si tiene exito devuelve `self`. Eso evita que parezca un predicado y mantiene claro que su valor esta en el side effect: el libro vuelve a estar disponible.

## Errores De Dominio

El avance principal fue reemplazar `nil` silencioso por errores cuando un comando no puede cumplir su contrato.

Ejemplos:

- Prestar un libro inexistente levanta `BookNotFoundError`.
- Prestar con usuario inexistente levanta `UserNotFoundError`.
- Prestar un libro ya prestado levanta `BookNotAvailableError`.
- Devolver un libro no prestado levanta `BookNotBorrowedError`.
- Devolver un libro prestado por otro usuario levanta `WrongBorrowerError`.

La regla conceptual fue: una query puede devolver `nil` o booleano porque esta respondiendo una pregunta. Un comando que representa una accion de dominio puede levantar una excepcion si la accion no tiene sentido.

El riesgo a evitar es usar excepciones para flujo normal. Si la ausencia es esperada, `nil` puede ser correcto. Si una operacion prometio hacer algo y no puede hacerlo por una regla del negocio, el error de dominio comunica mejor el problema.

## Orden De Validaciones

El orden de las guardas afecto el significado del error. En `return_book`, validar primero si el usuario existe evita reportar `WrongBorrowerError` cuando el problema real es `UserNotFoundError`.

Ese detalle importa en sistemas reales porque los errores son parte del contrato. Un error impreciso obliga al consumidor a adivinar el estado del sistema. Un error preciso permite decidir si mostrar un mensaje, corregir input, registrar auditoria o detener el flujo.

## Invariantes

El lab protegio varias invariantes:

- Un libro prestado no aparece como disponible.
- Un libro no puede prestarse dos veces al mismo tiempo.
- No se puede crear un prestamo para un libro inexistente.
- No se puede crear un prestamo para un usuario inexistente.
- No se puede devolver un libro que no esta prestado.
- No puede devolver un libro alguien distinto al usuario que lo presto.

Estas reglas son mas importantes que la estructura concreta del codigo. En POO, el diseno mejora cuando las invariantes quedan cerca de los objetos que pueden romperlas.

## Tests Como Especificacion

Los tests terminaron documentando contratos, no solo comprobando resultados accidentales.

Se verificaron precondiciones:

- tipo incorrecto para `add_book`, `add_user` y `return_book`;
- libro inexistente;
- usuario inexistente;
- libro no disponible;
- prestamo inexistente;
- usuario incorrecto.

Tambien se verificaron postcondiciones:

- despues de prestar, el libro deja de estar disponible;
- despues de devolver, el libro vuelve a estar disponible;
- si la devolucion falla, el prestamo sigue activo;
- `borrow_book` devuelve el libro del catalogo;
- `return_book`, `add_book` y `add_user` devuelven `self` en exito.

La leccion es que un buen test de dominio no solo pregunta "que devuelve". Tambien pregunta "que debe seguir siendo cierto despues".

## Tradeoffs

No convertimos duplicados de `add_book` y `add_user` en errores de dominio. La razon fue pragmatica: en una aplicacion real, esa regla suele pertenecer a la capa de persistencia mediante constraints o indices unicos. En este lab podria implementarse en memoria, pero aportaria menos aprendizaje que distinguir comandos, queries, errores e invariantes.

Mantuvimos ActiveSupport para `blank?` y `present?`. En Ruby puro se podria reemplazar, pero aqui no era el foco. El criterio fue no refactorizar una dependencia aceptada por el proyecto si no mejora el concepto que estamos practicando.

## Criterios Practicos

- Usa clases cuando un concepto tenga identidad, reglas o vocabulario propio.
- No hagas publico un metodo solo porque es util internamente.
- Distingue query, predicate, command y command-query hibrido.
- Usa `nil` para ausencia esperada en consultas.
- Usa booleanos para predicados.
- Usa errores de dominio cuando un comando no puede cumplir su contrato.
- Escribe tests que cubran precondiciones, postcondiciones e invariantes.
- Evita refactors que solo cambian forma sin aclarar responsabilidad.

## Referencias Para Comprobar

- `references/ruby_functions.md`: secciones `Query`, `Finder`, `Command`, `Command-Query Hibrida`, `Predicate`, `Validator`, `Orchestrator`, `Selector Or Filter`, `Errores`, `Precondiciones`, `Postcondiciones`, `Invariantes` y `Excepciones Vs Retornos`.
- `references/ruby.md`: ideas base de Ruby, especialmente "todo es objeto", duck typing y evitar jerarquias profundas.
- `02-ruby-oop/exercises/RETROSPECTIVE.md`: conecta este lab con objetos de valor, encapsulamiento, composicion, errores de dominio y refactoring.
- Martin Fowler, `Command Query Separation`: https://martinfowler.com/bliki/CommandQuerySeparation.html
- Ruby Style Guide, no usar excepciones como control flow: https://rubystyle.guide/#no-exceptional-flows
- Martin Fowler, `Refactoring Catalog`: https://refactoring.com/catalog
- Sandi Metz, `Practical Object-Oriented Design in Ruby`: referencia para objetos pequenos, mensajes claros y dependencias limitadas.
- Avdi Grimm, `Exceptional Ruby`: referencia para pensar excepciones como parte del contrato, no como sustituto de control flow comun.

## Cierre

Este lab consolida el criterio central del modulo: POO es asignar responsabilidades y proteger reglas del dominio mediante objetos con contratos claros. El codigo quedo pequeno, pero ya expresa decisiones profesionales: API publica reducida, errores con significado, queries confiables, comandos con precondiciones y tests que verifican estado observable.
