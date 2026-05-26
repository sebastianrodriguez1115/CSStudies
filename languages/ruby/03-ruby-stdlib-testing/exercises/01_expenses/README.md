# Expenses

Ejercicio pequeño para practicar libreria estandar, ActiveSupport y Minitest.

## Objetivo

Convertir gastos desde CSV a objetos Ruby, validar invariantes del dominio y exportar los datos a JSON y HTML.

## Archivos

- `expense.rb`: objeto de dominio con validaciones y `to_h`.
- `expense_importer.rb`: importa gastos desde CSV.
- `expense_exporter.rb`: exporta gastos a JSON.
- `expense_report.rb`: genera una tabla HTML con ERB.
- `fixtures/expenses.csv`: datos de prueba.
- `expense_suite_test.rb`: corre todos los tests del ejercicio.

## Comandos

```bash
bundle exec ruby expense_suite_test.rb
bundle exec rubocop 03-ruby-stdlib-testing/exercises/01_expenses
```
