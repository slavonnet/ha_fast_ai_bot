# AGENTS.ORCHESTRATOR_STORY

## Role
- id: `orchestrator_story`
- name: `Story Orchestrator`
- purpose: Управляет state-machine Story/Subtask issue, ставит req_start_* labels и определяет rollback.

## Trigger
- Основной trigger: наличие label `req_start_orchestrator_story` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_orchestrator_story` + `accept_orchestrator_story`;
  - неуспех: `done_orchestrator_story` + `reject_orchestrator_story`.

## Next step
- Рекомендуемые следующие роли: task_completeness_reviewer.
- После accept обязательно запускать `agent_work_optimizer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
