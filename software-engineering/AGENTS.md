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

## Convenciones para `respuestas/`

Estructura de respuestas a preguntas de entrevista, separada por categoría:

- **`system-design/` y `coding/`**: cada pregunta es una **carpeta** con la forma `NN-slug/`. Dentro:
  - `README.md`: respuesta de estudio + frontmatter de tracking + plan de implementación.
  - `src/`: código de la implementación real.
  - `tests/`: tests de la implementación.
  - El README sirve simultáneamente como design doc, plan, y respuesta de mock.
- **`behavioral/`, `deep-dive/`, `amazon-lp/`, `rrk/`**: un solo archivo `NN-slug.md` (sin carpeta), porque son ejercicios de comunicación, no de implementación.

Razón de la asimetría: para system design y coding, implementar fuerza profundidad real, hace que los trade-offs duelan en concreto y produce artefactos verificables. Para behavioral, lo que importa es la narrativa y el self-awareness, no el código.

Tracking: `scripts/progress.py` lee frontmatter de archivos planos y de `README.md` dentro de carpetas indistintamente. Decisión registrada el 2026-05-14.

## Flujo de Trabajo Inicial

1. **Recopilación**: Añadir archivos (PDFs, Markdown, Enlaces) a la carpeta `fuentes/`.
2. **Catalogación**: Ejecutar una revisión para actualizar el `INDEX.md`.
3. **Síntesis**: Solicitar resúmenes específicos o comparaciones entre fuentes para generar reportes de estudio.
