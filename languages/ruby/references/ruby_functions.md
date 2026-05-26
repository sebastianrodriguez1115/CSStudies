# Ruby Functions And Methods

## Idea Central

Una funcion o metodo es una unidad de diseno. No solo agrupa codigo: define una responsabilidad, un contrato, una relacion con el estado y una forma de manejar errores.

En Ruby hablamos mucho de metodos porque casi todo comportamiento vive en objetos, pero los mismos criterios aplican a funciones de modulo, lambdas, bloques y helpers.

Una buena funcion debe poder nombrarse con claridad. Si el nombre honesto necesita decir "y", probablemente hay mas de una responsabilidad.

## Tipos De Funciones

### Query

Pregunta algo y devuelve informacion sin cambiar estado observable.

```ruby
def book_available?(book_id)
  !borrowed?(book_id)
end
```

Criterios:

- Devuelve informacion.
- No muta estado.
- Puede llamarse varias veces sin cambiar el sistema.
- Es segura para usar en condiciones, assertions y validaciones.

Ejemplos comunes:

- `available?`
- `borrowed?`
- `total`
- `count`

#### Finder

Un finder es una query especializada: busca algo y puede devolver el objeto encontrado o `nil` si no existe.

```ruby
def find_book(book_id)
  @books.find { |book| book.id == book_id }
end
```

Convenciones utiles:

- `find_*`: puede devolver objeto o `nil`.
- `fetch_*`: sugiere que el valor debe existir o que hay default/error.
- `get_*`: depende del equipo; puede ser ambiguo en Ruby.

### Command

Ordena una accion y normalmente cambia estado.

```ruby
def add_book(book)
  @books << book
end
```

Criterios:

- Cambia estado observable.
- Representa una accion del dominio.
- Puede tener precondiciones.
- Puede fallar si la operacion no tiene sentido.

Ejemplos comunes:

- `add_book`
- `borrow_book`
- `return_book`
- `save`
- `delete`

### Command-Query Hibrida

Cambia estado y devuelve informacion.

```ruby
def borrow_book(book_id, user_id)
  @borrowed_books << BorrowedBook.new(book_id, user_id)
  find_book(book_id)
end
```

No siempre esta mal, pero exige cuidado. Puede ser practico devolver el recurso afectado, pero el metodo debe seguir siendo claro. Si el retorno confunde el contrato, separa el comando de la consulta.

### Pure Function

Para el mismo input, siempre devuelve el mismo output y no produce side effects.

```ruby
def points_for(audience, play_type)
  points = 0
  points += audience - 30 if audience > 30
  points += audience.div(5) if play_type == 'comedy'
  points
end
```

Beneficios:

- Facil de testear.
- Facil de razonar.
- No depende de estado oculto.
- No modifica argumentos ni variables externas.

### Impure Function

Depende de estado externo o modifica algo fuera de si misma.

```ruby
def add_user(user)
  @users << user
end
```

No es necesariamente mala. Todo programa real necesita side effects. La regla practica es aislarlos y hacerlos obvios.

### Predicate

Devuelve booleano. En Ruby suele terminar en `?`.

```ruby
def borrowed?(book_id)
  @borrowed_books.any? { |borrowed_book| borrowed_book.book_id == book_id }
end
```

Un predicado deberia ser una query. Si un metodo terminado en `?` cambia estado, sorprende al lector.

### Validator

Verifica reglas.

Estilo booleano:

```ruby
def valid?
  errors.empty?
end
```

Estilo estricto:

```ruby
def validate!
  raise InvalidRecordError unless valid?
end
```

Para validaciones comunes de usuario, suele ser mejor acumular errores. Para comandos que no pueden cumplir su contrato, una excepcion de dominio puede ser razonable.

### Transformer

Convierte datos de una forma a otra.

```ruby
def normalize_currency(currency)
  currency.strip.upcase
end
```

Idealmente es pura: recibe input explicito y devuelve nuevo output sin mutar.

Subtipos comunes:

- Formatter: dato interno a texto o representacion visual.
- Parser: texto o input externo a dato interno.
- Serializer: objeto interno a JSON, hash o formato transportable.
- Normalizer: dato sucio o irregular a dato limpio.
- Mapper: estructura A a estructura B.

#### Formatter

Convierte valores a representacion.

```ruby
def format_money(cents)
  ActiveSupport::NumberHelper.number_to_currency(cents / 100.0)
end
```

Un formatter no deberia contener reglas de dominio. Su responsabilidad es presentacion.

### Factory Or Builder

Crea objetos.

```ruby
def build_borrowed_book(book_id, user_id)
  BorrowedBook.new(book_id, user_id)
end
```

Es util cuando la construccion tiene reglas, defaults o dependencias.

### Aggregator Or Reducer

Calcula un resultado desde una coleccion.

```ruby
def total_amount(items)
  items.sum(&:subtotal)
end
```

Debe revelar que se esta agregando y con que criterio.

### Selector Or Filter

Elige un subconjunto.

```ruby
def available_books
  @books.reject { |book| borrowed?(book.id) }
end
```

Si no necesita mutar, preferir `select` o `reject` sobre `delete_if`.

### Mutator

Cambia estado interno.

```ruby
def mark_as_paid!
  @paid = true
end
```

En Ruby, `!` no significa siempre mutacion, pero comunica una version mas peligrosa, estricta o sorprendente. Usarlo solo cuando aporta informacion real.

### Hook Method

Metodo pensado para que una clase concreta lo sobrescriba.

```ruby
def payable?
  true
end
```

Los hook methods son utiles en modulos y herencia, pero el contrato debe ser claro. Si el modulo depende de detalles internos de una clase especifica, no hay abstraccion real.

### Template Method

Define un flujo general y delega algunos pasos.

```ruby
def pay!
  raise NotPayableError unless payable?

  @paid = true
  self
end
```

El metodo principal controla el flujo. Los hooks permiten adaptar decisiones.

### Higher-Order Function

Recibe o devuelve funciones, lambdas o bloques.

```ruby
def each_book
  @books.each { |book| yield book }
end
```

En Ruby aparece constantemente con `map`, `select`, `reject`, `reduce`, `each` y bloques.

### Orchestrator

Coordina varios pasos de un caso de uso.

```ruby
def borrow_book(book_id, user_id)
  ensure_book_exists!(book_id)
  ensure_user_exists!(user_id)
  ensure_book_available!(book_id)

  register_borrow(book_id, user_id)
end
```

Debe leer como una historia de alto nivel. Si contiene todos los detalles, se vuelve un metodo largo en vez de un coordinador.

### Boundary Function

Habla con el mundo externo: base de datos, archivo, HTTP, consola, reloj, random, email.

```ruby
def save!
  repository.save(self)
end
```

Son funciones impuras. Conviene mantenerlas cerca del borde del sistema.

## Criterios De Diseno

### Responsabilidad

Una funcion debe tener una responsabilidad principal. Si hace dos cosas independientes, separalas.

Mal:

```ruby
def borrow_book_and_send_email
end
```

Mejor:

```ruby
def borrow_book
end

def send_borrowing_email
end
```

### Nivel De Abstraccion

No mezcles detalle bajo con pasos de alto nivel en el mismo metodo.

Mejor que el metodo publico cuente la historia:

```ruby
def borrow_book(book_id, user_id)
  ensure_user_exists!(user_id)
  ensure_book_available!(book_id)
  register_borrow(book_id, user_id)
end
```

Y que los detalles vivan en metodos privados.

### Nombre

El nombre debe revelar intencion.

Mal:

```ruby
def process(data)
end
```

Mejor:

```ruby
def calculate_late_fee(loan)
end
```

Convenciones Ruby:

- `?` para booleanos.
- `!` para version peligrosa o estricta.
- `find_` cuando puede no existir.
- `fetch_` cuando debe existir o hay default/error.
- `build_` para construir sin persistir.
- `create_` para crear y registrar/persistir.

### Inputs

Pocos argumentos suelen ser mas claros. Con muchos argumentos, considera keyword arguments u objeto parametro.

```ruby
def initialize(id:, title:, author:)
end
```

Evita pasar hashes profundos a objetos internos si puedes pasar conceptos explicitos.

Mal:

```ruby
PerformanceSummary.new(play: play_hash, performance: performance_hash)
```

Mejor:

```ruby
PerformanceSummary.new(
  play_name: play[:name],
  play_type: play[:type],
  audience: performance[:audience]
)
```

### Output

El retorno debe ser predecible. Evita mezclar muchos tipos.

Mal:

```ruby
def borrow_book(book_id, user_id)
  return false if missing_user
  return nil if missing_book
  return book if success
end
```

Mejor escoger una politica:

- Devuelve objeto o `nil`.
- Devuelve objeto o levanta excepcion.
- Devuelve un `Result`.

### Side Effects

Hazlos visibles. No escondas mutaciones en nombres que suenan como consultas.

Side effects comunes:

- Modificar variables de instancia.
- Escribir base de datos.
- Hacer HTTP.
- Imprimir o loggear.
- Leer hora actual.
- Usar random.
- Enviar email.

### Errores

Escoge una estrategia consistente.

- `nil`: ausencia esperada.
- `true` o `false`: predicados.
- `errors`: validacion acumulada.
- `Result`: exito/falla como valor.
- Excepcion: contrato roto u operacion invalida.

Regla practica:

- Consulta que no encuentra: `nil`.
- Predicado: booleano.
- Validacion de formulario: errores acumulados.
- Comando de dominio que no puede cumplirse: excepcion de dominio puede ser razonable.

### Precondiciones

Lo que debe ser cierto antes de ejecutar.

```ruby
raise InvalidBookError unless book.is_a?(Book)
```

Ejemplos:

- El objeto tiene el tipo esperado.
- El recurso existe.
- El usuario existe.
- La operacion esta permitida.

### Postcondiciones

Lo que debe ser cierto despues de ejecutar.

Despues de prestar un libro:

- El libro ya no esta disponible.
- Existe un prestamo activo.
- El prestamo pertenece al usuario correcto.

Los tests buenos prueban postcondiciones, no solo retornos.

### Invariantes

Reglas que siempre deben mantenerse.

Ejemplos:

- Un libro no puede estar prestado dos veces.
- Un prestamo siempre referencia un libro registrado.
- Un prestamo siempre referencia un usuario registrado.
- Un libro disponible no tiene prestamo activo.

### Idempotencia

Una funcion idempotente puede llamarse varias veces y producir el mismo efecto que una sola llamada.

```ruby
def mark_as_returned
  @returned = true
end
```

No idempotente:

```ruby
def increment_renewal_count
  @renewal_count += 1
end
```

La idempotencia importa mucho en APIs, jobs, pagos y comandos repetibles.

### Determinismo

Una funcion determinista devuelve lo mismo para el mismo input.

No determinista:

```ruby
def generate_id
  SecureRandom.uuid
end
```

Si necesitas testearla, considera inyectar la dependencia.

### Acoplamiento

Una funcion esta acoplada a todo lo que conoce. Mientras mas estructuras internas conozca, mas fragil es.

Mal:

```ruby
def calculate(data)
  data[:play][:metadata][:type]
end
```

Mejor:

```ruby
def calculate(play_type:, audience:)
end
```

### Ubicacion

Una funcion debe vivir cerca de los datos y reglas que usa.

Criterios:

- Si usa principalmente datos de un objeto, probablemente pertenece a ese objeto.
- Si coordina varios objetos, puede ser un service.
- Si transforma input externo, puede ser un adapter o parser.
- Si es presentacion, no debe vivir en el dominio.
- Si es regla del dominio, no debe vivir en UI o controller.

## Excepciones Vs Retornos

No uses excepciones para flujo normal. Ruby Style Guide lo dice explicitamente: no usar exceptions como control flow.

Pero una excepcion de dominio puede ser correcta cuando un comando no puede cumplir su contrato.

Ejemplo razonable:

```ruby
def borrow_book(book_id, user_id)
  raise UserNotFoundError unless find_user(user_id)
  raise BookNotAvailableError unless book_available?(book_id)

  register_borrow(book_id, user_id)
end
```

Ejemplo menos recomendable:

```ruby
def book_available?(book_id)
  raise BookNotFoundError unless find_book(book_id)
end
```

Un predicado deberia responder una pregunta. Si empieza a lanzar excepciones para casos esperados, deja de ser una query confiable.

## Result Object

Alternativa a exceptions cuando la falla es esperada.

```ruby
Result = Data.define(:success?, :value, :error)
```

Uso conceptual:

```ruby
result = library.borrow_book(book_id, user_id)

if result.success?
  result.value
else
  result.error
end
```

Es util cuando quieres hacer explicitas las fallas sin interrumpir el flujo con exceptions.

## Notification Pattern

Para validaciones con multiples errores, acumular errores puede ser mejor que lanzar la primera excepcion.

```ruby
notification.add(:title_blank)
notification.add(:author_blank)
```

Esto evita el problema de "arreglar un error, enviar de nuevo, encontrar otro".

## Checklist Para Disenar Una Funcion

- Que responsabilidad tiene?
- Es command o query?
- Tiene side effects?
- Que devuelve exactamente?
- Puede devolver mas de un tipo?
- Que errores puede producir?
- Sus argumentos son explicitos?
- Esta acoplada a hashes o estructuras externas?
- Que precondiciones necesita?
- Que postcondiciones garantiza?
- Mantiene invariantes?
- Es facil de testear?
- Vive en el objeto correcto?
- Su nombre dice la verdad?

## Referencias

- Martin Fowler, `Command Query Separation`: https://martinfowler.com/bliki/CommandQuerySeparation.html
- Martin Fowler, `Notification`: https://martinfowler.com/eaaDev/Notification.html
- Martin Fowler, `Replacing Throwing Exceptions with Notification`: https://martinfowler.com/articles/replaceThrowWithNotification.html
- Martin Fowler, `Refactoring Catalog`: https://refactoring.com/catalog
- Ruby Style Guide, exceptions: https://rubystyle.guide/#no-exceptional-flows
- Sandi Metz, `Practical Object-Oriented Design in Ruby`.
- Robert C. Martin, `Clean Code`.
- Steve McConnell, `Code Complete`.
- Bertrand Meyer, `Object-Oriented Software Construction`.
- Avdi Grimm, `Exceptional Ruby`.
- Eric Normand, `Grokking Simplicity`.
