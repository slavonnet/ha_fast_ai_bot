# AGENTS.TDD_TEST_SUFFICIENCY_REVIEWER

## Role
- id: `tdd_test_sufficiency_reviewer`
- name: `TDD Test Sufficiency Reviewer`
- purpose: Проверяет, что тесты полные и с запасом по вариантам.

## Trigger
- Основной trigger: наличие label `req_start_tdd_test_sufficiency_reviewer` в Story/Subtask issue.

## Input context
- Текущая issue и ее комментарии;
- Связанные issues/PR;
- Глобальные правила из `agents/rules/`;
- Специфика роли из `ROLE_PROMPT.md`.

## Output requirements
- Добавить comment с результатом работы роли;
- Обновить labels:
  - успех: `done_tdd_test_sufficiency_reviewer` + `accept_tdd_test_sufficiency_reviewer`;
  - неуспех: `done_tdd_test_sufficiency_reviewer` + `reject_tdd_test_sufficiency_reviewer`.

## Constraints
- Роль не изменяет state-machine конфигурацию (файлы переходов/rollback), если это не `orchestrator_story`.
- Роль не пропускает обязательные проверки по своему этапу.
- Изменение runtime labels своего role_id допускается по `agents/rules/RULES.STATE_MACHINE.md#[LABEL.MUTATION_POLICY]`; это не изменение state-machine конфигурации.

## Concurrency lock (in_work)
- Перед началом роль должна atomically выставить `in_work_tdd_test_sufficiency_reviewer`.
- Если `in_work_tdd_test_sufficiency_reviewer` уже есть, роль не начинает работу и завершает запуск без изменений.
- После завершения роль обязана снять `in_work_tdd_test_sufficiency_reviewer` и поставить один из финальных исходов:
  - `done_tdd_test_sufficiency_reviewer` + `accept_tdd_test_sufficiency_reviewer`
  - `done_tdd_test_sufficiency_reviewer` + `reject_tdd_test_sufficiency_reviewer`