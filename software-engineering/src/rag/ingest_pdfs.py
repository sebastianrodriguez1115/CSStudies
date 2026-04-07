import hashlib
import typer
from pathlib import Path
from tqdm import tqdm
from config import INDEX_VERSION
from chunking import extract_text_continuous, chunk_text_continuous
from db import get_collection, load_model

app = typer.Typer(help="Motor de Ingesta y Gestión de Libros para RAG.")

def _get_files_to_process(source_dir, collection, reindex):
    pdf_files = sorted(source_dir.glob("*.pdf"))
    if not pdf_files:
        return []
    if reindex:
        return pdf_files
    all_meta = collection.get(include=["metadatas"])
    indexed = {m["source_file"] for m in all_meta["metadatas"]} if all_meta['metadatas'] else set()
    return [f for f in pdf_files if f.name not in indexed]

def _ingest_single_pdf(pdf_path, collection, model, source_dir_name, reindex):
    # Extraer primero para evitar borrar datos viejos si falla la extracción
    full_text = extract_text_continuous(pdf_path)
    if not full_text:
        typer.echo(f"\n  Advertencia: sin texto extraído de {pdf_path.name}", err=True)
        return

    if reindex:
        collection.delete(where={"source_file": pdf_path.name})

    chunks = chunk_text_continuous(full_text)
    if not chunks: return

    docs = [c["text"] for c in chunks]
    metas = [{"source_file": pdf_path.name, "page_number": c["page_number"], 
              "chunk_index": c["chunk_index"], "source_dir": source_dir_name, 
              "index_version": INDEX_VERSION} for c in chunks]
    ids = [hashlib.sha256(f"{INDEX_VERSION}::{pdf_path.name}::p{c['page_number']}::c{c['chunk_index']}".encode()).hexdigest()[:32] 
           for c in chunks]
    
    embeddings = model.encode(docs, batch_size=64, show_progress_bar=False).tolist()
    for i in range(0, len(ids), 100):
        collection.add(documents=docs[i:i+100], embeddings=embeddings[i:i+100], metadatas=metas[i:i+100], ids=ids[i:i+100])

@app.command()
def ingest(source_dir: Path = typer.Option(..., help="Ruta a los PDFs"),
           db_path: Path = typer.Option(..., help="Ruta a ChromaDB"),
           collection_name: str = typer.Option(..., help="Nombre de la colección"),
           reindex: bool = typer.Option(False, "--reindex", help="Forzar re-ingesta")):
    if not source_dir.exists():
        typer.echo(f"Error: {source_dir} no existe.", err=True); raise typer.Exit(1)
    try:
        collection = get_collection(db_path, collection_name, create=True)
    except ValueError as e:
        typer.echo(f"Error: {e}", err=True); raise typer.Exit(1)
    
    files = _get_files_to_process(source_dir, collection, reindex)
    if not files:
        typer.echo("No hay archivos nuevos para indexar."); return

    typer.echo("Cargando modelo de embeddings...")
    model = load_model()
    pbar = tqdm(files, desc="Indexando libros")
    for pdf_path in pbar:
        pbar.set_postfix({"file": pdf_path.name[:20]})
        try:
            _ingest_single_pdf(pdf_path, collection, model, source_dir.name, reindex)
        except Exception as e:
            typer.echo(f"\nError procesando {pdf_path.name}, limpiando: {e}", err=True)
            collection.delete(where={"source_file": pdf_path.name})

def _display_stats(collection_name, all_meta):
    files_data, version_data = {}, {}
    for m in all_meta["metadatas"]:
        f, v = m["source_file"], m.get("index_version", "v0")
        files_data[f] = files_data.get(f, 0) + 1
        version_data[v] = version_data.get(v, 0) + 1
    typer.echo(f"\n--- Estadísticas de {collection_name} ---")
    typer.echo(f"Total de chunks: {len(all_meta['metadatas'])}")
    typer.echo("\nDesglose por versión:")
    for v, count in sorted(version_data.items()):
        typer.echo(f"  - {v}: {count} chunks")
    typer.echo("\nLibros indexados:")
    for f, count in sorted(files_data.items()):
        typer.echo(f"  - {f}: {count} chunks")

@app.command()
def stats(db_path: Path = typer.Option(..., help="Ruta a ChromaDB"), 
          collection_name: str = typer.Option(..., help="Nombre de la colección")):
    try:
        collection = get_collection(db_path, collection_name)
        all_meta = collection.get(include=["metadatas"])
        if not all_meta['metadatas']:
            typer.echo("La colección está vacía."); return
        _display_stats(collection_name, all_meta)
    except ValueError:
        typer.echo(f"Error: Colección '{collection_name}' no encontrada.", err=True); raise typer.Exit(1)

@app.command()
def delete(file_name: str = typer.Argument(..., help="Nombre exacto del PDF"), 
           db_path: Path = typer.Option(..., help="Ruta a ChromaDB"),
           collection_name: str = typer.Option(..., help="Nombre de la colección")):
    try:
        collection = get_collection(db_path, collection_name)
        existing = collection.get(where={"source_file": file_name}, include=[])
        count = len(existing['ids'])
        if count == 0:
            typer.echo(f"No se encontraron chunks para '{file_name}'."); return
        typer.confirm(f"¿Desea eliminar {count} chunks de '{file_name}'?", abort=True)
        collection.delete(where={"source_file": file_name})
        typer.echo(f"Libro '{file_name}' ({count} chunks) eliminado.")
    except ValueError:
        typer.echo(f"Error: Colección '{collection_name}' no encontrada.", err=True); raise typer.Exit(1)

if __name__ == "__main__":
    app()
