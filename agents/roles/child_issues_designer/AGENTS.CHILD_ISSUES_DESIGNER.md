# AGENTS.CHILD_ISSUES_DESIGNER

## Role
- id: `child_issues_designer`
- name: `Child Issues Designer`
- purpose: Проверяет/создает дочерние issues для декомпозиции.

## Trigger
- Основной trigger: наличие label `req_start_child_issues_designer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_child_issues_designer` + `accept_child_issues_designer`;
  - неуспех: `done_child_issues_designer` + `reject_child_issues_designer`.

## Constraints
- Роль не изменяет state-machine конфигурацию (файлы переходов/rollback), если это не `orchestrator_story`.
- Роль не пропускает обязательные проверки по своему этапу.
- Изменение runtime labels своего role_id допускается по `agents/rules/RULES.STATE_MACHINE.md#[LABEL.MUTATION_POLICY]`; это не изменение state-machine конфигурации.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_child_issues_designer`.
- Если `in_work_child_issues_designer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_child_issues_designer` и поставить один из финальных исходов:
  - `done_child_issues_designer` + `accept_child_issues_designer`
  - `done_child_issues_designer` + `reject_child_issues_designer`