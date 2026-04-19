# Project Start Readiness

Документ фиксирует критерии "проект готов к старту реализации".

## Gate R0 — Repository Process Foundation

- [ ] Прочитаны и приняты документы:
  - [ ] `docs/PROJECT_GOVERNANCE.md`
  - [ ] `docs/STAGE_CATALOG.md`
  - [ ] `docs/ISSUE_BACKLOG.md`
- [ ] Используются шаблоны Issue/PR из `.github/`
- [ ] Правила TDD (5-10 UserStory на подзадачу) приняты командой

## Gate R1 — GitHub Tracking Ready

- [ ] Созданы milestones `Stage 0` .. `Stage 8`
- [ ] Созданы базовые labels процесса:
  - [ ] `stage`
  - [ ] `meta`
  - [ ] `subtask`
  - [ ] `tech-debt`
  - [ ] `blocked`
  - [ ] `risk`
- [ ] Созданы все Meta issues (`STG0..STG8`)
- [ ] Созданы все Subtask issues (`STG0-01..STG8-04`)
- [ ] В каждой Subtask issue указан parent Meta Issue

## Gate R2 — Quality Gates Ready

- [ ] Включен workflow `.github/workflows/pr-quality-gates.yml`
- [ ] Проверки `coverage/docs/security` проходят по правилам
- [ ] Включены process checks:
  - [ ] integrity issue seed pack
  - [ ] PR governance structure

## Gate R3 — Execution Discipline Ready

- [ ] Для каждой задачи есть owner
- [ ] Для каждой задачи есть acceptance criteria
- [ ] Техдолг фиксируется отдельными issue с обратными ссылками
- [ ] Перед закрытием этапа выполняется Stage closure review

## Gate R4 — Ready to Start Stage 1

- [ ] Stage 0 Meta Issue закрыт
- [ ] Нет незакрытых блокеров по процессу
- [ ] Сформирован стартовый набор задач для Stage 1

## Итог

Проект считается готовым к старту реализации, когда все пункты R0..R4 отмечены как выполненные.
