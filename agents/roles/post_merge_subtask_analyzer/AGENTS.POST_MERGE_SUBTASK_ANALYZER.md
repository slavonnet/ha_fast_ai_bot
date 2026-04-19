# AGENTS.POST_MERGE_SUBTASK_ANALYZER

## Role
- id: `post_merge_subtask_analyzer`
- name: `Post-Merge Subtask Analyzer`
- purpose: После мержа проверяет, что нужные подзадачи созданы и во всех связанных задачах есть итоговый комментарий.

## Trigger
- Основной trigger: наличие label `req_start_post_merge_subtask_analyzer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_post_merge_subtask_analyzer` + `accept_post_merge_subtask_analyzer`;
  - неуспех: `done_post_merge_subtask_analyzer` + `reject_post_merge_subtask_analyzer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.
