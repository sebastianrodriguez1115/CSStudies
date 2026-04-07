import chromadb
from pathlib import Path
from sentence_transformers import SentenceTransformer
from config import MODEL_NAME


def get_collection(
    db_path: Path,
    collection_name: str,
    *,
    create: bool = False
) -> chromadb.Collection:
    """
    Obtiene una colección de ChromaDB.

    create=False (default): usa get_collection.
        Deja que ValueError propague si la colección no existe.
    create=True: usa get_or_create_collection con metadata coseno.
        Valida que la colección use métrica coseno.
        Raise ValueError si la métrica es incorrecta.
    """
    client = chromadb.PersistentClient(path=str(db_path))

    if create:
        collection = client.get_or_create_collection(
            name=collection_name,
            metadata={"hnsw:space": "cosine"}
        )
        current_space = collection.metadata.get("hnsw:space", "l2")
        if current_space != "cosine":
            raise ValueError(
                f"La colección '{collection_name}' usa '{current_space}' en lugar de 'cosine'. "
                f"Elimine chroma_db/ y re-ingeste para corregir la métrica."
            )
        return collection

    return client.get_collection(name=collection_name)


def load_model() -> SentenceTransformer:
    """Carga el modelo de embeddings configurado."""
    return SentenceTransformer(MODEL_NAME)
