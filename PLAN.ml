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
