# AGENTS.DOCUMENTATION_REVIEWER

## Role
- id: `documentation_reviewer`
- name: `Documentation Reviewer`
- purpose: Перепроверяет качество и полноту изменений документации.

## Trigger
- Основной trigger: наличие label `req_start_documentation_reviewer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_documentation_reviewer` + `accept_documentation_reviewer`;
  - неуспех: `done_documentation_reviewer` + `reject_documentation_reviewer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_documentation_reviewer`.
- Если `in_work_documentation_reviewer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_documentation_reviewer` и поставить один из финальных исходов:
  - `done_documentation_reviewer` + `accept_documentation_reviewer`
  - `done_documentation_reviewer` + `reject_documentation_reviewer`
