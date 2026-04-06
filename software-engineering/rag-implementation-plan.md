# Plan de Implementación: Sistema RAG Basado en Punteros (Agentic RAG)

## Objetivo
Construir un motor de búsqueda semántica local que permita al asistente de IA encontrar conceptos clave dentro de una biblioteca extensa de PDFs (libros de ingeniería de software). El sistema debe devolver no solo el fragmento de texto relevante, sino "coordenadas" precisas (archivo, página, número de línea) para que el asistente pueda leer el contexto original completo según sea necesario.

**Restricción de idioma:** El sistema está diseñado exclusivamente para fuentes en inglés. Los modelos de embeddings seleccionados están optimizados para este idioma.

## Pila Tecnológica
*   **Lenguaje:** Python 3.10+
*   **Base de Datos Vectorial:** ChromaDB (Persistente localmente). Se elige sobre FAISS por su soporte nativo para metadatos ricos y persistencia sin configuración adicional.
*   **Procesamiento de PDF:** `PyMuPDF` (conocido como `fitz`). Es extremadamente rápido y permite extraer texto manteniendo la noción de páginas y bounding boxes. Se usa su capacidad de distinguir bloques de texto vs. imágenes para descartar gráficas y diagramas durante la extracción.
*   **Modelo de Embeddings:** `sentence-transformers/all-mpnet-base-v2` (Vía HuggingFace). Ofrece mejor calidad que MiniLM para texto técnico en inglés, manteniendo ejecución local sin costos de API.

## Estructura del Proyecto

Se creará un nuevo directorio `src/rag/` para aislar la lógica del motor de búsqueda del resto de los documentos.

```text
/Users/juansrodriguez/Documents/CSStudies/software-engineering/
├── fuentes/
│   └── *.pdf (Libros)
└── src/
    └── rag/
        ├── requirements.txt      # Dependencias del proyecto
        ├── ingest_pdfs.py        # Script para poblar la base de datos
        ├── query_db.py           # CLI para realizar búsquedas
        └── chroma_db/            # (Generado automáticamente) Base de datos persistente
```

## Fases de Implementación

### Fase 1: Configuración del Entorno
1.  Crear el entorno virtual de Python (`venv`).
2.  Instalar dependencias necesarias (`chromadb`, `PyMuPDF`, `sentence-transformers`, `tqdm` para barras de progreso).
3.  Crear el archivo `requirements.txt`.
4.  Configurar `.gitignore` con: `chroma_db/`, `venv/`, `__pycache__/`, `.env`.

### Fase 2: Extracción y Chunking (`ingest_pdfs.py`)
El núcleo del sistema. Este script procesará cada PDF en la carpeta `fuentes/`.

**Lógica de Extracción:**
*   Usar PyMuPDF para extraer texto página por página.
*   **Filtrado de contenido:** Descartar bloques de tipo imagen (gráficas, diagramas). Aceptar que las tablas se extraerán como texto desordenado en esta versión — una mejora futura puede incorporar `pdfplumber` para extracción estructurada de tablas.

**Estrategia de Chunking:**
*   Tamaño objetivo por chunk: **~500-800 tokens**.
*   **Overlap entre chunks:** ~100-150 tokens para no perder contexto en los bordes entre fragmentos.
*   Si una página completa cabe en un solo chunk, se mantiene como unidad. Si excede el tamaño objetivo, se divide respetando límites de párrafo cuando sea posible.

**Metadatos por Chunk:**
*   `source_file`: Nombre del archivo PDF (ej. `2022-system-design-interview-vol-2-alex-xu.pdf`).
*   `page_number`: Número de página en el PDF (1-indexed).
*   `chunk_index`: Orden del chunk dentro de la página.

**Esquema de ChromaDB:**
*   Colección: `software_engineering_books`.
*   IDs únicos generados combinando nombre del archivo, número de página y chunk index.

**Lógica de Skip:**
*   Antes de procesar un PDF, verificar si ya existen documentos en la colección con ese `source_file`.
*   Si ya existen, saltar el archivo y notificar al usuario.
*   Para forzar re-ingesta de un archivo específico, se puede eliminar sus entradas de la colección primero.

### Fase 3: Motor de Consulta (`query_db.py`)
Un script de línea de comandos que tomará una pregunta del usuario y buscará en ChromaDB.

**Flujo de Consulta:**
1.  Recibir argumento de búsqueda (ej. `python src/rag/query_db.py "stateless architecture advantages"`).
2.  Convertir la consulta a vector usando el mismo modelo de embeddings.
3.  Consultar ChromaDB solicitando los Top-K resultados (ej. `k=5`).
4.  **Formato de Salida (Crítico para el Agente):** El script debe imprimir los resultados en un formato JSON estructurado que el agente de IA pueda parsear fácilmente para decidir su próxima acción.

Ejemplo de salida esperada:
```json
[
  {
    "text": "In a stateless architecture, user session data is not stored on the web servers...",
    "file": "fuentes/2022-system-design-interview-vol-2-alex-xu.pdf",
    "page": 15,
    "distance": 0.85
  }
]
```

### Fase 4: Integración con el Flujo del Agente (El "Twist")
1.  El usuario hace una pregunta conceptual compleja.
2.  El agente ejecuta `query_db.py` vía la herramienta `run_shell_command`.
3.  El agente analiza el JSON devuelto.
4.  Si el fragmento (`text`) es suficiente, responde.
5.  Si requiere más contexto, el agente utiliza su conocimiento de la `page` y el `file` devueltos para invocar una herramienta que extraiga esa página específica del PDF original para una lectura profunda antes de responder.

### Fase 5 (Futura): Reranking con Cross-Encoder
Mejora de precisión post-búsqueda usando un modelo cross-encoder.

**Concepto:** La búsqueda vectorial es rápida pero aproximada — compara representaciones comprimidas del texto. Un cross-encoder evalúa la relevancia real tomando el par (query, resultado) como entrada conjunta, produciendo un score mucho más preciso.

**Flujo con reranking:**
1.  Búsqueda vectorial devuelve top-10 candidatos.
2.  Cross-encoder (`cross-encoder/ms-marco-MiniLM-L-6-v2`) re-evalúa cada par (query, candidato).
3.  Se re-ordenan por score del cross-encoder.
4.  Se devuelven los top-3 al usuario.

**Por qué no desde el inicio:** Agrega una dependencia más y complejidad al pipeline. Primero validar que la búsqueda vectorial base es útil, luego mejorar precisión.

## Consideraciones Adicionales y Limitaciones Conocidas
*   **Precisión de Línea vs. Página:** Extraer números de línea exactos de un PDF es notoriamente inestable debido a cómo se codifican los PDFs (cajas de texto en lugar de flujo continuo). Como compromiso inicial, indexaremos a nivel de **página**. Saber en qué página de qué PDF está un concepto es suficiente granularidad para que el agente extraiga esa página y la lea completa.
*   **Tablas y gráficas:** Las gráficas/diagramas se descartan durante la extracción. Las tablas se procesan como texto plano, lo cual puede producir resultados desordenados. Una mejora futura puede incorporar `pdfplumber` para tablas estructuradas.
*   **Tiempo de Ingesta:** El procesamiento inicial de los PDFs tomará varios minutos dependiendo del hardware, ya que calcular embeddings localmente es intensivo en CPU.
*   **Tamaño del Índice:** La carpeta `chroma_db/` crecerá proporcionalmente a la cantidad de texto. Está incluida en `.gitignore`.

---
*Este plan está sujeto a revisión por parte del usuario antes de iniciar la implementación.*
