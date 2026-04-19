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

## Next step
- Рекомендуемые следующие роли: tdd_test_designer.
- После accept обязательно запускать `agent_work_optimizer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
