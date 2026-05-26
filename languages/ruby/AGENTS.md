# Instrucciones Para El Programa Ruby

## Ritmo De Trabajo

- Trabajar paso a paso; no implementar módulos completos de una sola vez.
- Antes de escribir cualquier test o código para un ejercicio, proponer el siguiente micro-paso y esperar confirmación.
- Cada micro-paso debe indicar qué concepto de Ruby se va a repasar, por ejemplo: objetos de valor, encapsulamiento, igualdad, validación o errores.
- Priorizar ejercicios pequeños que el usuario pueda repasar, ejecutar y modificar.
- Explicar brevemente el objetivo del paso antes de mostrar o escribir la solución.
- Mantener cambios mínimos y verificables.
- No avanzar al siguiente punto hasta que el usuario indique que está listo.
- Si aparece una corrección, resolverla en el paso actual antes de abrir otro tema.

## TDD

- Preferir TDD para ejercicios y labs: primero escribir o proponer un test pequeño; luego implementar el mínimo código para hacerlo pasar.
- No adelantar toda la solución; avanzar en ciclos cortos de rojo, verde y refactor.
- Si el usuario está aprendiendo un concepto nuevo, explicar el test antes de escribir la implementación.
- Para ejercicios de repaso, no escribir el test automáticamente; primero mostrar el test propuesto o describirlo y pedir confirmación.
- Ejecutar el test relevante después de cada cambio de comportamiento.
- Ejecutar RuboCop después de cerrar un bloque pequeño de trabajo, no antes de que el comportamiento esté claro.

## Flujo De Sesión

- Revisar el punto actual del roadmap o checklist antes de crear archivos nuevos.
- Crear plantillas pequeñas cuando el usuario vaya a implementar la solución.
- Revisar el código escrito por el usuario antes de proponer el siguiente paso.
- Cuando el objetivo sea repasar Ruby, priorizar preguntas guiadas y explicaciones cortas por encima de implementaciones completas.
- Si el usuario dice "continuemos" o algo similar, interpretar que quiere seguir el flujo pedagógico, no que quiere que se escriba código sin confirmación.
- Señalar bugs conceptuales aunque el código corra, por ejemplo: mezclar excepciones con `valid?` o usar defaults mutables en hashes.
- Preferir una corrección mínima antes que reescribir el ejercicio completo.
- Cerrar cada módulo con tests, RuboCop, checklist y una retrospectiva breve.

## Retrospectivas

- Redactar retrospectivas como síntesis conceptual, no como changelog del código escrito.
- Priorizar teoría general, principios de diseño y vocabulario profesional por encima de detalles puntuales de archivos, clases o métodos.
- Conectar lo practicado con ideas de libros, katas o referencias investigadas cuando aplique, por ejemplo objetos de valor, composición, encapsulamiento, refactoring, responsabilidades y errores de dominio.
- Mencionar ejemplos del código solo cuando ayuden a ilustrar una idea general; evitar enumerar todos los cambios implementados.
- Incluir aprendizajes transferibles: qué criterio usar, qué tradeoff apareció, qué señal indica que conviene refactorizar y qué riesgo conceptual evitar.
