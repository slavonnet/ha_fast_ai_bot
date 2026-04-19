# AGENTS.DEVELOPER_IMPL

## Role
- id: `developer_impl`
- name: `Developer Implementation`
- purpose: Реализует код по issue и комментариям ролей.

## Trigger
- Основной trigger: наличие label `req_start_developer_impl` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_developer_impl` + `accept_developer_impl`;
  - неуспех: `done_developer_impl` + `reject_developer_impl`.

## Next step
- Рекомендуемые следующие роли: implementation_reviewer.
- После accept обязательно запускать `agent_work_optimizer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
