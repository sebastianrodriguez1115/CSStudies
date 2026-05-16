# Workbook de preguntas Staff Engineer+

Lista pura de preguntas para estudiar una por una. Contexto, frameworks y antipatterns en `staff-interview-guide.md`.

Marca con `[x]` las preguntas que ya practicaste.

---

## 1. System Design

### 1.1 Foundational (preguntas que siguen apareciendo)

- [ ] 1. Diseña un URL shortener (Bitly).
- [ ] 2. Diseña Twitter / X.
- [ ] 3. Diseña Instagram.
- [ ] 4. Diseña WhatsApp / Messenger.
- [ ] 5. Diseña Dropbox / Google Drive.
- [ ] 6. Diseña un newsfeed.
- [ ] 7. Diseña un rate limiter.
- [ ] 8. Diseña un notification system.
- [ ] 9. Diseña un job queue / distributed task scheduler.
- [ ] 10. Diseña un caching layer (LRU distribuido).

### 1.2 Tier Staff (las que distinguen Staff de Senior)

- [ ] 11. Diseña Google Docs (operational transforms vs CRDTs).
- [ ] 12. Diseña un collaborative whiteboard tipo Miro.
- [ ] 13. Diseña YouTube / Netflix.
- [ ] 14. Diseña un ad click aggregator (lambda architecture).
- [ ] 15. Diseña un payment system / digital wallet.
- [ ] 16. Diseña un stock exchange / orderbook matching engine.
- [ ] 17. Diseña un distributed message queue (Kafka-like).
- [ ] 18. Diseña LeetCode (judging sandbox seguro a escala).
- [ ] 19. Diseña proximity service (Uber/DoorDash dispatch).
- [ ] 20. Diseña Top K songs widget (heavy hitters, count-min sketch).
- [ ] 21. Diseña un online game leaderboard.
- [ ] 22. Diseña YouTube likes counter (sharded counters).
- [ ] 23. Diseña un distributed cache.
- [ ] 24. Diseña Facebook Live Comments.
- [ ] 25. Diseña ChatGPT / inference serving platform.
- [ ] 26. Diseña un ticket booking system (seat hold + concurrencia).
- [ ] 27. Diseña un distributed blocking/denylist system.
- [ ] 28. Diseña un trending hashtags service.
- [ ] 29. Diseña un server health monitoring system.
- [ ] 30. Diseña un ad targeting / auction system.

### 1.3 Follow-ups típicos (practicar respuestas a estos sobre cada diseño)

- [ ] 31. "¿Qué pasa si tu hash colisiona con 100M URLs?"
- [ ] 32. "¿Cómo manejas hot partitions en el sharding scheme?"
- [ ] 33. "Dibuja el path crítico de una request durante un failover."
- [ ] 34. "¿Por qué Cassandra y no DynamoDB aquí?"
- [ ] 35. "¿Cómo lo operarías a las 2am? Define SLO, error budget, alertas."
- [ ] 36. "Si tuvieras que cortar la mitad del diseño porque sólo te queda 1 sprint, ¿qué cortas?"
- [ ] 37. "Mañana otro equipo quiere consumir este stream. ¿Le das Kafka, una API o una vista materializada?"
- [ ] 38. "¿Qué cambia en tu diseño si el ratio read:write se invierte?"
- [ ] 39. "Si te dijera que el 1% del tráfico genera el 50% de la carga, ¿qué ajustas?"
- [ ] 40. "¿Cómo migrarías de tu diseño viejo al nuevo sin downtime?"

---

## 2. Behavioral / Leadership

### 2.1 Influence sin autoridad

- [ ] 1. Tell me about a time you influenced a decision without authority.
- [ ] 2. Tell me about a time you drove a major technical decision across multiple teams without direct authority.
- [ ] 3. Describe a time you convinced leadership to invest in technical debt reduction.
- [ ] 4. Tell me about a time you made an architectural decision that had company-wide implications.
- [ ] 5. Describe a time you sunsetted a system that teams were attached to.

### 2.2 Ambigüedad y juicio

- [ ] 6. How do you create clarity in ambiguous situations?
- [ ] 7. Tell me about a project that was ambiguous or underspecified.
- [ ] 8. Tell me about a risk you identified that others didn't see.
- [ ] 9. Describe a moment you changed direction based on new information.
- [ ] 10. Tell me about a time you had to make a fast decision and live with the results.
- [ ] 11. Tell me about a time you had to work on a project where the end goal was clear but the path was not.
- [ ] 12. Describe a situation where you had to estimate effort with many unknowns.

### 2.3 Conflicto y disagreement

- [ ] 13. Tell me about a time you had a conflict with a coworker. How did you resolve it?
- [ ] 14. Describe a disagreement you handled between teams.
- [ ] 15. Tell me about a time you pushed back on leadership.
- [ ] 16. Describe a time you had to de-escalate a conflict.
- [ ] 17. Tell me about a time you needed to overcome external obstacles.
- [ ] 18. Describe a time you had to collaborate with someone whose vision conflicted with yours.

### 2.4 Trade-offs y resultados

- [ ] 19. Describe a complex trade-off you had to make.
- [ ] 20. How do you balance velocity vs stability?
- [ ] 21. Tell me about a long-term project that required sustained leadership.
- [ ] 22. Tell me about a time a project took longer than expected.
- [ ] 23. Describe a time you aligned stakeholders with conflicting priorities.
- [ ] 24. What's the most consequential decision you made?
- [ ] 25. Describe a time you changed your mind about an important technical decision.

### 2.5 Mentoría y multiplicación

- [ ] 26. What's your approach to mentoring senior engineers?
- [ ] 27. Tell me about a time you helped a senior engineer grow into a staff-level contributor.
- [ ] 28. Tell me about a systemic issue you solved (no parche puntual).
- [ ] 29. Describe a time you defined or influenced the technical strategy for your org.
- [ ] 30. Tell me about a complex, multi-quarter technical initiative you drove.

### 2.6 Failure y growth

- [ ] 31. Tell me about a failure that changed how you operate.
- [ ] 32. Tell me about a time you did not effectively manage your projects.
- [ ] 33. Tell me about a time you received a performance review you felt was unjustified.
- [ ] 34. What is your engineering philosophy?
- [ ] 35. Tell me about a valuable lesson you learned recently.

### 2.7 Migración / refactor / arquitectura

- [ ] 36. Tell me about a migration or large-scale refactor.
- [ ] 37. Tell me about a project where the architecture was contested.
- [ ] 38. Describe a time you had to work with legacy code you didn't know.
- [ ] 39. Describe a time you made architectural decisions for evolving requirements.

---

## 3. Past Project Deep Dive

Las 12 preguntas canónicas. Prepara un proyecto-template y respóndelas todas con ese mismo proyecto.

- [ ] 1. Cuéntame de un proyecto del que estés orgulloso (90 seg, dejar hook).
- [ ] 2. Dibújame el high-level design.
- [ ] 3. Qué hiciste tú vs el equipo (primera persona).
- [ ] 4. Por qué elegiste X en vez de Y (esperar 3-5 de estas).
- [ ] 5. Qué fue lo más difícil técnicamente.
- [ ] 6. Qué se rompió en producción y cómo respondieron.
- [ ] 7. Qué harías distinto hoy.
- [ ] 8. Quién estaba en desacuerdo y cómo lo resolvieron.
- [ ] 9. Cuál fue el impacto en métricas duras.
- [ ] 10. Por qué este proyecto necesitaba un Staff y no un Senior.
- [ ] 11. Cómo convenciste a leadership / a otros equipos.
- [ ] 12. Si fueras el próximo Staff que toma este sistema, qué te documentarías.

### 3.1 Follow-ups técnicos típicos para tu deep dive

- [ ] 13. ¿Cuál fue el bug más raro que debuggeaste?
- [ ] 14. ¿Qué assumption hicieron al inicio que resultó ser equivocada?
- [ ] 15. ¿Cómo midieron el éxito antes de lanzar?
- [ ] 16. ¿Qué telemetry, dashboards y alertas montaron?
- [ ] 17. ¿Por qué este lenguaje/framework y no otro?
- [ ] 18. ¿Cuál fue el componente que más cambió desde el diseño inicial?

---

## 4. Coding

### 4.1 Top Google L6 (Staff)

- [ ] 1. LC 269 Alien Dictionary.
- [ ] 2. LC 56 Merge Intervals.
- [ ] 3. LC 1254 Number of Closed Islands.
- [ ] 4. LC 733 Flood Fill.
- [ ] 5. LC 913 Cat and Mouse.

### 4.2 Top Meta E6 (Staff)

- [ ] 6. LC 1249 Minimum Remove to Make Valid Parentheses.
- [ ] 7. LC 314 Binary Tree Vertical Order Traversal.
- [ ] 8. LC 528 Random Pick with Weight.
- [ ] 9. LC 408 Valid Word Abbreviation.
- [ ] 10. LC 227 Basic Calculator II.

### 4.3 Near-real (Netflix, Stripe, OpenAI)

- [ ] 11. Diseña e implementa un LRU cache.
- [ ] 12. Implementa un log parser con concurrencia.
- [ ] 13. Diseña un SQL engine mínimo (INSERT, SELECT, WHERE).
- [ ] 14. Diseña un web crawler.
- [ ] 15. Implementa un read/write lock.
- [ ] 16. Implementa un rate limiter (token bucket).
- [ ] 17. Implementa una thread-safe queue.
- [ ] 18. Implementa un consistent hashing ring.

### 4.4 Preguntas del interviewer durante el coding (preparar respuestas)

- [ ] 19. ¿Cuál es la complejidad runtime y memoria?
- [ ] 20. ¿Qué edge cases consideraste?
- [ ] 21. ¿Cómo testarías esto sin un debugger?
- [ ] 22. ¿Qué cambia si los inputs son 1000x más grandes?
- [ ] 23. ¿Cómo lo refactorizarías para producción?

---

## 5. Role-Related Knowledge (Google) / Technical Deep Dive

Preguntas frontera para tu área. Practica una por dominio:

### 5.1 Distributed systems

- [ ] 1. Explica internamente Raft. ¿Cuándo no lo usarías?
- [ ] 2. Diferencia entre Paxos, Raft y ZAB.
- [ ] 3. Gossip protocol: cuándo y por qué.
- [ ] 4. Vector clocks vs Lamport timestamps.
- [ ] 5. CRDTs: cuándo eligen sobre OT.
- [ ] 6. Consistency models: linearizable, sequential, causal, eventual.

### 5.2 Storage

- [ ] 7. B-Tree vs LSM-Tree: cuándo y por qué.
- [ ] 8. Write-ahead logs: por qué son universales.
- [ ] 9. Compaction strategies en LSM (size-tiered vs leveled).
- [ ] 10. Bloom filters: cuándo valen la pena el costo.

### 5.3 Networking

- [ ] 11. gRPC vs REST vs GraphQL.
- [ ] 12. Backpressure: cómo lo implementarías end-to-end.
- [ ] 13. Circuit breakers y bulkheads.
- [ ] 14. TCP slow start: cuándo te muerde.

### 5.4 Operations / SRE

- [ ] 15. SLO, SLI, SLA: define cada uno con un ejemplo.
- [ ] 16. Error budgets: cómo los usarías para decidir un release.
- [ ] 17. Capacity planning: walk-through end to end.
- [ ] 18. Postmortem culture: blameless de verdad o teatro.

### 5.5 Específicas de mobile/frontend (si aplica)

- [ ] 19. MVI vs MVVM vs MVC: cuándo cada uno.
- [ ] 20. Unidirectional Data Flow: por qué importa.
- [ ] 21. Dependency injection: trade-offs entre Hilt/Dagger/Koin.
- [ ] 22. Threading model: corrutinas vs threads vs reactive streams.

---

## 6. Amazon Leadership Principles (specific)

Una historia por LP. Tag cada historia con el LP correspondiente. Las más probadas en Staff+:

- [ ] 1. **Ownership:** Tell me about a time you went beyond your job description.
- [ ] 2. **Ownership:** Describe a time you took ownership of a problem that wasn't yours.
- [ ] 3. **Deliver Results:** Tell me about a time you worked against tight deadlines.
- [ ] 4. **Deliver Results:** Describe a project where you exceeded expectations.
- [ ] 5. **Have Backbone:** Tell me about a time you disagreed with your manager.
- [ ] 6. **Have Backbone:** Describe a time you had to commit to a decision you disagreed with.
- [ ] 7. **Earn Trust:** Tell me about a time you had to rebuild a broken relationship.
- [ ] 8. **Earn Trust:** Describe how you built credibility in a new team.
- [ ] 9. **Dive Deep:** Tell me about a time you had to dig into data to find a root cause.
- [ ] 10. **Dive Deep:** Describe a metric you found that others had missed.
- [ ] 11. **Hire and Develop the Best:** Tell me about someone you mentored to promotion.
- [ ] 12. **Hire and Develop the Best:** Describe a hire who didn't work out and what you learned.
- [ ] 13. **Think Big:** Tell me about a proposal that went beyond the original scope.
- [ ] 14. **Think Big:** Describe a long-term bet you made.
- [ ] 15. **Are Right A Lot:** Tell me about a time you used judgment over data.
- [ ] 16. **Are Right A Lot:** Describe a time you were wrong and what you did.
- [ ] 17. **Customer Obsession:** Tell me about a time you sacrificed an internal goal for a customer.
- [ ] 18. **Invent and Simplify:** Tell me about a time you simplified a complex system.
- [ ] 19. **Insist on Highest Standards:** Tell me about a time you pushed back on "good enough".
- [ ] 20. **Bias for Action:** Tell me about a time you took a calculated risk without full data.
- [ ] 21. **Frugality:** Tell me about a constraint that made the solution better.
- [ ] 22. **Learn and Be Curious:** Tell me about a technology you learned outside your role.

---

## 7. Preguntas meta para auto-evaluación

Antes de un mock, responde estas honestamente. Si fallas alguna, vuelve al material correspondiente.

- [ ] 1. ¿Puedo articular en una frase el WHY de cada proyecto en mi tabla?
- [ ] 2. ¿Tengo al menos 3 historias con scope de 2+ equipos?
- [ ] 3. ¿Tengo una historia de failure cómoda?
- [ ] 4. ¿Tengo métricas duras (no vagas) para mis impactos?
- [ ] 5. ¿Puedo dibujar de memoria los componentes de un payment system y un message queue?
- [ ] 6. ¿Puedo defender 3 trade-offs distintos (SQL vs NoSQL, mono vs micro, sync vs async)?
- [ ] 7. ¿Tengo un proyecto-template para deep dive listo, con diagrama?
- [ ] 8. ¿Puedo cambiar de opinión en una respuesta sin sonar inseguro?
