3) Подробное ТЗ (черновик production-grade)
3.1 Цели
Бизнес-цель
Сделать разговорного агента для HA, который:

быстро отвечает,
надежно выполняет действия,
масштабируется на разные LLM/провайдеры,
поддерживает deterministic режимы без LLM.
Технические цели
p95 warm latency:
простое действие (1 зона/1 домен): <= 3s
сложный сценарий с 10 backend-вызовами: <= 5-7s (при <=2 LLM инференсах)
0 ложных “выполнил”, если action не выполнился.
100% трассируемость всех вызовов.
3.2 Функциональные требования
FR-01. Режимы обработки
Поддержать режимы:

ACTION
INFO
WEB
SCRIPT/AUTOMATION
NO_LLM (детерминированный)
Для каждого режима:

своя модель (опционально),
свой prompt,
свой tool allowlist,
свой think policy.
FR-02. Router
Router определяет режим и стратегию выполнения:

rule-based first (быстрый),
LLM-router fallback (опционально),
confidence score + reason,
если ambiguity > threshold -> clarification.
FR-03. Planner (опционально для сложных задач)
Планировщик возвращает strict JSON plan:

список шагов,
зависимости между шагами,
параметры,
валидационные условия.
FR-04. Executor (ядро)
Executor:

выполняет шаги плана,
поддерживает батчинг,
повтор с backoff,
дедупликация повторных одинаковых вызовов,
таймауты,
остановка по policy.
FR-05. MCP слой (2 сервера)
Simple HA API MCP
прокси к базовым HA capability:
discover/read/action/script/automation/history/index
автогенерация схемы из HA service registry + entity model
versioned schema + compatibility mode.
Aggregated MCP
high-level инструменты в “один заход”, например:

resolve_and_act(...)
batch_control(...)
query_status_aggregated(...)
safe_execute_plan(...)
discover_filter_rank(...)
FR-06. Structured Output
Capability matrix per provider/model:
native json schema support?
tool call stability?
runtime toggle:
strict JSON schema on/off
fallback parser pipeline.
FR-07. NoLLM Pipelines
Для частых команд:

быстрый intent parser (regex+grammar+lexicon),
deterministic execution,
fallback в LLM только при неуверенности.
FR-08. Multi-provider / Multi-instance
отдельные профили:
Router model
Planner model
Executor model
возможность направлять режимы на разные инстансы.
FR-09. Progress & UX
прогресс-события:
started / discovering / executing / done / failed
UI канал:
HA event bus / diagnostic panel
финальный чат-ответ краткий
для voice: опциональные промежуточные TTS.
FR-10. Speech-to-Phase feedback loop
журнал ошибок распознавания/интента
авто-предложения в словарь/фразы
ручное утверждение оператором
версия словаря и откат.
3.3 Нефункциональные требования
NFR-01 Performance
keep_alive configurable (-1, 60m, etc.)
fixed num_ctx per profile
стабильный prompt prefix (минимум динамики)
ограничение LLM итераций.
NFR-02 Reliability
idempotency keys на action шаги
retry policy per tool
circuit breaker для деградировавших провайдеров
graceful fallback.
NFR-03 Security
role/action allowlist (по domain/service)
область видимости (area-based permissions)
запрет опасных сервисов без подтверждения.
NFR-04 Observability
structured logs (request_id, conversation_id, step_id)
metrics:
latency by stage
tool success/error rate
LLM token/time stats
fallback frequency
distributed tracing.
NFR-05 Compatibility
versioned MCP contracts
backward-compatible config migrations
feature flags.
3.4 Архитектура (логическая)
Ingress (HA Conversation Adapter)
Router
Policy Engine (ограничения, бюджет, разрешения)
Planner (если нужно)
Executor
MCP Simple / MCP Aggregated
Progress & Audit
Response Composer
3.5 Контракты данных (минимум)
RequestEnvelope
request_id
conversation_id
user_text
locale
current_area
mode_hint (optional)
ExecutionPlan
plan_id
mode
steps[]
max_tool_calls
stop_conditions
PlanStep
step_id
tool_name
args
depends_on[]
retry_policy
timeout_ms
ExecutionResult
success
executed_steps[]
failed_steps[]
user_summary
debug_summary
3.6 Критерии приёмки (acceptance)
Для “выключи свет на кухне”:
<=2 tool calls,
no empty args,
no false success.
Для “статус датчиков в кухне”:
<=2-3 tool calls,
корректный summary.
Для 10-шагового сценария:
<=2 LLM инференса,
остальное deterministic,
укладывается в SLO.
3.7 Тестирование
Unit:
router, parser, planner validator, executor retries.
Contract:
MCP schema compatibility.
Integration:
mock HA + real tool chain.
Load:
burst requests, concurrent conversations.
Chaos:
provider timeout, HA partial failures.
Golden tests:
fixed prompts/intents with expected tool sequence.
4) План реализации (по этапам)
Этап 0 — Discovery/Design
финализировать контракты и SLO
capability matrix по провайдерам
риск-реестр
Выход: архитектурный RFC + API spec.

Этап 1 — Core Foundation
RequestEnvelope, tracing, metrics, config profiles
policy engine (budget, allowlist)
Выход: базовый runtime каркас.

Этап 2 — Simple HA API MCP
базовые tools + автоген схемы
versioning + schema snapshot tests
Выход: стабильный low-level MCP.

Этап 3 — Aggregated MCP
resolve_and_act / batch_control / query_aggregated
зависимости/батчинг/валидация аргументов
Выход: high-level tools для low-latency.

Этап 4 — MyAiChatBot Orchestrator
router + mode configs
prompt packs per mode
think on/off policy
structured output toggles
Выход: рабочий multi-mode агент.

Этап 5 — NoLLM Fast Paths
deterministic intents для top N команд
fallback в LLM при uncertainty
Выход: резкое снижение latency на частых сценариях.

Этап 6 — Multi-provider routing
разные провайдеры для router/planner/executor
failover и circuit breaker
Выход: устойчивость и оптимизация стоимости/скорости.

Этап 7 — Speech-to-Phase feedback loop
сбор ошибок фраз
semi-auto словарь
review workflow
Выход: постепенный рост качества распознавания.

Этап 8 — Production hardening
security audit
load + chaos
документация/операционные runbooks
Выход: готовность к эксплуатационному релизу.

5) Главный практический совет
Если цель — “10 backend вызовов быстро”, делай так:

LLM максимум 1-2 раза
все шаги между ними — кодом
aggregated MCP + deterministic executor
stable prompt prefix + keep_alive
Если хочешь, следующим шагом дам тебе сразу:

минимальный JSON schema для PlannerOutput,
пример state machine Executor-а,
референс конфиг профилей (router/planner/executor) — чтобы можно было стартовать проект без белых пятен.


------------------------

Проектный план: Multi-Mode HA Agent с отдельным Simple HA MCP
0) Решение по архитектуре (зафиксировано)
Принято:

Simple HA MCP развиваем как отдельный продукт (библиотека + мини-плагин).
Основной продукт (MyAiChatBot) использует его как source-of-truth извне, но в runtime может иметь вендор-снимок (snapshot) для монолитной поставки.
Дублирования кода “руками” в двух местах — не допускаем.
1) Цели проекта
1.1 Функциональные
Поддержка режимов: ACTION, INFO, WEB, SCRIPT/AUTOMATION, NO_LLM.
Надежный tool-calling без ложных “выполнено”.
Поддержка нескольких LLM-провайдеров/инстансов.
Поддержка structured output (где доступно).
1.2 Нефункциональные
Минимизировать число LLM-инференсов на запрос (идеал: 1–2).
Обеспечить быстрый warm-path (после прогрева модели).
Полная трассируемость: кто вызвал, какой tool, с какими аргументами, какой результат.
Безопасность: allowlist, scope-политики, idempotency, audit trail.
2) Репозитории и границы ответственности
2.1 simple-ha-mcp-lib (отдельный репозиторий)
Тип: Python библиотека
Ответственность:

Унифицированный доступ к HA API.
Модель доменных операций (discover/read/action/history/script/automation/index).
Генерация/валидация JSON-схем для MCP tools.
Версионирование API-контрактов.
Типы, DTO, ошибки, retry-политики базового уровня.
2.2 simple-ha-mcp-plugin (отдельный мини-плагин)
Тип: HA integration / MCP server adapter
Ответственность:

Экспонировать simple-ha-mcp-lib как MCP endpoint.
Минимальный runtime-слой (auth, transport, health, metrics).
Без “умной” оркестрации.
2.3 my-ai-chatbot (основной продукт)
Тип: HA conversation orchestrator
Ответственность:

Router / Planner / Executor.
Aggregated MCP (high-level tools).
Режимы, профили, провайдеры, think-policy.
NoLLM пайплайны.
UX прогресса, telemetry, policy engine.
3) Модель поставки без дублирования кода
3.1 Source-of-truth
Исходники Simple HA MCP живут только в его репозиториях.
3.2 Подключение в my-ai-chatbot
Поддержать 2 режима:

Dependency mode: установка по версии из package registry/git tag.
Vendored snapshot mode: импорт snapshot в third_party/simple_ha_mcp/ автоскриптом.
3.3 Правила snapshot
Snapshot подтягивается только из tag/release.
Скрипт синхронизации генерирует:
SNAPSHOT_SOURCE
UPSTREAM_TAG
UPSTREAM_COMMIT
changelog diff.
Ручные правки внутри snapshot запрещены.
4) Логическая архитектура рантайма
Ingress Adapter (HA Conversation)
Router (rule-based first, LLM fallback)
Policy Engine (лимиты, безопасность, budget)
Planner (опционально, только для сложных задач)
Executor (детерминированный state machine)
Tool Layer
Simple HA MCP (низкоуровневый)
Aggregated MCP (высокоуровневый)
Progress/Audit/Telemetry
Response Composer
5) MCP-слой: спецификация
5.1 Simple HA MCP (базовый)
Минимальный набор:

get_index
discover_entities
get_entity_details
get_entity_history
perform_action
run_script
run_automation
list_areas
list_domains
Требования:

Строгие inputSchema/outputSchema.
Явные коды ошибок.
Совместимость версий контрактов.
5.2 Aggregated MCP (оптимизированный)
Примеры high-level tools:

resolve_and_act(...)
batch_control(...)
query_status_aggregated(...)
safe_execute_plan(...)
discover_filter_rank(...)
Требования:

Минимум LLM-циклов.
Батчинг.
Дедупликация.
Зависимости шагов (DAG).
Идемпотентность.
6) Оркестратор MyAiChatBot
6.1 Режимы
ACTION: контроль устройств.
INFO: текущее состояние.
HISTORY: история изменений.
WEB: внешний поиск/URL.
NO_LLM: детерминированные сценарии.
6.2 Профили провайдеров
Для каждого режима:

своя модель,
свой prompt pack,
свои tools,
свой think policy,
таймауты и fallback.
6.3 Think policy
think=on: только роутинг/планирование сложных задач.
think=off: промежуточные шаги execution и рутинный tool-calling.
7) Prompt/Context стратегия
7.1 Разделение prompt
System Prompt: стабильные правила, без динамики.
Technical Prompt: минимальная динамика (режим, актуальный index, area/time/date если реально нужно).
7.2 Ограничение tool exposure
На каждом шаге показывать только релевантные tools:

ACTION: без WEB.
WEB: без HA-control.
INFO/HISTORY: без perform_action (если не запрошено действие).
7.3 Structured Output
Включать строго там, где провайдер стабильно поддерживает.
Иначе fallback на robust parser + validator + repair policy.
8) Скорость и SLO для сценария “10 вызовов”
8.1 Ключевое правило
Нельзя делать 10 LLM-инференсов.
Нужна схема:

LLM (план) — 1 раз.
Executor выполняет 10 вызовов детерминированно (без LLM между шагами).
Финал — шаблонный ответ или короткий 2-й LLM.
8.2 Оптимизации
keep_alive (длительный/бессрочный).
фиксированный num_ctx.
стабильный префикс prompt.
батчинг perform_action.
анти-луп (запрет повтора одинакового tool+args).
dependency-aware parallel execution.
9) UX и прогресс
9.1 Без тишины
Промежуточные progress events:
started
discovering
executing
completed/failed
9.2 Каналы
Чат: краткий финальный ответ.
Голос: опциональные короткие TTS-статусы.
Диагностика: подробный execution log.
10) Безопасность и политики
Action allowlist (domain/service).
Area-based access scope.
Подтверждение для рискованных действий.
Idempotency key на action шаги.
Audit trail всех вызовов.
Rate limits и circuit breaker по провайдерам/инструментам.
11) Наблюдаемость (Observability)
Correlation IDs: request_id, conversation_id, plan_id, step_id.
Метрики:
latency by stage,
LLM calls/request,
tool success/failure,
fallback ratio,
retries/timeouts.
Трассировка:
Router decision,
Plan JSON,
Step execution graph,
Final outcome.
12) Тестовая стратегия
12.1 Unit
Router, policy engine, planner validator, executor machine.
12.2 Contract
MCP schema compatibility tests.
Snapshot diff checks на обновления upstream.
12.3 Integration
Mock HA + real orchestration.
Реальные сценарии ACTION/INFO/WEB.
12.4 Load/Chaos
Параллельные диалоги.
Таймауты HA/LLM.
Провайдер недоступен.
Частичные ошибки шагов.
13) Дорожная карта реализации (этапы)
Этап A — Foundation
Каркас проекта, config profiles, telemetry, policy engine.
Определить JSON-контракты (RequestEnvelope, ExecutionPlan, ExecutionResult).
Результат: базовый runtime без полного функционала.

Этап B — Simple HA MCP (отдельно)
simple-ha-mcp-lib + simple-ha-mcp-plugin.
Стабильные базовые tools + версии схем.
Результат: reusable MCP базового уровня.

Этап C — Интеграция snapshot/dependency
Автоскрипт sync snapshot.
Политика source-of-truth.
CI-проверка snapshot provenance.
Результат: монолитная поставка без ручного дублирования.

Этап D — Aggregated MCP
high-level tools, батчинг, дедуп, dependencies.
Результат: уменьшение LLM-циклов и latency.

Этап E — Orchestrator (Router/Planner/Executor)
mode routing,
think-policy,
strict JSON planning,
deterministic executor.
Результат: управляемый production-пайплайн.

Этап F — NoLLM Fast Paths
Частые команды без LLM.
Fallback в LLM при uncertainty.
Результат: максимальная скорость на типовых сценариях.

Этап G — Multi-provider + UX progress
Разные провайдеры по ролям.
Progress events/TTS.
Failover/circuit breaker.
Результат: устойчивость и удобство.

Этап H — Hardening
Security review.
Load/chaos.
Документация и runbooks.
Результат: готовность к прод-эксплуатации.

14) Acceptance Criteria (минимум)
Команда “выключи свет на кухне”:
<=2 tool calls,
без пустых args,
без ложного success.
Сценарий из 10 backend-вызовов:
<=2 LLM-инференса,
корректный порядок/зависимости шагов,
укладывается в целевой warm latency.
Обновление Simple HA MCP:
воспроизводимый snapshot sync,
без ручных правок дублированного кода.
15) Definition of Done (DoD)
Контракты и схемы зафиксированы и версионируются.
Есть unit + integration + contract + load базовый набор.
Политики безопасности применены и протестированы.
Метрики/логи/trace доступны в диагностике.
Snapshot/dependency pipeline автоматизирован.
Документация по режимам, провайдерам, fallback и инцидентам готова.
Если хочешь, следующим сообщением дам готовый шаблон структуры репозиториев + CI workflow (YAML-план) для snapshot sync и контрактных тестов.
