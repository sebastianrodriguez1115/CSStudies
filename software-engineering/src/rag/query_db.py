import json
import typer
from pathlib import Path
from db import get_collection, load_model

app = typer.Typer(help="Motor de Consulta RAG.")

def _format_results(results):
    if not results['ids'] or not results['ids'][0]:
        return []
    formatted = []
    for i in range(len(results['ids'][0])):
        meta = results['metadatas'][0][i]
        source_dir = meta.get('source_dir', 'fuentes')
        score = max(0.0, 1.0 - results['distances'][0][i])
        formatted.append({
            "text": results['documents'][0][i],
            "file": f"{source_dir}/{meta['source_file']}",
            "page": meta['page_number'],
            "score": round(score, 4)
        })
    return formatted

@app.command()
def query(query_text: str = typer.Argument(..., help="Pregunta a buscar"), 
          db_path: Path = typer.Option(..., help="Ruta a ChromaDB"),
          collection_name: str = typer.Option(..., help="Nombre de la colección"), 
          n_results: int = typer.Option(..., "--n-results", "-n", help="Número de resultados")):
    if not db_path.exists():
        typer.echo(f"Error: La base de datos en {db_path} no existe.", err=True); raise typer.Exit(1)
    try:
        collection = get_collection(db_path, collection_name)
        model = load_model()
        results = collection.query(query_embeddings=model.encode([query_text]).tolist(), n_results=n_results)
        formatted = _format_results(results)
        typer.echo(json.dumps(formatted, indent=2, ensure_ascii=False))
    except ValueError:
        typer.echo(f"Error: Colección '{collection_name}' no encontrada.", err=True); raise typer.Exit(1)
    except Exception as e:
        typer.echo(f"Error durante la consulta: {e}", err=True); raise typer.Exit(1)

if __name__ == "__main__":
    app()
