# Stage Catalog

Документ определяет этапы проекта в формате:

- цель этапа;
- входные данные;
- выходные данные;
- ограничения;
- список ожидаемых подзадач.

---

## Stage 0 — Discovery & Process Setup

### Цель
Подготовить управляемую среду разработки: правила, шаблоны, контроль качества, структура этапов.

### Входные данные
- Архитектурный черновик `PLAN.ml`;
- реализованные external репозитории `ha_simple_mcp`, `ha-api-mcp`;
- требования к процессу ведения проекта.

### Выходные данные
- Документы governance и stage catalog;
- шаблоны Meta/Subtask/Tech Debt issues и PR;
- CI quality gates: test coverage, docs coverage, security audit.

### Ограничения
- Никакой "скрытой" разработки без issue/PR;
- каждый gate должен быть автоматизирован;
- процесс должен быть минималистичным (без раздутых правил).

### Подзадачи (минимум)
1. Формализовать модель Milestone/Meta/Subtask.
2. Описать TDD + UserStory policy.
3. Ввести шаблоны GitHub.
4. Ввести базовые CI-проверки PR.

---

## Stage 1 — Core Runtime Foundation

### Цель
Создать базовый каркас оркестратора: контракты, policy engine, telemetry, конфигурации профилей.

### Входные данные
- Stage 0 artifacts;
- контракты и принципы из `PLAN.ml`.

### Выходные данные
- Реализация базовых runtime модулей;
- тесты на контракты и базовую логику;
- документация API и архитектуры foundation-слоя.

### Ограничения
- TDD-first (5–10 UserStory на каждую подзадачу);
- строгая типизация контрактов;
- трассируемость всех ключевых действий.

### Подзадачи (минимум)
1. Request/Plan/Result contracts.
2. Config profiles.
3. Policy engine MVP.
4. Structured logging + IDs.

---

## Stage 2 — Simple MCP Integration Layer

### Цель
Интегрировать и стандартизовать взаимодействие с уже существующим простым MCP/API слоем.

### Входные данные
- external проекты MCP/API;
- foundation layer из Stage 1.

### Выходные данные
- Стабильный integration adapter;
- контрактные тесты совместимости;
- обновленная документация по boundary/abstraction.

### Ограничения
- source-of-truth в внешних репозиториях;
- никаких ручных несинхронизированных копий API-контрактов;
- backward compatibility на уровне контрактов.

### Подзадачи (минимум)
1. Адаптер Simple MCP.
2. Слои абстракций "поверх API".
3. Контрактные snapshot тесты.
4. Error mapping и retry policies.

---

## Stage 3 — Aggregated MCP & Deterministic Executor

### Цель
Добавить high-level инструменты, батчинг и deterministic execution для сокращения числа LLM-циклов.

### Входные данные
- стабильный low-level adapter из Stage 2;
- policy/telemetry из Stage 1.

### Выходные данные
- Aggregated tools;
- executor state machine;
- интеграционные тесты на сценарии из нескольких шагов.

### Ограничения
- ограничение на количество LLM вызовов;
- идемпотентность action-операций;
- строгая валидация аргументов.

### Подзадачи (минимум)
1. `resolve_and_act` и `batch_control`.
2. DAG/dependency execution.
3. Retry/backoff/timeouts.
4. Anti-duplication и stop policy.

---

## Stage 4 — Router, Modes, Prompt Packs

### Цель
Реализовать мультирежимный роутинг и профильную конфигурацию инструментов/промптов.

### Входные данные
- executor/aggregated tools;
- спецификации режимов из `PLAN.ml`.

### Выходные данные
- Router (rule-first + fallback);
- mode-specific prompt/tool policies;
- тесты качества маршрутизации.

### Ограничения
- минимальная динамика в system prompts;
- недопустим cross-mode leakage инструментов;
- ambiguity => обязательная clarification.

### Подзадачи (минимум)
1. ACTION/INFO/WEB/NO_LLM mode routing.
2. Confidence scoring.
3. Clarification policy.
4. Prompt and tool exposure guards.

---

## Stage 5 — NoLLM Fast Paths

### Цель
Вынести частые сценарии в deterministic pipelines без LLM.

### Входные данные
- логи частых интентов;
- инфраструктура роутинга и исполнения.

### Выходные данные
- deterministic intent parser;
- fallback механизм в LLM при uncertainty;
- метрики эффективности fast-path.

### Ограничения
- no false success;
- fallback при низкой уверенности обязателен;
- поддержка расширения словаря/грамматики.

### Подзадачи (минимум)
1. Top-command parser.
2. Deterministic executor mapping.
3. Uncertainty thresholds.
4. Regression tests по golden-сценариям.

---

## Stage 6 — Multi-Provider and Resilience

### Цель
Поддержать разные провайдеры/инстансы и отказоустойчивость.

### Входные данные
- стабильные режимы и executor pipeline;
- наблюдаемость и policy controls.

### Выходные данные
- multi-provider routing config;
- circuit breaker + failover;
- тесты на деградацию провайдера.

### Ограничения
- прозрачные правила выбора провайдера;
- безопасный fallback без потери контроля;
- аудит всех переключений.

### Подзадачи (минимум)
1. Provider profiles by mode.
2. Circuit breaker policies.
3. Graceful degradation flows.
4. Reliability/load tests.

---

## Stage 7 — UX Progress & Speech Feedback

### Цель
Улучшить UX за счет прогресса выполнения и цикла улучшения распознавания.

### Входные данные
- runtime telemetry;
- execution events;
- voice/use-case данные.

### Выходные данные
- progress events lifecycle;
- журнал ошибок распознавания;
- workflow обновления словаря/фраз.

### Ограничения
- пользователь не должен оставаться без статуса;
- изменения словаря только через review;
- полная история версий словаря.

### Подзадачи (минимум)
1. Started/discovering/executing/completed events.
2. Speech error logging.
3. Suggested phrase pipeline.
4. Dictionary versioning and rollback.

---

## Stage 8 — Production Hardening & Release Readiness

### Цель
Довести систему до production-готовности.

### Входные данные
- реализация всех предыдущих этапов;
- накопленный риск-реестр и tech debt backlog.

### Выходные данные
- security hardening;
- load/chaos reports;
- runbooks и финальные эксплуатационные документы;
- release checklist.

### Ограничения
- ни один критичный риск не должен остаться без owner/issue;
- quality gates обязательны;
- stage closure review обязателен.

### Подзадачи (минимум)
1. Security review and fixes.
2. Load and chaos tests.
3. Incident runbooks.
4. Release criteria verification.
