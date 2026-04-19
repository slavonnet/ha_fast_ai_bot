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
- Роль не изменяет state-machine конфигурацию (файлы переходов/rollback), если это не `orchestrator_story`.
- Роль не пропускает обязательные проверки по своему этапу.
- Изменение runtime labels своего role_id допускается по `agents/rules/RULES.STATE_MACHINE.md#[LABEL.MUTATION_POLICY]`; это не изменение state-machine конфигурации.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_post_merge_subtask_analyzer`.
- Если `in_work_post_merge_subtask_analyzer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_post_merge_subtask_analyzer` и поставить один из финальных исходов:
  - `done_post_merge_subtask_analyzer` + `accept_post_merge_subtask_analyzer`
  - `done_post_merge_subtask_analyzer` + `reject_post_merge_subtask_analyzer`