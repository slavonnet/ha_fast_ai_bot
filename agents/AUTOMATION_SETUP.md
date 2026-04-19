# AUTOMATION_SETUP

Документ для настройки автоматизаций ролей в Cursor.

## [AUTO.PRINCIPLES]
- Один воркер = одна роль.
- Trigger воркера: label `req_start_<role_id>`.
- Prompt path:
  - role_worker: `agents/roles/<role_id>/ROLE_PROMPT.md`
  - task_worker: `agents/task_worker/<task_type_id>/ROLE_PROMPT.md`

## [AUTO.SOURCES]
- `[SOURCE.ROLE_STATES]`:
  - role_worker: `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`
  - task_worker: `agents/task_worker/<task_type_id>/ISSUE_LABELS_*.yaml`
- `[SOURCE.ORCHESTRATOR_TRANSITIONS]`:
  - current Story: `agents/task_worker/story/ORCHESTRATION_STATE_MACHINE.json`
  - recommended target structure: `agents/task_worker/<task_type_id>/ORCHESTRATION_STATE_MACHINE.json`
- `agents/WORKERS_AUTOMATION_MAP.yaml` — только generated/autodiscovery конфиг.

## [AUTO.TRIGGER]
- Event type: Issue label changed.
- Condition: label == `req_start_<role_id>` (derive from role states file).
- Scope: repository-wide.

## [AUTO.CONCURRENCY]
- Роль проверяет `in_work_<role_id>` lock перед стартом.
- Если lock есть — завершает запуск без выполнения.
- Если lock нет — ставит lock, выполняет шаг, снимает lock.

## [AUTO.POST_STEP]
- После каждого `accept_<role_id>` оркестратор ставит `req_start_agent_work_optimizer`.

## [AUTO.OPTIMIZER_SCOPE]
- Оптимизатор обрабатывает только target роль последнего шага issue.
- Изменения только в `AGENTS.<TARGET_ROLE>.md`.
