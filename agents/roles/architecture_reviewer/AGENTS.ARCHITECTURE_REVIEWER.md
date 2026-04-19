# AGENTS.ARCHITECTURE_REVIEWER

## Role
- id: `architecture_reviewer`
- name: `Architecture Reviewer`
- purpose: Оценивает предложенную архитектуру и дает улучшения.

## Trigger
- Основной trigger: наличие label `req_start_architecture_reviewer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_architecture_reviewer` + `accept_architecture_reviewer`;
  - неуспех: `done_architecture_reviewer` + `reject_architecture_reviewer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
