# STORY/SUBTASK STATE MACHINE

Очередность ролей для Story/Subtask issue:

1. `orchestrator_story`
2. `task_completeness_reviewer`
3. `child_issues_designer`
4. `tdd_test_designer`
5. `tdd_test_sufficiency_reviewer`
6. `solution_architect`
7. `architecture_reviewer`
8. `developer_impl`
9. `implementation_reviewer`
10. `documentation_developer`
11. `documentation_reviewer`
12. `post_merge_subtask_analyzer`

## Важное правило

После каждого завершенного шага (`accept_<role_id>`) запускается `agent_work_optimizer`.

## Rollback

- Если роль ставит `reject_<role_id>`, оркестратор откатывается к предыдущей релевантной роли.
- Откат реализуется снятием labels последующих шагов и постановкой нового `req_start_*` на точку отката.

## Single source for next-step decisions

- Определение следующей роли выполняет только `orchestrator_story`.
- Переходы между ролями хранятся только в state-machine артефактах этого каталога.
- В файлах ролей (`AGENTS.*`, `ISSUE_LABELS_*`, `ROLE_PROMPT`) запрещено указывать next-step/next-role.

## Concurrency (parallel workers safety)

- Каждая роль использует lock label `in_work_<role_id>`.
- Перед стартом роль должна поставить lock, если lock уже существует — роль не стартует.
- После завершения роль снимает lock и ставит финальные статус labels.
- Это предотвращает одновременный захват одной и той же роли несколькими агентами.
