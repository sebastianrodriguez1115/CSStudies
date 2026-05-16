# Guía de entrevistas Staff Engineer+

Documento de referencia con el contexto, frameworks y antipatterns. Las preguntas de práctica viven en `staff-interview-questions.md`.

---

## 1. Lo que cambia en Staff+ vs Senior

| Dimensión | Senior (L5/E5) | Staff+ (L6/E6 en adelante) |
|---|---|---|
| Peso del coding | ~40% | ~20% (eliminatorio, no diferenciador) |
| Peso del system design | ~30% | ~60% |
| Peso del behavioral | ~30% | Decide el nivel (Staff vs downlevel a Senior) |
| Scope de historias | 1 equipo, 3+ personas | 2+ equipos, todo el org |
| Mindset evaluado | WHAT y HOW | WHY |
| Velocidad en coding rote | Más rápido | Igual o más lento (codean menos en el día a día) |

**Implicación práctica:** suspender coding es fail automático, pero brillar en coding no compensa nada. La energía marginal de estudio rinde más en system design y behavioral.

---

## 2. Señales que evalúan (Will Larson)

Cinco señales que diferencian Staff de Senior. Toda historia, todo diseño, toda respuesta debería mapearse a una o varias:

- **Self-awareness:** reconoce errores, muestra crecimiento.
- **Judgment:** anticipa problemas, navega ambigüedad, mediates trade-offs.
- **Collaboration:** con menos seniors, con managers, cross-funcionalmente, con ejecutivos.
- **Communication:** escucha, articula, escribe.
- **Development:** la gente y los sistemas a tu alrededor mejoran.

Notar que ninguna es estrictamente técnica. La expertise técnica es el medio para ejercer estas señales.

---

## 3. Framework por tipo de ronda

### 3.1 System Design (45 min)

1. **Requirements** (5-10 min): funcionales, no funcionales (DAU, QPS, latencia, consistencia), out-of-scope explícito.
2. **API y entidades** (5-10 min): contratos y modelo de datos.
3. **High-level design** (10-15 min): componentes y dataflow end-to-end.
4. **Deep dives** (15-20 min): 2-3 componentes críticos con números reales.

Staff agrega una capa transversal: trade-offs explícitos contra alternativas descartadas, y operación (oncall, capacity planning, migración).

**Las 5 claves Staff (Stefan Mai, Hello Interview):**

1. Adaptar comunicación al nivel del interviewer.
2. Identificar el "crux", no diseñar todo por igual.
3. Cortar complejidad. Beauty in Simplicity.
4. Profundidad real en al menos un componente.
5. Mostrar instincts (anticipar bottlenecks sin que pregunten).

### 3.2 Behavioral

Calibración por nivel de la misma pregunta (interviewing.io, Meta):

- Senior: historia con tu equipo, 3+ personas.
- Staff: historia con 2+ equipos, impacto en el org.

Si tu historia "Staff" sólo involucra a tu equipo, te downlevelean.

**Frameworks de respuesta:**

- **STAR:** Situation, Task, Action, Result. Estándar pero plano.
- **SPSIL:** Situation, Problem, Solution, Impact, Lessons. Mejor para Staff.
- **CAR:** Context, Action, Result. Para respuestas cortas.

**Reglas prácticas:**

- Primera persona. "I did" no "we did".
- Métricas duras. "p99 de 800ms a 120ms" no "mejoró la latencia".
- Respuesta inicial 15-30 seg, deja que el follow-up profundice.
- No proyectos de hace 3+ años (recency bias).

### 3.3 Past Project Deep Dive

Contar un proyecto real con rigor técnico, como si el interviewer hubiera estado ahí. Estructura:

1. Contexto de negocio (30-60 seg).
2. Diagrama high-level (preparado, no improvisado).
3. Qué owniaste tú vs el equipo.
4. 2-3 decisiones con trade-offs defendidos.
5. Impacto medible.
6. Reflexión (qué harías distinto).

Ver `staff-interview-questions.md` sección 3 para las 12 preguntas canónicas.

### 3.4 Coding

Misma dificultad que Senior (LC medium-hard) pero distinta evaluación:

- **Comunicación:** strong hire = el interviewer no tuvo que clarificar nada.
- **Problem solving:** alternativas explícitas antes de codear.
- **Coding quality:** legible, modular, productionizable. Nombres reales, no `i j k`.
- **Testing:** edge cases sin que pregunten.

Empresas que se alejan del LeetCode puro: Netflix, Stripe, OpenAI. Esperan ejercicios "near-real" (LRU cache, log parser concurrente, web crawler, mini SQL engine).

### 3.5 Role-Related Knowledge (Google)

Deep dive sobre tu área de expertise. El interviewer es del área. Probará la frontera de tu conocimiento.

Estrategia: domina tu stack pero también la frontera adyacente. La pregunta favorita es "por qué eligieron esa arquitectura y qué alternativa descartaron".

---

## 4. Amazon Leadership Principles (caso especial)

Cada round mapeado a 1-3 LPs. El Bar Raiser tiene veto y evalúa tres preguntas implícitas:

1. ¿Esta persona raises the bar sobre el 50% actual en su nivel?
2. ¿Impacto repetido, no sólo competencia?
3. ¿Judgment para decisiones de largo plazo?

**Reglas no obvias:**

- No menciones revenue/cost savings bajo $1M.
- No cuentes proyectos de un solo sprint (poca complejidad).
- Si describes un proceso manual, anticipa "why didn't you automate it?".
- Tu respuesta inicial: 15-30 seg, no la historia completa.

**LPs más probados para Staff+:** Ownership, Deliver Results, Have Backbone, Earn Trust, Dive Deep, Hire and Develop the Best, Think Big, Are Right A Lot.

---

## 5. Diferencias por empresa

- **Google L6:** Round RRK específico, downlevels frecuentes. LC medium-hard.
- **Meta E6:** 2 rondas de design (puedes elegir System Design o Product Architecture). 1-2 coding.
- **Amazon L6/L7:** Cada round mapeado a LPs. Bar Raiser con veto.
- **Microsoft 65+:** Loop similar a Google con énfasis en design.
- **Netflix, Stripe:** Sin niveles formales, coding near-real, deep dive obligatorio.

L6 vs L7 (Staff vs Principal): no son preguntas distintas, es scope distinto en la misma historia. L6 = 1-4 equipos. L7 = 10-30+ equipos.

---

## 6. Plan de estudio (8 semanas, 2 sesiones de 90 min/semana)

| Semana | Foco |
|---|---|
| 1-3 | System Design (framework + tier Staff + deep dives) |
| 4-5 | Behavioral (tabla de proyectos + 4 sesiones temáticas) |
| 6 | Past Project Deep Dive (3 proyectos preparados) |
| 7 | Coding (5 LC Meta-tagged + 5 LC Google-tagged) |
| 8 | Mock interviews (design + behavioral + coding) |

Regla útil: corre al menos un mock estando cansado. Las entrevistas reales nunca caen en tu mejor día.

---

## 7. Antipatterns (aparecen en 3+ fuentes independientes)

1. Responder sin clarificar requirements.
2. Asumir scope ("photo sharing" $\ne$ Instagram).
3. Hablar en "we" en vez de "I".
4. STAR mecánico que aplana la historia.
5. Historias de hace 3+ años.
6. Métricas vagas ("mejoró", "rápido", "mucho").
7. No anticipar follow-ups (lo que distingue Staff).
8. Sobreingeniería para "verse senior". Cortar suele señalar más madurez.
9. No tener una historia de failure cómoda.
10. Confundir Staff con "Senior pero más rápido".

---

## 8. Ritual de tracking (Tier 2)

Sistema de seguimiento basado en frontmatter YAML en cada respuesta + script de agregación.

### Frontmatter (al inicio de cada archivo en `respuestas/`)

```yaml
---
status: not-started | in-progress | done
confidence: 0-5            # 0 = sin medir, 5 = listo para entrevista real
last_practiced: YYYY-MM-DD  # o null si no se ha tocado
attempts: 0                 # incrementar tras cada sesión
time_spent_min: 0           # acumulado
weak_tags: [estimation, sharding]  # conceptos donde fallaste
next_action: study | mock | redo | done
source_refs: [DDIA-ch5]     # opcional: dónde profundizar
---
```

### Después de cada sesión (60 seg)

1. Actualizar el frontmatter del archivo trabajado (`last_practiced`, `attempts++`, `time_spent_min`, `confidence`, `weak_tags`).
2. Anotar una línea en `respuestas/_log.md` con horario, tema y siguiente acción.

### Cada domingo (10 min)

1. Correr `python scripts/progress.py`.
2. Leer `respuestas/_dashboard.md`.
3. Planificar la próxima semana respondiendo:
   - ¿Qué categoría está sub-invertida?
   - ¿Qué hay stale y vale la pena rescatar antes de que decaiga?
   - ¿Qué `weak_tag` transversal merece sesión temática (en vez de más preguntas)?

### Reglas de calibración

- **Confidence es self-assessed**. Después de cada mock real, recalibrar retroactivamente las entradas relacionadas. Tu auto-evaluación tiende a inflarse con el tiempo.
- **Time spent no es progreso**. Si llevas 8h en una categoría y confidence sigue bajo, no es falta de tiempo, es falta de feedback. Cambia de approach.
- **Si trackear se vuelve la tarea, abandona Tier 2 y pasa a checkboxes.** El sistema sirve al estudio, no al revés.

---

## 9. Fuentes principales

1. [StaffEng.com (Will Larson) - Staff-plus interview processes](https://staffeng.com/guides/staff-plus-interview-process/)
2. [Hello Interview - 5 Keys to Staff-Level System Design](https://www.hellointerview.com/blog/staff-level-system-design)
3. [Hello Interview - FAANG Behavioral by Level](https://www.hellointerview.com/blog/ace-faang-behavioral-interview)
4. [Hello Interview - Meta E6 Staff guide](https://www.hellointerview.com/guides/meta/e6)
5. [Hello Interview - Google L6 Staff guide](https://www.hellointerview.com/guides/google/l6)
6. [Onsites.fyi - Google L6 SWE Interview Guide](https://onsites.fyi/blog/article/google-L6-software-engineer-interview-questions)
7. [Manuel Vivo (Medium) - Interviewing at Staff+ level](https://medium.com/@manuelvicnt/interviewing-at-staff-level-7a31836285e6)
8. [interviewing.io - How SWE behavioral interviews are evaluated at Meta](https://interviewing.io/blog/how-software-engineering-behavioral-interviews-are-evaluated-meta)
9. [interviewing.io - Amazon Leadership Principles](https://interviewing.io/guides/amazon-leadership-principles)
10. [Prepfully - Staff Engineer Behavioral guide](https://prepfully.com/interview-guides/staff-engineer-behavioral-interview)
11. [IGotAnOffer - Amazon Bar Raiser Interview](https://igotanoffer.com/blogs/tech/amazon-bar-raiser-interview)
12. [Exponent - Amazon Leadership Principles Interview](https://www.tryexponent.com/blog/amazon-leadership-principles-interview)
13. [Tech Interview Handbook (Yangshun) - Coding Rubrics](https://www.techinterviewhandbook.org/coding-interview-rubrics/)
14. [Ashby - Engineer Past Projects Deep Dive](https://www.ashbyhq.com/resources/engineer-past-projects-deep-dive)
15. [Metaview - How I interview engineers for impact](https://www.metaview.ai/resources/blog/how-i-interview-engineers-to-assess-ability-to-deliver-impact)
16. [Monzo - Senior Staff+ Engineering interview](https://monzo.com/blog/demystifying-the-senior-staff-engineering-interview-process)
17. [DesignGurus - Staff vs Principal beyond L6](https://designgurus.substack.com/p/staff-engineer-vs-principal-engineer)
18. [DEV.to - 64 System Design Questions Ranked](https://dev.to/arslan_ah/64-system-design-interview-questions-ranked-from-easiest-to-hardest-260m)
