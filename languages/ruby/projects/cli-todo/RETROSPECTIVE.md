# Retrospectiva

Este bloque practico una idea central de OOP: separar modelo de dominio, persistencia e interfaz. `TodoItem` y `TodoList` representan reglas del problema; `TodoJsonStore` representa IO; `TodoCLI` traduce argumentos de consola a operaciones del dominio. Esa separacion evita que decisiones externas, como JSON o rutas de archivo, contaminen las reglas principales.

Un aprendizaje importante fue distinguir identidad de posicion o tamano de coleccion. Al pasar a UUID, dejamos de depender de `@items.size` y evitamos que borrar elementos afecte la generacion de identidad. Esto conecta con el criterio general de entidades: dos objetos pueden tener el mismo titulo, pero no ser la misma tarea. Ruby provee `SecureRandom.uuid` para generar identificadores sin coordinar estado incremental manualmente: https://docs.ruby-lang.org/en/master/SecureRandom.html.

Tambien aparecio la tension entre comandos y consultas. Metodos como `pending_items`, `completed_items`, `find` y `to_a` son consultas; metodos como `complete`, `remove`, `rename` y `reopen` cambian estado. La idea viene de Command-Query Separation, popularizada por Bertrand Meyer y discutida por Martin Fowler: https://martinfowler.com/bliki/CommandQuerySeparation.html. Nosotros fuimos pragmaticos: varios comandos devuelven el item afectado para que la CLI pueda imprimir una respuesta util. Es una desviacion consciente, no accidental.

La persistencia quedo como una frontera. `to_h`, `from_h`, `to_json` y `from_json` convierten entre objetos y datos; `TodoJsonStore` decide leer y escribir archivos. Esa frontera es parecida al objetivo del patron Repository, que Fowler describe como una separacion entre dominio y persistencia, aunque aqui el nombre `Store` fue mejor por ser mas concreto para JSON: https://martinfowler.com/eaaCatalog/repository.html. Para JSON usamos la stdlib, con `JSON.generate` y `JSON.parse`: https://docs.ruby-lang.org/en/master/JSON.html.

En tests, el avance fue pasar de ejemplos repetitivos a contexts con fixtures explicitos. Usar `let` para nombres compartidos y `before` para preparar estado hizo que los specs leyeran mas como escenarios. La regla util: `let` nombra datos, `before` ejecuta acciones de preparacion. RSpec documenta `let` como helper memoizado por example y los hooks como preparacion y limpieza alrededor de ejemplos: https://rspec.toolboxforweb.xyz/docs/rspec-core/helper_methods/let y https://rspec.info/documentation/3.8/rspec-core/RSpec/Core/Hooks.html.

RuboCop funciono como presion de diseno, no solo como formato. Cuando `TodoCLI` crecio, los cops de longitud nos obligaron a extraer validacion y mutaciones repetidas. El criterio sano no es obedecer ciegamente, sino escuchar la senal: si una clase empieza a crecer por comandos, tal vez pronto necesite objetos comando o un parser real. RuboCop se apoya en la guia comunitaria de estilo Ruby: https://github.com/rubocop/ruby-style-guide.

Aprendizajes transferibles:

- Cuando una regla pertenece al dominio, ponla cerca del objeto que protege.
- Cuando algo toca filesystem, red, consola o JSON, tratalo como frontera.
- Los errores de dominio deben expresar el problema real, no accidentes como `NoMethodError`.
- Los specs deben documentar comportamiento, no solo ejecutar lineas.
- No refactorices por abstraccion futura; refactoriza cuando la repeticion o el acoplamiento ya esten haciendo ruido.

El siguiente riesgo conceptual a vigilar es que `TodoCLI` siga creciendo. Un comando mas todavia esta bien; varios mas podrian justificar extraer comandos individuales o introducir `OptionParser`.
