#!/usr/bin/env python3
"""Genera un dashboard de progreso a partir del frontmatter en respuestas/.

Uso: python scripts/progress.py
Salida: respuestas/_dashboard.md (regenerable)
"""
from datetime import date, datetime, timedelta
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
RESPUESTAS = ROOT / "respuestas"
DASHBOARD = RESPUESTAS / "_dashboard.md"

# Totales de preguntas por categoría (sincronizado con staff-interview-questions.md)
TOTALS = {
    "system-design": 40,
    "behavioral":    39,
    "deep-dive":     18,
    "coding":        23,
    "rrk":           22,
    "amazon-lp":     22,
}

STALE_DAYS = 14
STUCK_ATTEMPTS = 3
STUCK_CONFIDENCE = 3


def parse_frontmatter(text):
    """Parser mínimo de frontmatter YAML. Soporta el subset que usamos."""
    m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return None
    fm = {}
    for line in m.group(1).splitlines():
        if ":" not in line or line.lstrip().startswith("#"):
            continue
        key, _, val = line.partition(":")
        key = key.strip()
        val = val.strip().strip('"').strip("'")
        if val.startswith("[") and val.endswith("]"):
            inner = val[1:-1].strip()
            fm[key] = [v.strip() for v in inner.split(",") if v.strip()] if inner else []
        elif val.lower() in ("null", "none", ""):
            fm[key] = None
        elif re.fullmatch(r"-?\d+", val):
            fm[key] = int(val)
        else:
            fm[key] = val
    return fm


def load_entries():
    """Carga entradas desde dos layouts:
       - archivo plano: respuestas/<cat>/NN-slug.md
       - carpeta con código: respuestas/<cat>/NN-slug/README.md
    """
    entries = []
    for cat in TOTALS:
        catdir = RESPUESTAS / cat
        if not catdir.exists():
            continue
        for entry in sorted(catdir.iterdir()):
            if entry.name.startswith("_") or entry.name.startswith("."):
                continue
            if entry.is_file() and entry.suffix == ".md":
                target = entry
            elif entry.is_dir():
                target = entry / "README.md"
                if not target.exists():
                    continue
            else:
                continue
            text = target.read_text()
            fm = parse_frontmatter(text)
            if fm is None:
                continue
            fm["_file"] = target.relative_to(ROOT)
            fm["_category"] = cat
            entries.append(fm)
    return entries


def bar(pct, width=10):
    filled = int(round(pct / 100 * width))
    return "█" * filled + "░" * (width - filled)


def parse_date(s):
    if not s:
        return None
    try:
        return datetime.strptime(str(s), "%Y-%m-%d").date()
    except ValueError:
        return None


def main():
    entries = load_entries()
    today = date.today()
    lines = []

    lines.append("# Progress dashboard")
    lines.append("")
    lines.append(f"Generado: {today.isoformat()}")
    lines.append("")
    lines.append("_Regenerar con: `python scripts/progress.py`_")
    lines.append("")

    # Cobertura
    lines.append("## Cobertura")
    lines.append("")
    for cat, total in TOTALS.items():
        cat_entries = [e for e in entries if e["_category"] == cat]
        done = sum(1 for e in cat_entries if e.get("status") == "done")
        in_prog = sum(1 for e in cat_entries if e.get("status") == "in-progress")
        touched = done + in_prog
        pct = touched / total * 100 if total else 0
        lines.append(
            f"- **{cat}**: {touched}/{total} ({pct:.0f}%) "
            f"`{bar(pct)}` (done: {done}, in-progress: {in_prog})"
        )
    lines.append("")

    # Confidence
    lines.append("## Confidence promedio por categoría")
    lines.append("")
    for cat in TOTALS:
        cat_entries = [
            e for e in entries
            if e["_category"] == cat and isinstance(e.get("confidence"), int) and e["confidence"] > 0
        ]
        if not cat_entries:
            lines.append(f"- **{cat}**: sin datos")
            continue
        avg = sum(e["confidence"] for e in cat_entries) / len(cat_entries)
        lines.append(f"- **{cat}**: {avg:.1f}/5 (n={len(cat_entries)})")
    lines.append("")

    # Stale
    cutoff = today - timedelta(days=STALE_DAYS)
    stale = []
    for e in entries:
        d = parse_date(e.get("last_practiced"))
        if d and d < cutoff and e.get("status") != "done":
            stale.append((e, d))
    stale.sort(key=lambda x: x[1])

    lines.append(f"## Stale (>{STALE_DAYS} días sin tocar y no done)")
    lines.append("")
    if not stale:
        lines.append("_Sin entradas stale._")
    else:
        for e, d in stale:
            days = (today - d).days
            lines.append(
                f"- `{e['_file']}` (last: {d}, {days}d, confidence: {e.get('confidence', '?')}/5)"
            )
    lines.append("")

    # Estancado
    stuck = [
        e for e in entries
        if isinstance(e.get("attempts"), int) and e["attempts"] >= STUCK_ATTEMPTS
        and isinstance(e.get("confidence"), int) and e["confidence"] < STUCK_CONFIDENCE
    ]
    lines.append(f"## Estancado ({STUCK_ATTEMPTS}+ intentos, confidence <{STUCK_CONFIDENCE})")
    lines.append("")
    if not stuck:
        lines.append("_Sin entradas estancadas._")
    else:
        for e in stuck:
            lines.append(
                f"- `{e['_file']}` ({e['attempts']} intentos, "
                f"confidence {e['confidence']}/5) → next: {e.get('next_action', 'revisar')}"
            )
    lines.append("")

    # Weak tags
    tag_counts = {}
    for e in entries:
        for tag in e.get("weak_tags") or []:
            tag_counts[tag] = tag_counts.get(tag, 0) + 1
    top = sorted(tag_counts.items(), key=lambda x: -x[1])

    lines.append("## Top weak_tags (debilidades sistemáticas)")
    lines.append("")
    if not top:
        lines.append("_Sin tags marcados todavía._")
    else:
        for tag, count in top[:10]:
            lines.append(f"- `{tag}`: {count} archivos")
    lines.append("")

    # Tiempo
    total_time = sum(e.get("time_spent_min", 0) or 0 for e in entries)
    lines.append("## Tiempo invertido")
    lines.append("")
    lines.append(f"Total: {total_time} min ({total_time / 60:.1f}h)")
    lines.append("")
    for cat in TOTALS:
        t = sum(
            e.get("time_spent_min", 0) or 0
            for e in entries if e["_category"] == cat
        )
        lines.append(f"- **{cat}**: {t} min ({t / 60:.1f}h)")
    lines.append("")

    # Sugerencias accionables
    lines.append("## Sugerencias accionables")
    lines.append("")
    suggestions = []

    # Categoría sub-invertida (la de menor cobertura)
    coverage = {
        cat: (sum(1 for e in entries if e["_category"] == cat and e.get("status") in ("done", "in-progress")) / total)
        for cat, total in TOTALS.items()
    }
    min_cat = min(coverage, key=coverage.get)
    if coverage[min_cat] < 0.5:
        suggestions.append(
            f"Sub-invertido: **{min_cat}** ({coverage[min_cat] * 100:.0f}% cobertura). "
            f"Considera dedicar la próxima sesión a esta categoría."
        )

    if stale:
        suggestions.append(
            f"{len(stale)} archivo(s) stale. Re-practicar antes de que decaiga más la memoria."
        )

    if stuck:
        suggestions.append(
            f"{len(stuck)} archivo(s) estancado(s). Cambiar de approach: mock, leer fuente, peer review."
        )

    if top and top[0][1] >= 3:
        suggestions.append(
            f"Tag `{top[0][0]}` aparece en {top[0][1]} archivos. "
            f"Sesión temática vale más que más preguntas."
        )

    if not suggestions:
        suggestions.append("Sin sugerencias activas. Sigue al ritmo planificado.")

    for s in suggestions:
        lines.append(f"- {s}")
    lines.append("")

    DASHBOARD.write_text("\n".join(lines))
    print(f"Wrote {DASHBOARD.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
