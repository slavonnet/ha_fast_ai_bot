# [STG2] Meta: Simple MCP Integration Layer

- Type: Meta
- Milestone: Stage 2
- Depends on: STG1-META
- Labels: stage, meta

## Цель этапа
Интегрировать существующий MCP/API слой и стабилизировать контракты.

## Входные данные
- External MCP/API проекты
- Foundation слой STG1

## Выходные данные
- Стабильный integration adapter
- Контрактные тесты
- Документация boundary/abstraction

## Ограничения
- Source-of-truth во внешних репозиториях
- Без ручных несинхронизированных копий
- Backward compatibility контрактов

## Чеклист подзадач
- [ ] STG2-01 Адаптер Simple MCP
- [ ] STG2-02 Слои абстракций поверх API
- [ ] STG2-03 Контрактные snapshot тесты
- [ ] STG2-04 Error mapping и retry policies

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

