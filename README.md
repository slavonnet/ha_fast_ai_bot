# ha_fast_ai_bot

Репозиторий запуска проекта `ha_fast_ai_bot` с акцентом на:

- поэтапную реализацию (Stage-driven development),
- разработку через тесты (TDD),
- обязательные quality gates в PR:
  - `100%` test coverage,
  - `100%` documentation coverage,
  - security audit зависимостей.

## С чего начать

1. Ознакомиться с архитектурным черновиком: `PLAN.ml`.
2. Прочитать процессные документы:
   - `docs/PROJECT_GOVERNANCE.md`
   - `docs/STAGE_CATALOG.md`
3. Использовать шаблоны GitHub:
   - `.github/ISSUE_TEMPLATE/01-stage-meta.yml`
   - `.github/ISSUE_TEMPLATE/02-stage-subtask.yml`
   - `.github/ISSUE_TEMPLATE/03-tech-debt.yml`
   - `.github/PULL_REQUEST_TEMPLATE.md`

## CI Quality Gates

В PR автоматически запускаются проверки из workflow:

- `.github/workflows/pr-quality-gates.yml`

Проверки:

- `scripts/ci/check_python_coverage.sh`
- `scripts/ci/check_docs_coverage.sh`
- `scripts/ci/check_security_audit.sh`

## Правило ведения этапов

- 1 Milestone = 1 Stage.
- 1 Stage Meta Issue описывает цель этапа, входы/выходы, ограничения и полный чеклист подзадач.
- Каждая подзадача ведется отдельной Issue (с TDD User Stories).
- Техдолг фиксируется отдельной Issue с обратной ссылкой на источник.
