# [STG4] Meta: Router, Modes, Prompt Packs

- Type: Meta
- Milestone: Stage 4
- Depends on: STG3-META
- Labels: stage, meta

## Цель этапа
Реализовать мультирежимный роутинг и профильную конфигурацию промптов/инструментов.

## Входные данные
- Executor и aggregated tools
- Спецификация режимов PLAN.ml

## Выходные данные
- Router rule-first + fallback
- Mode-specific policies
- Тесты маршрутизации

## Ограничения
- Минимальная динамика system prompt
- Запрет cross-mode leakage
- Ambiguity => clarification

## Чеклист подзадач
- [ ] STG4-01 ACTION/INFO/WEB/NO_LLM mode routing
- [ ] STG4-02 Confidence scoring
- [ ] STG4-03 Clarification policy
- [ ] STG4-04 Prompt and tool exposure guards

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

