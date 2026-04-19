# [STG5] Meta: NoLLM Fast Paths

- Type: Meta
- Milestone: Stage 5
- Depends on: STG4-META
- Labels: stage, meta

## Цель этапа
Вынести частые команды в deterministic pipelines без LLM.

## Входные данные
- Логи частых интентов
- Роутинг и executor pipeline

## Выходные данные
- Deterministic intent parser
- Fallback в LLM
- Метрики эффективности fast-path

## Ограничения
- No false success
- Fallback при низкой уверенности обязателен
- Расширяемость словаря/грамматики

## Чеклист подзадач
- [ ] STG5-01 Top-command parser
- [ ] STG5-02 Deterministic executor mapping
- [ ] STG5-03 Uncertainty thresholds
- [ ] STG5-04 Regression tests по golden-сценариям

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

