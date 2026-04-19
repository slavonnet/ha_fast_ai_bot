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

## Constraints
- Роль не изменяет state-machine конфигурацию (файлы переходов/rollback), если это не `orchestrator_story`.
- Роль не пропускает обязательные проверки по своему этапу.
- Изменение runtime labels своего role_id допускается по `agents/rules/RULES.STATE_MACHINE.md#[LABEL.MUTATION_POLICY]`; это не изменение state-machine конфигурации.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_developer_impl`.
- Если `in_work_developer_impl` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_developer_impl` и поставить один из финальных исходов:
  - `done_developer_impl` + `accept_developer_impl`
  - `done_developer_impl` + `reject_developer_impl`