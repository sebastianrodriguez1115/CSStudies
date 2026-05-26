# Statement Refactor

Inspirado en el ejemplo de `statement` de Martin Fowler en `Refactoring`, 2nd edition. Esta version es reducida para practicar POO sin copiar toda la kata original.

## Objetivo

Refactorizar una funcion procedural que genera el estado de cuenta de una compania teatral hacia objetos pequenos y con responsabilidades claras.

No buscamos escribir muchas clases. Buscamos descubrirlas cuando el codigo lo pida.

## Dominio

Una compania teatral factura funciones a clientes.

Datos principales:

- `invoice`: cliente y lista de funciones vendidas.
- `plays`: catalogo de obras.
- `performance`: obra vendida y cantidad de asistentes.

Tipos de obra:

- `tragedy`
- `comedy`

## Reglas

Montos en centavos:

- Tragedia: base `40_000`.
- Tragedia con mas de 30 asistentes: sumar `1_000` por asistente extra.
- Comedia: base `30_000`.
- Comedia con mas de 20 asistentes: sumar `10_000` mas `500` por asistente extra.
- Comedia siempre suma `300` por asistente.

Puntos:

- Cada funcion gana `audience - 30` puntos si la audiencia supera 30.
- Cada comedia gana puntos extra: `audience / 5` usando division entera.

## Output Esperado

Para este input:

```ruby
plays = {
  'hamlet' => { name: 'Hamlet', type: 'tragedy' },
  'as-like' => { name: 'As You Like It', type: 'comedy' }
}

invoice = {
  customer: 'BigCo',
  performances: [
    { play_id: 'hamlet', audience: 55 },
    { play_id: 'as-like', audience: 35 }
  ]
}
```

El resultado debe ser:

```text
Statement for BigCo
  Hamlet: $650.00 (55 seats)
  As You Like It: $580.00 (35 seats)
Amount owed is $1,230.00
You earned 37 points
```

## Restricciones

- Empezar con una funcion procedural `statement(invoice, plays)`.
- Primero escribir tests que congelen el comportamiento.
- Refactorizar en pasos pequenos.
- No cambiar el output mientras se refactoriza.
- No crear clases hasta que una responsabilidad se vea clara.
- Mantener los hashes como input externo durante el ejercicio.

## Micro-pasos Sugeridos

1. Crear `statement_test.rb` con el output exacto del ejemplo.
2. Crear `statement.rb` con una implementacion procedural simple.
3. Extraer metodos privados para `amount_for`, `points_for` y `format_money`.
4. Introducir un objeto para representar el calculo de una performance.
5. Mover el calculo de monto y puntos a ese objeto.
6. Separar la generacion del texto del calculo.
7. Revisar si el resultado realmente mejoro o si solo agrego nombres.

## Criterio De Cierre

- Tests verdes.
- RuboCop sin offenses.
- Puedes explicar que responsabilidad tiene cada objeto creado.
- Puedes explicar que partes quedaron como datos externos y por que.
