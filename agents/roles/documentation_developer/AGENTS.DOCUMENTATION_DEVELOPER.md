# AGENTS.DOCUMENTATION_DEVELOPER

## Role
- id: `documentation_developer`
- name: `Documentation Developer`
- purpose: Обновляет документацию проекта в соответствии с изменениями в PR.

## Trigger
- Основной trigger: наличие label `req_start_documentation_developer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_documentation_developer` + `accept_documentation_developer`;
  - неуспех: `done_documentation_developer` + `reject_documentation_developer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
