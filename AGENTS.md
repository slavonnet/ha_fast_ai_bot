# AGENTS.md

Глобальный индекс с LABEL-ссылками для selective-loading.

## [INDEX.00] Чеклист чтения
- Открывайте только нужные LABEL-секции.
- У каждой сущности один source-of-truth.

## [SOURCE.ROLE_RULES]
- What: правила роли.
- Source: `agents/roles/<role_id>/AGENTS.<ROLE_ID>.md`
- Load when: запуск конкретной роли.

## [SOURCE.ROLE_STATES]
- What: states роли.
- Source: `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`
- Load when: чтение/изменение labels роли.

## [SOURCE.ORCHESTRATOR_TRANSITIONS]
- What: порядок ролей, next-step, rollback.
- Source: `agents/roles/orchestrator_story/ORCHESTRATION_STATE_MACHINE.json`
- Owner: `orchestrator_story`
- Load when: оркестрация или анализ переходов.

## [SOURCE.GLOBAL_RULES]
- `[RULE.ISSUE_WORKFLOW]` -> `agents/rules/RULES.ISSUE_WORKFLOW.md`
- `[RULE.PR_WORKFLOW]` -> `agents/rules/RULES.PR_WORKFLOW.md`
- `[RULE.CODE_DEVELOPMENT]` -> `agents/rules/RULES.CODE_DEVELOPMENT.md`
- `[RULE.TEST_DEVELOPMENT]` -> `agents/rules/RULES.TEST_DEVELOPMENT.md`
- `[RULE.DOC_DEVELOPMENT]` -> `agents/rules/RULES.DOC_DEVELOPMENT.md`
- `[RULE.STATE_MACHINE]` -> `agents/rules/RULES.STATE_MACHINE.md`

## [ROLE.CATALOG]
- `[ROLE.ORCHESTRATOR_STORY.RULES]` -> `agents/roles/orchestrator_story/AGENTS.ORCHESTRATOR_STORY.md`
- `[ROLE.TASK_COMPLETENESS_REVIEWER.RULES]` -> `agents/roles/task_completeness_reviewer/AGENTS.TASK_COMPLETENESS_REVIEWER.md`
- `[ROLE.CHILD_ISSUES_DESIGNER.RULES]` -> `agents/roles/child_issues_designer/AGENTS.CHILD_ISSUES_DESIGNER.md`
- `[ROLE.TDD_TEST_DESIGNER.RULES]` -> `agents/roles/tdd_test_designer/AGENTS.TDD_TEST_DESIGNER.md`
- `[ROLE.TDD_TEST_SUFFICIENCY_REVIEWER.RULES]` -> `agents/roles/tdd_test_sufficiency_reviewer/AGENTS.TDD_TEST_SUFFICIENCY_REVIEWER.md`
- `[ROLE.SOLUTION_ARCHITECT.RULES]` -> `agents/roles/solution_architect/AGENTS.SOLUTION_ARCHITECT.md`
- `[ROLE.ARCHITECTURE_REVIEWER.RULES]` -> `agents/roles/architecture_reviewer/AGENTS.ARCHITECTURE_REVIEWER.md`
- `[ROLE.DEVELOPER_IMPL.RULES]` -> `agents/roles/developer_impl/AGENTS.DEVELOPER_IMPL.md`
- `[ROLE.IMPLEMENTATION_REVIEWER.RULES]` -> `agents/roles/implementation_reviewer/AGENTS.IMPLEMENTATION_REVIEWER.md`
- `[ROLE.DOCUMENTATION_DEVELOPER.RULES]` -> `agents/roles/documentation_developer/AGENTS.DOCUMENTATION_DEVELOPER.md`
- `[ROLE.DOCUMENTATION_REVIEWER.RULES]` -> `agents/roles/documentation_reviewer/AGENTS.DOCUMENTATION_REVIEWER.md`
- `[ROLE.POST_MERGE_SUBTASK_ANALYZER.RULES]` -> `agents/roles/post_merge_subtask_analyzer/AGENTS.POST_MERGE_SUBTASK_ANALYZER.md`
- `[ROLE.AGENT_WORK_OPTIMIZER.RULES]` -> `agents/roles/agent_work_optimizer/AGENTS.AGENT_WORK_OPTIMIZER.md`

## [PROMPT.CONTRACT]
- `ROLE_PROMPT.md` = runtime template only.
- Rules are never duplicated from AGENTS files.

## [SELECTIVE.LOADING.QUICK_GUIDE]
- Нужны правила роли -> `[ROLE.*.RULES]`
- Нужны states роли -> `[SOURCE.ROLE_STATES]`
- Нужен next-step/rollback -> `[SOURCE.ORCHESTRATOR_TRANSITIONS]`
- Нужны общие ограничения -> `[SOURCE.GLOBAL_RULES]`
