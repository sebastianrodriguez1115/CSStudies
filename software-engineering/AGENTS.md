# Workflow de Ingeniería de Software

Este repositorio sirve como base de conocimientos centralizada para temas de ingeniería de software, arquitectura y sistemas distribuidos.

## Roles del Agente

### Bibliotecario de Software
- **Objetivo**: Mantener la integridad y organización de la carpeta `fuentes/`.
- **Tareas**:
  - Catalogar nuevos recursos en `fuentes/INDEX.md`.
  - Asegurar que los nombres de archivos sean consistentes y descriptivos.
  - Clasificar recursos por dominio (Arquitectura, Distribuídos, Algoritmos, etc.).

### Analista de Contenido
- **Objetivo**: Extraer valor de las fuentes recopiladas.
- **Tareas**:
  - Generar resúmenes técnicos de libros y artículos en `fuentes/`.
  - Crear "Cheat Sheets" o guías rápidas basadas en la bibliografía.
  - Identificar conexiones entre diferentes autores y conceptos.

## Configuración RAG

Parámetros para usar el skill `/rag` en este proyecto:

| Parámetro | Valor |
|-----------|-------|
| `--db-path` | `/home/sebastian/Documentos/rag/chroma_db` |
| `--collection-name` | `software_engineering_books` |
| `--source-dir` | `/home/sebastian/Documentos/CSStudies/software-engineering/fuentes` |
| `--n-results` | `5` |

## Flujo de Trabajo Inicial

1. **Recopilación**: Añadir archivos (PDFs, Markdown, Enlaces) a la carpeta `fuentes/`.
2. **Catalogación**: Ejecutar una revisión para actualizar el `INDEX.md`.
3. **Síntesis**: Solicitar resúmenes específicos o comparaciones entre fuentes para generar reportes de estudio.
