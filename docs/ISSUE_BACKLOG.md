# ISSUE BACKLOG (горизонтальная декомпозиция)

Этот каталог позволяет понять этапы и нарезку задач без чтения `PLAN.ml`.

## Каркас
- 9 Meta issues (STG0..STG8)
- 36 Subtask issues (по 4 на каждый Stage)
- Схема зависимостей: Stage N зависит от Stage N-1 по одноименному треку

## Реестр issues

| ID | Type | Stage | Track | Depends on |
|---|---|---|---|---|
| STG0-META | Meta | Discovery & Process Setup | — | - |
| STG0-01 | Subtask | Discovery & Process Setup | H1 Contracts & Schemas | STG0-META |
| STG0-02 | Subtask | Discovery & Process Setup | H2 Runtime & Execution | STG0-META |
| STG0-03 | Subtask | Discovery & Process Setup | H3 Integration & Reliability | STG0-META |
| STG0-04 | Subtask | Discovery & Process Setup | H4 QA, Docs & Release | STG0-META |
| STG1-META | Meta | Core Runtime Foundation | — | STG0-META |
| STG1-01 | Subtask | Core Runtime Foundation | H1 Contracts & Schemas | STG1-META, STG0-01 |
| STG1-02 | Subtask | Core Runtime Foundation | H2 Runtime & Execution | STG1-META, STG0-02 |
| STG1-03 | Subtask | Core Runtime Foundation | H3 Integration & Reliability | STG1-META, STG0-03 |
| STG1-04 | Subtask | Core Runtime Foundation | H4 QA, Docs & Release | STG1-META, STG0-04 |
| STG2-META | Meta | Simple MCP Integration Layer | — | STG1-META |
| STG2-01 | Subtask | Simple MCP Integration Layer | H1 Contracts & Schemas | STG2-META, STG1-01 |
| STG2-02 | Subtask | Simple MCP Integration Layer | H2 Runtime & Execution | STG2-META, STG1-02 |
| STG2-03 | Subtask | Simple MCP Integration Layer | H3 Integration & Reliability | STG2-META, STG1-03 |
| STG2-04 | Subtask | Simple MCP Integration Layer | H4 QA, Docs & Release | STG2-META, STG1-04 |
| STG3-META | Meta | Aggregated MCP & Deterministic Executor | — | STG2-META |
| STG3-01 | Subtask | Aggregated MCP & Deterministic Executor | H1 Contracts & Schemas | STG3-META, STG2-01 |
| STG3-02 | Subtask | Aggregated MCP & Deterministic Executor | H2 Runtime & Execution | STG3-META, STG2-02 |
| STG3-03 | Subtask | Aggregated MCP & Deterministic Executor | H3 Integration & Reliability | STG3-META, STG2-03 |
| STG3-04 | Subtask | Aggregated MCP & Deterministic Executor | H4 QA, Docs & Release | STG3-META, STG2-04 |
| STG4-META | Meta | Router, Modes, Prompt Packs | — | STG3-META |
| STG4-01 | Subtask | Router, Modes, Prompt Packs | H1 Contracts & Schemas | STG4-META, STG3-01 |
| STG4-02 | Subtask | Router, Modes, Prompt Packs | H2 Runtime & Execution | STG4-META, STG3-02 |
| STG4-03 | Subtask | Router, Modes, Prompt Packs | H3 Integration & Reliability | STG4-META, STG3-03 |
| STG4-04 | Subtask | Router, Modes, Prompt Packs | H4 QA, Docs & Release | STG4-META, STG3-04 |
| STG5-META | Meta | NoLLM Fast Paths | — | STG4-META |
| STG5-01 | Subtask | NoLLM Fast Paths | H1 Contracts & Schemas | STG5-META, STG4-01 |
| STG5-02 | Subtask | NoLLM Fast Paths | H2 Runtime & Execution | STG5-META, STG4-02 |
| STG5-03 | Subtask | NoLLM Fast Paths | H3 Integration & Reliability | STG5-META, STG4-03 |
| STG5-04 | Subtask | NoLLM Fast Paths | H4 QA, Docs & Release | STG5-META, STG4-04 |
| STG6-META | Meta | Multi-Provider and Resilience | — | STG5-META |
| STG6-01 | Subtask | Multi-Provider and Resilience | H1 Contracts & Schemas | STG6-META, STG5-01 |
| STG6-02 | Subtask | Multi-Provider and Resilience | H2 Runtime & Execution | STG6-META, STG5-02 |
| STG6-03 | Subtask | Multi-Provider and Resilience | H3 Integration & Reliability | STG6-META, STG5-03 |
| STG6-04 | Subtask | Multi-Provider and Resilience | H4 QA, Docs & Release | STG6-META, STG5-04 |
| STG7-META | Meta | UX Progress & Speech Feedback | — | STG6-META |
| STG7-01 | Subtask | UX Progress & Speech Feedback | H1 Contracts & Schemas | STG7-META, STG6-01 |
| STG7-02 | Subtask | UX Progress & Speech Feedback | H2 Runtime & Execution | STG7-META, STG6-02 |
| STG7-03 | Subtask | UX Progress & Speech Feedback | H3 Integration & Reliability | STG7-META, STG6-03 |
| STG7-04 | Subtask | UX Progress & Speech Feedback | H4 QA, Docs & Release | STG7-META, STG6-04 |
| STG8-META | Meta | Production Hardening & Release Readiness | — | STG7-META |
| STG8-01 | Subtask | Production Hardening & Release Readiness | H1 Contracts & Schemas | STG8-META, STG7-01 |
| STG8-02 | Subtask | Production Hardening & Release Readiness | H2 Runtime & Execution | STG8-META, STG7-02 |
| STG8-03 | Subtask | Production Hardening & Release Readiness | H3 Integration & Reliability | STG8-META, STG7-03 |
| STG8-04 | Subtask | Production Hardening & Release Readiness | H4 QA, Docs & Release | STG8-META, STG7-04 |

## Где лежат тела issues
- Meta: `docs/issues/meta/`
- Subtasks: `docs/issues/subtasks/`
- Общая инструкция: `docs/issues/README.md`
