# [STG1] Meta: Core Runtime Foundation

- Type: Meta
- Milestone: Stage 1
- Depends on: STG0-META
- Labels: stage, meta

## Цель этапа
Создать каркас оркестратора: контракты, policy engine, telemetry, конфигурации профилей.

## Входные данные
- Артефакты STG0
- Контракты и принципы PLAN.ml

## Выходные данные
- Базовые runtime-модули
- Тесты foundation-слоя
- Документация API foundation

## Ограничения
- TDD-first
- Строгая типизация контрактов
- Полная трассируемость ключевых действий

## Чеклист подзадач
- [ ] STG1-01 Request/Plan/Result contracts
- [ ] STG1-02 Config profiles
- [ ] STG1-03 Policy engine MVP
- [ ] STG1-04 Structured logging + IDs

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

