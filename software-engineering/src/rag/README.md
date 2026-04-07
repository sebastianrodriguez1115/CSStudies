# RAG Engine - Motor de Búsqueda Semántica Local

Este motor permite indexar y consultar libros de ingeniería de software en formato PDF utilizando una arquitectura RAG (*Retrieval-Augmented Generation*) local. Utiliza **ChromaDB** para el almacenamiento vectorial y **sentence-transformers** para los embeddings.

## Características
- **Extracción Inteligente**: Filtra imágenes y mantiene la continuidad semántica entre páginas.
- **Chunking Semántico**: Divide el texto respetando párrafos y oraciones (~600 tokens con solapamiento).
- **Métrica Coseno**: Optimizado para alta precisión en búsquedas técnicas.
- **Modular y Limpio**: Código refactorizado en módulos especializados (`chunking`, `db`).

## Requisitos
- **Python**: 3.10 o superior.
- **Gestor de paquetes**: `uv` (recomendado).

## Configuración

1. Navega al directorio del proyecto:
   ```bash
   cd software-engineering/src/rag
   ```

2. Instala las dependencias y crea el entorno virtual:
   ```bash
   uv sync
   ```

3. Activa el entorno virtual:
   ```bash
   source .venv/bin/activate
   ```

## Uso del Motor de Ingesta (`ingest_pdfs.py`)

El script de ingesta permite gestionar el índice de documentos. Todos los parámetros de ruta son **requeridos**.

### Indexar libros
Procesa todos los PDFs de una carpeta y los añade a la base de datos.
```bash
python ingest_pdfs.py ingest \
    --source-dir ../../fuentes \
    --db-path ./chroma_db \
    --collection-name software_engineering_books
```

### Ver estadísticas
Muestra el número de chunks por libro y la versión del índice.
```bash
python ingest_pdfs.py stats \
    --db-path ./chroma_db \
    --collection-name software_engineering_books
```

### Eliminar un libro
Elimina interactivamente todos los chunks asociados a un PDF específico.
```bash
python ingest_pdfs.py delete "nombre-del-archivo.pdf" \
    --db-path ./chroma_db \
    --collection-name software_engineering_books
```

## Uso del Motor de Consulta (`query_db.py`)

Realiza búsquedas semánticas sobre los libros indexados.

```bash
python query_db.py "stateless architecture advantages" \
    --db-path ./chroma_db \
    --collection-name software_engineering_books \
    --n-results 3
```

### Formato de Salida
La consulta devuelve un JSON con los fragmentos más relevantes, incluyendo la página, el archivo original y un `score` de similitud (1.0 es coincidencia exacta).

## Mantenimiento
Si decides cambiar el modelo de embeddings o la lógica de chunking, es recomendable:
1. Incrementar el `INDEX_VERSION` en `config.py`.
2. Borrar la carpeta `chroma_db/`.
3. Volver a ejecutar el comando `ingest`.
