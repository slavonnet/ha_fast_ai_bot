# AGENTS.TASK_COMPLETENESS_REVIEWER

## Role
- id: `task_completeness_reviewer`
- name: `Task Completeness Reviewer`
- purpose: Проверяет полноту описания задачи и критериев приемки.

## Trigger
- Основной trigger: наличие label `req_start_task_completeness_reviewer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_task_completeness_reviewer` + `accept_task_completeness_reviewer`;
  - неуспех: `done_task_completeness_reviewer` + `reject_task_completeness_reviewer`.

## Next step
- Рекомендуемые следующие роли: child_issues_designer.
- После accept обязательно запускать `agent_work_optimizer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
