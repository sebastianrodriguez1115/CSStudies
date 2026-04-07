import re
import bisect
import unicodedata
import logging
import fitz
from pathlib import Path
from config import CHUNK_SIZE_CHARS, CHUNK_OVERLAP_CHARS, LOOKBACK_RANGE_CHARS

logger = logging.getLogger(__name__)
PAGE_MARKER_RE = re.compile(r"\n\n<<PAGE:(\d+)>>\n\n")
SENTENCE_END_RE = re.compile(r"\.\s(?=[A-Z])|\.\n")

def precompute_page_positions(buffer: str) -> tuple[list[int], list[int]]:
    positions = []
    page_numbers = []
    for m in PAGE_MARKER_RE.finditer(buffer):
        positions.append(m.start())
        page_numbers.append(int(m.group(1)))
    return positions, page_numbers

def get_page_number(positions: list[int], page_numbers: list[int], pos: int) -> int:
    idx = bisect.bisect_right(positions, pos) - 1
    return page_numbers[idx] if idx >= 0 else 1

def extract_text_continuous(pdf_path: Path) -> str:
    try:
        with fitz.open(str(pdf_path)) as doc:
            full_buffer = []
            for page_num, page in enumerate(doc, start=1):
                blocks = page.get_text("blocks")
                text_blocks = [
                    unicodedata.normalize("NFC", b[4]).strip() 
                    for b in blocks if b[6] == 0 
                ]
                full_buffer.append(f"\n\n<<PAGE:{page_num}>>\n\n")
                full_buffer.append("\n\n".join(b for b in text_blocks if b))
            return "".join(full_buffer)
    except Exception as e:
        logger.warning(f"Error al procesar {pdf_path.name}: {e}")
        return ""

def _find_semantic_end(text: str, start: int, end: int) -> int:
    """Busca el mejor punto de corte semántico entre start y end."""
    if end >= len(text):
        return len(text)
    
    min_end = start + CHUNK_OVERLAP_CHARS + 1
    lookback_limit = max(min_end, end - LOOKBACK_RANGE_CHARS)
    
    para_break = text.rfind('\n\n', lookback_limit, end)
    if para_break != -1:
        return para_break + 2
        
    sentence_match = list(SENTENCE_END_RE.finditer(text, lookback_limit, end))
    if sentence_match:
        return sentence_match[-1].end()
        
    space_break = text.rfind(' ', lookback_limit, end)
    return space_break + 1 if space_break != -1 else end

def chunk_text_continuous(text: str) -> list[dict]:
    if not text or text.isspace():
        return []
        
    positions, page_numbers = precompute_page_positions(text)
    chunks, start, last_page_num, chunk_idx = [], 0, -1, 0
    
    while start < len(text):
        end = _find_semantic_end(text, start, start + CHUNK_SIZE_CHARS)
        chunk_content = text[start:end].strip()
        clean_text = PAGE_MARKER_RE.sub("\n\n", chunk_content).strip()
        
        if clean_text:
            page_num = get_page_number(positions, page_numbers, start)
            chunk_idx = 0 if page_num != last_page_num else chunk_idx + 1
            last_page_num = page_num
            chunks.append({"text": clean_text, "page_number": page_num, "chunk_index": chunk_idx})
            
        start = end - CHUNK_OVERLAP_CHARS if end < len(text) else len(text)
        if start >= len(text): break
    return chunks
