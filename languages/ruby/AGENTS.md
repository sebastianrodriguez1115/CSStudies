# Instrucciones Para El Programa Ruby

## Ritmo De Trabajo

- Trabajar paso a paso, no implementar modulos completos de una sola vez.
- Antes de escribir codigo amplio, proponer el siguiente micro-paso y esperar confirmacion.
- Priorizar ejercicios pequenos que el usuario pueda repasar, ejecutar y modificar.
- Explicar brevemente el objetivo del paso antes de mostrar o escribir la solucion.
- Mantener cambios minimos y verificables.
- No avanzar al siguiente punto hasta que el usuario indique que esta listo.
- Si aparece una correccion, resolverla sobre el paso actual antes de abrir otro tema.

## TDD

- Preferir TDD para ejercicios y labs: primero escribir o proponer un test pequeno, luego implementar el minimo codigo para hacerlo pasar.
- No adelantar toda la solucion: avanzar en ciclos cortos de rojo, verde y refactor.
- Si el usuario esta aprendiendo un concepto nuevo, explicar el test antes de escribir la implementacion.
- Ejecutar el test relevante despues de cada cambio de comportamiento.
- Ejecutar RuboCop despues de cerrar un bloque pequeno de trabajo, no antes de que el comportamiento este claro.

## Flujo De Sesion

- Revisar el punto actual del roadmap o checklist antes de crear archivos nuevos.
- Crear plantillas pequenas cuando el usuario vaya a implementar la solucion.
- Revisar el codigo escrito por el usuario antes de proponer el siguiente paso.
- Senalar bugs conceptuales aunque el codigo corra, por ejemplo mezclar excepciones con `valid?` o usar defaults mutables en hashes.
- Preferir una correccion minima sobre reescribir el ejercicio completo.
- Cerrar cada modulo con tests, RuboCop, checklist y retrospectiva breve.
