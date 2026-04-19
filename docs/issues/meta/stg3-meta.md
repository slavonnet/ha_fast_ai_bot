# [STG3] Meta: Aggregated MCP & Deterministic Executor

- Type: Meta
- Milestone: Stage 3
- Depends on: STG2-META
- Labels: stage, meta

## Цель этапа
Добавить high-level инструменты и deterministic execution для сокращения LLM-циклов.

## Входные данные
- Low-level adapter STG2
- Policy/telemetry STG1

## Выходные данные
- Aggregated tools
- Executor state machine
- Интеграционные multi-step тесты

## Ограничения
- Ограничение числа LLM вызовов
- Идемпотентность action-операций
- Строгая валидация аргументов

## Чеклист подзадач
- [ ] STG3-01 resolve_and_act и batch_control
- [ ] STG3-02 DAG/dependency execution
- [ ] STG3-03 Retry/backoff/timeouts
- [ ] STG3-04 Anti-duplication и stop policy

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

