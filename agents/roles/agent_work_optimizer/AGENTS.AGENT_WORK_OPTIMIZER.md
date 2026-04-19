# AGENTS.AGENT_WORK_OPTIMIZER

## Role
- id: `agent_work_optimizer`
- name: `Agent Work Optimizer`
- purpose: После работы каждой роли анализирует логи и предлагает улучшения AGENTS/ROLE_PROMPT/labels в отдельном PR.

## Trigger
- Основной trigger: наличие label `req_start_agent_work_optimizer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_agent_work_optimizer` + `accept_agent_work_optimizer`;
  - неуспех: `done_agent_work_optimizer` + `reject_agent_work_optimizer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_agent_work_optimizer`.
- Если `in_work_agent_work_optimizer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_agent_work_optimizer` и поставить один из финальных исходов:
  - `done_agent_work_optimizer` + `accept_agent_work_optimizer`
  - `done_agent_work_optimizer` + `reject_agent_work_optimizer`
