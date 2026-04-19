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

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_orchestrator_story`.
- Если `in_work_orchestrator_story` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_orchestrator_story` и поставить один из финальных исходов:
  - `done_orchestrator_story` + `accept_orchestrator_story`
  - `done_orchestrator_story` + `reject_orchestrator_story`
