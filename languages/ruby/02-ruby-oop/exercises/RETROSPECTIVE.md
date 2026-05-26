# Retrospective

## Sintesis

Esta seccion trabajo la idea central de la programacion orientada a objetos: organizar comportamiento alrededor de conceptos del dominio, no solo agrupar datos y funciones. La meta no fue crear muchas clases, sino aprender a reconocer cuando una regla, una identidad conceptual o una responsabilidad merecen un nombre propio.

El hilo principal fue pasar de valores simples y reglas locales hacia colaboraciones entre objetos. Esa progresion importa porque POO no se entiende bien si se empieza por herencia o patrones. Primero hay que distinguir valor, entidad, responsabilidad, estado, contrato y colaboracion.

## Objetos De Valor

Un objeto de valor representa una cantidad o concepto que se compara por sus atributos, no por identidad. Esta idea aparece en diseno de dominio y tambien en estilos de Ruby idiomatico: un valor debe ser pequeno, predecible y seguro de compartir.

El criterio importante es que las operaciones sobre valores no deberian sorprender. Si una suma o resta modifica el objeto original, el codigo se vuelve mas dificil de razonar. Por eso la inmutabilidad o al menos el comportamiento no mutante suele ser una buena direccion para objetos como dinero, fechas, rangos o medidas.

## Encapsulamiento

Encapsular no significa esconder todo por costumbre. Significa proteger invariantes: reglas que deben mantenerse verdaderas para que el objeto sea valido. Un objeto bien encapsulado no expone detalles internos que permitan dejarlo en un estado incoherente.

La pregunta util no es "que atributos tiene esta clase", sino "que decisiones debe controlar este objeto". Si otro objeto necesita manipular directamente sus datos internos, probablemente la responsabilidad esta mal ubicada o falta un metodo con un nombre del dominio.

## Composicion

La composicion aparecio como alternativa natural a clases grandes. En vez de tener un objeto que sabe todo, se distribuyen reglas entre objetos mas pequenos que colaboran. Esta idea esta cerca de los consejos de Sandi Metz en `Practical Object-Oriented Design in Ruby`: objetos pequenos, mensajes claros y dependencias limitadas.

El tradeoff es que demasiada composicion prematura tambien puede empeorar el diseno. Una senal sana para extraer un objeto es encontrar una responsabilidad estable: una regla que ya tiene vocabulario propio, se repite, o hace que el metodo actual mezcle niveles de abstraccion.

## Modulos Y Contratos

Los modulos en Ruby permiten compartir comportamiento sin usar herencia. Pero un modulo tambien crea un contrato implicito: espera que la clase que lo incluye tenga o respete ciertas capacidades.

La leccion importante fue separar comportamiento generico de reglas concretas. Un modulo puede definir el flujo comun y permitir que la clase concreta refine una decision mediante un hook method. Esto evita que el modulo conozca detalles de cada clase que lo usa.

El riesgo conceptual es crear modulos que parecen reutilizables pero en realidad dependen de datos internos de una sola clase. En ese caso no hay abstraccion real, solo acoplamiento disfrazado.

## Errores De Dominio

Los errores propios sirven cuando el fallo expresa una regla del negocio, no solo un problema tecnico. Esta distincion es importante para no llenar el codigo de excepciones personalizadas que no agregan significado.

Un `TypeError` comunica bien un contrato tecnico: se recibio un objeto del tipo incorrecto. Un error de dominio comunica otra cosa: la operacion no tiene sentido dentro de las reglas del problema. Esa diferencia ayuda a leer el codigo y tambien ayuda a quien consume la API a capturar errores con intencion.

El criterio transferible es este: si el nombre del error mejora el lenguaje del dominio, probablemente vale la pena. Si solo renombra un error generico sin agregar significado, probablemente es ruido.

## Refactoring

El ejercicio de refactoring siguio una idea central de Martin Fowler: cambiar la estructura del codigo sin cambiar su comportamiento observable. Por eso primero se necesita una red de seguridad. Los tests de caracterizacion no buscan disenar la solucion perfecta; buscan congelar lo que el sistema ya hace para poder mover piezas con confianza.

Tambien aparecio una leccion clasica de `Refactoring`: extraer no significa automaticamente mejorar. Un hash intermedio puede sugerir que falta un objeto, pero el objeto nuevo debe reducir acoplamiento o aclarar una responsabilidad. Si solo envuelve la misma estructura externa, puede empeorar el diseno.

La mejora real vino al pasar de datos crudos a conceptos explicitos. Un objeto que recibe datos del dominio mediante parametros claros depende menos de la forma externa del input. Esa separacion deja al adaptador cerca del borde del sistema y mantiene las reglas en objetos mas estables.

## Criterios Practicos

- Extrae un objeto cuando encuentres una responsabilidad con nombre propio.
- Prefiere composicion cuando una clase empieza a mezclar reglas de distintos niveles.
- Usa modulos para comportamiento compartido, no para esconder dependencias concretas.
- Usa errores propios cuando expresen reglas del dominio.
- Mantén los datos externos cerca del borde; no dejes que toda la aplicacion dependa de la forma de un hash.
- Refactoriza en pasos pequenos y verifica despues de cada cambio.

## Riesgos A Evitar

- Crear clases solo para cumplir con "hacer POO".
- Convertir cada helper en un objeto sin una responsabilidad clara.
- Confundir encapsulamiento con getters y setters para todo.
- Pasar hashes completos a objetos profundos y acoplarlos a estructuras externas.
- Usar excepciones propias para errores que Ruby ya comunica bien.
- Refactorizar sin tests que protejan el comportamiento.

## Cierre

Esta seccion deja una base practica para el lab: modelar reglas con objetos pequenos, mantener contratos claros y refactorizar cuando el codigo muestra una responsabilidad escondida. El siguiente paso deberia usar estas ideas en un dominio menos guiado, donde haya que decidir que objetos existen y que reglas pertenecen a cada uno.
