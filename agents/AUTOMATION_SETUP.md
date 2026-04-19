# AUTOMATION_SETUP

Документ для настройки автоматизаций ролей в Cursor.

## Принцип

- Один воркер = одна роль.
- Trigger воркера: добавление label `req_start_<role_id>` на issue.
- Prompt воркера: `agents/roles/<role_id>/ROLE_PROMPT.md`.
- После завершения воркер выставляет `done_<role_id>` + `accept_<role_id>` или `reject_<role_id>`.

## Источник конфигурации

Используйте файл:

- `agents/WORKERS_AUTOMATION_MAP.yaml`

Там есть:

- role_id;
- trigger_label;
- prompt_file;
- labels для done/accept/reject.

## Рекомендуемая настройка trigger

- Event type: Issue label changed (или эквивалент в Cursor Automation).
- Condition: label == `req_start_<role_id>`.
- Scope: repository-wide.

## Обязательный post-step

После каждого `accept_<role_id>` оркестратор обязан поставить:

- `req_start_agent_work_optimizer`

Оптимизатор анализирует работу роли и делает улучшения в отдельном PR.

## Постоянная ветка улучшений ролей

Рекомендуемая ветка:

- `cursor/agent-optimization-pipeline-54c5`

Только оптимизатор ролей открывает PR из этой ветки с изменениями:

- `agents/roles/**`
- `agents/rules/**`
- `AGENTS.md`
- `agents/state-machine/**`

