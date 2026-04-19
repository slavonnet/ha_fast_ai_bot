# AGENTS.TDD_TEST_DESIGNER

## Role
- id: `tdd_test_designer`
- name: `TDD Test Designer`
- purpose: Придумывает и добавляет набор TDD тестов по задаче.

## Trigger
- Основной trigger: наличие label `req_start_tdd_test_designer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_tdd_test_designer` + `accept_tdd_test_designer`;
  - неуспех: `done_tdd_test_designer` + `reject_tdd_test_designer`.

## Constraints
- Роль не изменяет state-machine напрямую (кроме `orchestrator_story`).
- Роль не пропускает обязательные проверки по своему этапу.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_tdd_test_designer`.
- Если `in_work_tdd_test_designer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_tdd_test_designer` и поставить один из финальных исходов:
  - `done_tdd_test_designer` + `accept_tdd_test_designer`
  - `done_tdd_test_designer` + `reject_tdd_test_designer`
