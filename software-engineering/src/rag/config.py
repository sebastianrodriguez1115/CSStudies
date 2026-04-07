# Configuración técnica del motor RAG
MODEL_NAME = "sentence-transformers/all-mpnet-base-v2"

# Parámetros de Chunking (calibrados para ~600 tokens con overlap de ~125)
CHUNK_SIZE_CHARS = 2400
CHUNK_OVERLAP_CHARS = 500
LOOKBACK_RANGE_CHARS = 300

# Versión del esquema de indexación
INDEX_VERSION = "v2"
