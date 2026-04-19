# [STG8] Meta: Production Hardening & Release Readiness

- Type: Meta
- Milestone: Stage 8
- Depends on: STG7-META
- Labels: stage, meta

## Цель этапа
Довести проект до production-готовности.

## Входные данные
- Реализация STG0..STG7
- Risk register и tech debt backlog

## Выходные данные
- Security hardening
- Load/chaos reports
- Runbooks
- Release checklist

## Ограничения
- Ни один критичный риск без owner/issue
- Quality gates обязательны
- Stage closure review обязателен

## Чеклист подзадач
- [ ] STG8-01 Security review and fixes
- [ ] STG8-02 Load and chaos tests
- [ ] STG8-03 Incident runbooks
- [ ] STG8-04 Release criteria verification

## Stage closure review
- [ ] Все planned подзадачи закрыты или перенесены с ссылкой
- [ ] Для частично реализованных фич созданы отдельные follow-up issues
- [ ] Технический долг зафиксирован отдельными issues
- [ ] PR quality gates (coverage/docs/security) зеленые
- [ ] В meta issue добавлен итоговый лог изменений идей этапа

