---
status: in-progress
confidence: 2
last_practiced: 2026-05-14
attempts: 1
time_spent_min: 45
weak_tags: [persistence, observability]
next_action: implement M2 SQLite persistence in TypeScript
source_refs: [alex-xu-vol1-ch8, DDIA-ch5, DDIA-ch6]
---

# Diseña un URL shortener (Bitly)

**Sección:** System Design / Foundational
**Pregunta:** 1.1.1 en `staff-interview-questions.md`
**Duración objetivo de la respuesta hablada:** 45 min
**Implementación:** ver `src/` y `tests/` en esta carpeta.

---

## 0. Implementation roadmap

La respuesta de las secciones siguientes es el diseño completo (lo que defenderías en entrevista). La implementación real es un subset deliberadamente más pequeño que verifica los conceptos clave sin construir todo.

### Stack (decisión)

- Lenguaje: TypeScript sobre Node.js (alineado con entrevistas full-stack/backend modernas).
- HTTP framework: Fastify (rápido, buen soporte TS, `inject` facilita tests sin levantar puerto).
- Storage local: SQLite para arrancar, abstraído tras un repository pattern para poder cambiar a Postgres.
- Cache: `Map` en proceso para M1, Redis (vía docker) para M3.
- Tests: `node:test` + Fastify `inject`.

### Milestones

| ID | Qué construye | Qué verifica conceptualmente |
|---|---|---|
| M0 | Skeleton FastAPI con `/health` | Setup, tests corriendo |
| M1 | `POST /shorten` + `GET /:code` con dict en memoria | Generación base62 random + collision check |
| M2 | Persistencia SQLite tras repository | Modelo de datos, idempotencia |
| M3 | Cache Redis delante del lookup | Cache-aside pattern, hit ratio observable |
| M4 | Click logger async (no bloquea redirect) | Decoupling lectura crítica vs analytics |
| M5 | Rate limiting básico por IP | Defensa simple contra abuso |
| M6 | Métricas Prometheus (p99, hit ratio, qps) | Observabilidad real para conversar SLOs |

Cada milestone es un commit. Cada milestone debería poderse demostrar con un test que falla antes y pasa después.

### Estado actual

- M0 completo: Fastify app con `/health` y tests.
- M1 completo: `POST /api/v1/urls`, alias `/shorten`, `GET /{short_code}`, base62 random, collision retry y custom alias básico en memoria.
- Próximo: M2, persistencia SQLite detrás del repository.

### Out of scope para la implementación

No vale la pena implementar para aprender (lo defendemos en la respuesta hablada):

- Multi-region / failover real.
- DynamoDB / Cassandra. Postgres + SQLite cubren el aprendizaje de KV access patterns.
- ML para predecir hot URLs.
- Custom domains.
- Auth completo (un header dummy basta).

### Cómo se conecta con el frontmatter

- `status: in-progress` desde M1.
- `status: done` cuando M5 esté completo (M6 es nice-to-have).
- `confidence` se actualiza cuando puedo explicar la sección 4 (deep dives) sin mirar el README.
- `weak_tags` se llena con lo que costó implementar, no con lo que costó leer.

---

## 1. Requirements (5-10 min)

### Funcionales (preguntar y confirmar, no asumir)

- Shortener: long URL → short URL (path corto, ~7 chars).
- Redirect: short URL → long URL, HTTP 301 o 302.
- Custom alias opcional (`bit.ly/mi-marca`).
- Expiración opcional.
- Analytics: contar clicks por short URL (asumir scope, ver abajo).

### No funcionales

- **Availability** alta en lecturas (es un redirect, downtime mata enlaces vivos).
- **Latencia** baja en redirect: p99 < 100ms.
- **Read:Write ratio** ~100:1. El sistema es read-heavy.
- **Consistencia**: eventual está bien para analytics, strong para la creación (no dos URLs distintas con el mismo short_code).
- **No predictable**: shorts no enumerables (security contra scraping).

### Estimación back-of-envelope

Asumir 100M URLs nuevas/mes:

- Writes: 100M / (30 × 86400) ≈ **40 writes/s** (peak 4x = 160).
- Reads: 40 × 100 ≈ **4000 reads/s** (peak 16000).
- Storage 5 años: 100M × 12 × 5 = 6B registros. ~500B por registro → **3 TB**.
- Bandwidth: 4000 × 500B ≈ **2 MB/s** outbound.

### Out of scope (decir explícito)

- User management profundo (asumir auth simple).
- Real-time analytics dashboard (analytics batch).
- Custom domains.

---

## 2. API y entidades (5-10 min)

### API

```
POST /api/v1/urls
Body: { long_url, custom_alias?, expires_at? }
Auth: user token
Response: { short_url, short_code, expires_at }

GET /{short_code}
Response: 302 Location: <long_url> por default; 301 si producto decide redirects permanentes.

GET /api/v1/urls/{short_code}/stats
Response: { clicks, last_accessed, ... }
```

### Data model

```
urls
  short_code   varchar(8) PRIMARY KEY
  long_url     text NOT NULL
  user_id      uuid
  created_at   timestamp
  expires_at   timestamp NULLABLE
  custom       boolean

clicks  (tabla separada, append-only)
  short_code   varchar(8)
  ts           timestamp
  ip_hash      varchar(32)
  ua           text
```

Separar `clicks` de `urls` es crítico: la tabla de clicks crece sin parar y degradaría el path de redirect si compartieran storage.

---

## 3. High-level design (10-15 min)

```
Client → CDN/Edge → API Gateway → [Shortener Service] → [DB Primary]
                                ↓                         ↑
                              [Cache: Redis] ←────── [DB Replicas]
                                                      ↓
                              [Click logger] → Kafka → [Analytics DB]
```

Flujo de creación:

1. Cliente POST a Shortener.
2. Generar `short_code` (ver deep dive 4.1).
3. Insertar en DB primary.
4. Pre-warm cache si es URL "vip" (opcional).
5. Devolver short URL.

Flujo de redirect:

1. Cliente GET a `bit.ly/abc1234`.
2. Edge/CDN: cache hit con TTL corto (1-5 min) para URLs muy calientes.
3. Si miss: API Gateway → Redirect Service.
4. Lookup en Redis. Hit → 301.
5. Miss → DB replica → poblar Redis → 302.
6. Async: emitir click event a Kafka (no bloquear redirect).

---

## 4. Deep dives (15-20 min)

Elegir 2-3 según el follow-up. Los más probables:

### 4.1 Generación de short_code (la deep dive estrella)

Tres alternativas con sus trade-offs:

**Opción A: Hash del long URL (MD5/SHA256 truncado).**

- Pro: idempotente (mismo long URL → mismo short).
- Contra: colisiones reales con 7 chars. Requiere check + retry. Si dos users acortan la misma URL queremos shorts distintos? Producto decide.

**Opción B: Counter monotónico + base62.**

- Pro: simple, sin colisiones, fácil de razonar.
- Contra: shorts predecibles (security: alguien puede iterar). Single point para asignar el contador. Solución: rangos pre-asignados por servidor (ej. 1M IDs por nodo), o Twitter Snowflake-like.

**Opción C: Random base62 + collision check.**

- Pro: no predecibles, sin counter centralizado.
- Contra: con 62^7 ≈ 3.5T espacio, las colisiones son raras al inicio pero crecen. Probabilidad de colisión en insert se mantiene baja si el espacio es 1000x el N actual. Insert con `INSERT ... ON CONFLICT` y retry.

**Mi recomendación defendida:** opción C para producción. Justificación: no predictability es un requisito implícito en URL shorteners (sino los enlaces se scrapean). El costo de retry es marginal (probabilidad de colisión < 0.001% con buen RNG y 7 chars hasta los primeros mil millones).

### 4.2 Caching strategy

- **Qué cachear**: el mapping `short_code → long_url`. Inmutable post-creación, perfecto para cache.
- **TTL**: indefinido para hits frecuentes, eviction LRU. URLs con expiración natural se respetan.
- **Tamaño**: top 20% de URLs absorbe 80% del tráfico. Con 6B URLs y entry ~600 bytes → cachear top 100M = 60GB en Redis cluster.
- **Invalidación**: edición de long_url (caso raro) invalida la entrada.
- **CDN edge cache**: para URLs virales, TTL corto (60s) absorbe spikes sin tocar Redis.

### 4.3 Base de datos

Trade-off SQL vs NoSQL:

- **PostgreSQL**: integridad referencial, fácil de razonar, hasta unos TB escala bien. Sharding por `short_code` hash si supera límites.
- **DynamoDB / Cassandra**: escala lineal, pero la API de redirect es punto-de-acceso por PK → muy bien servida por KV stores. Cost-effective a escala.

**Recomendación**: arrancar con Postgres (simple), migrar a DynamoDB cuando los reads superen lo que un Redis cluster + Postgres pueden absorber. Sharding key: `short_code` (uniformemente distribuido por construcción).

### 4.4 Custom aliases y colisiones

- Validar charset, longitud, palabras reservadas (`api`, `admin`, `login`).
- Insert con UNIQUE constraint, retry con error claro al usuario.
- Reservar prefijos para sistema.

### 4.5 Analytics path (no bloquear redirect)

- Click event → Kafka topic → consumer agrega a tabla columnar (ClickHouse, BigQuery).
- Métricas batch (hourly): clicks por short, por geo, por referrer.
- Real-time si lo piden: usar streaming aggregation (Flink, Kafka Streams).

### 4.6 Abuse / security

- Rate limit por user y por IP en creación.
- Scan de malware en long_url antes de aceptar (Google Safe Browsing API).
- Bloquear redirects a domains en denylist.
- Reportar enlaces, soft-delete con razón.

---

## 5. Operación y seguimiento (diferenciador Staff)

- **SLO**: 99.9% availability en redirect, p99 < 100ms.
- **Error budget**: 43 min/mes de downtime. Se gasta en deploys/migraciones.
- **Alertas**: latencia p99, error rate en redirect, cache hit ratio < 90%.
- **Capacity planning**: revisar mensual, growth rate dicta cuándo agregar shards.
- **Migración futura**: cómo agregar custom domains sin rediseñar. Path: domain field en tabla, routing en edge.

---

## 6. Lo que NO incluí y por qué (Beauty in Simplicity)

- No microservicios separados para shorten/redirect: misma stack, distinto endpoint. Operacionalmente más simple.
- No multi-region desde día 1: agregar cuando p99 cross-region duela.
- No event sourcing: overkill para CRUD plano.

Mencionarlo proactivamente señala juicio Staff.

---

## 7. Follow-ups probables y respuestas cortas

**"¿Qué pasa si tu hash colisiona a 100M URLs?"**

Con 62^7 ≈ 3.5T y 100M usados, probabilidad de colisión por insert = 100M/3.5T ≈ 0.003%. Insert con UNIQUE constraint y retry resuelve. Si llegamos a 1B URLs (3% del espacio), las colisiones suben a ~3%, momento de pasar a 8 chars. Migración: 8 chars es opt-in para nuevos, los viejos siguen funcionando.

**"¿Cómo lo operarías a las 2am?"**

Alertas en p99 redirect y error rate. Runbook: si Redis cae, hit directo a DB con degradación de latencia, NO downtime. Si DB primary cae, failover automático a replica, writes esperan. Postmortem culture.

**"Si te dijera que el 1% del tráfico genera el 50% de la carga"**

Es lo normal. La estrategia de cache LRU ya lo absorbe. Si fuera más extremo, agregaría edge caching agresivo en CDN para esas URLs específicas (warm-up automático cuando una URL excede X reqs/s).

**"¿Por qué no microservicios?"**

Operación más simple, menos network hops, menos coordinación. El servicio tiene un solo bounded context (URLs). Microservicios tendrían sentido si tuviéramos dominios muy distintos (auth, billing, analytics avanzado), no para split horizontal de un dominio simple.

**"¿Cómo migrarías de Postgres a DynamoDB sin downtime?"**

Dual-write durante migración: nuevo write va a ambos. Backfill async desde Postgres. Lecturas: feature flag para % de tráfico que lee de DynamoDB. Subir gradual, monitorear paridad. Cuando 100% y verificado, retirar Postgres. Tiempo total: semanas, no días.

---

## 8. Antipatterns a evitar en esta pregunta

- Saltar al diseño sin clarificar (¿analytics en scope?, ¿custom domains?).
- Asumir microservicios sin defenderlos.
- "Usaré MongoDB" sin justificar contra alternativas.
- No mencionar el problema de no-predictability (es donde se ve si entiendes el dominio).
- No hablar de cache para un sistema 100:1 read-heavy.
- Dibujar 15 cajas y no profundizar en ninguna.

---

## 9. Cheatsheet de números

| Concepto | Magnitud |
|---|---|
| URLs nuevas/mes | 100M |
| Writes/s sostenido | 40 (peak 160) |
| Reads/s sostenido | 4000 (peak 16000) |
| Storage 5 años | ~3 TB |
| Espacio de 7 chars base62 | 3.5T combinaciones |
| Hot data en cache | ~60 GB |
| SLO redirect | 99.9% / p99 < 100ms |

---

## 10. Referencias internas

- `fuentes/2020-system-design-interview-vol-1-alex-xu.pdf` (capítulo dedicado).
- `fuentes/2024-designing-data-intensive-applications-martin-kleppmann.pdf` (cache, sharding).
- `staff-interview-guide.md` sección 3.1 (framework 4 pasos).
