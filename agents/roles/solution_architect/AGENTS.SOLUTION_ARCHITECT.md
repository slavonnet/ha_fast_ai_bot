# AGENTS.SOLUTION_ARCHITECT

## Role
- id: `solution_architect`
- name: `Solution Architect`
- purpose: Предлагает архитектуру реализации с учетом постановки, правил и текущего кода.

## Trigger
- Основной trigger: наличие label `req_start_solution_architect` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_solution_architect` + `accept_solution_architect`;
  - неуспех: `done_solution_architect` + `reject_solution_architect`.

## Constraints
- Роль не изменяет state-machine конфигурацию (файлы переходов/rollback), если это не `orchestrator_story`.
- Роль не пропускает обязательные проверки по своему этапу.
- Изменение runtime labels своего role_id допускается по `agents/rules/RULES.STATE_MACHINE.md#[LABEL.MUTATION_POLICY]`; это не изменение state-machine конфигурации.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_solution_architect`.
- Если `in_work_solution_architect` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_solution_architect` и поставить один из финальных исходов:
  - `done_solution_architect` + `accept_solution_architect`
  - `done_solution_architect` + `reject_solution_architect`