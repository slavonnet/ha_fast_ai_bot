# AGENTS.md

Глобальный индекс ролей, state-machine и общих правил проекта.

## Ключевая идея

- Каждая роль = отдельный агент-воркер.
- Для каждой роли есть:
  - `agents/roles/<role_id>/AGENTS.<ROLE_ID>.md`
  - `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`
  - `agents/roles/<role_id>/ROLE_PROMPT.md`
- Оркестрация идет через labels вида `req_start_*`, `done_*`, `accept_*`, `reject_*`.
- После каждого шага включается `agent_work_optimizer`.

## Роли

- `orchestrator_story` -> `agents/roles/orchestrator_story/AGENTS.ORCHESTRATOR_STORY.md`
- `task_completeness_reviewer` -> `agents/roles/task_completeness_reviewer/AGENTS.TASK_COMPLETENESS_REVIEWER.md`
- `child_issues_designer` -> `agents/roles/child_issues_designer/AGENTS.CHILD_ISSUES_DESIGNER.md`
- `tdd_test_designer` -> `agents/roles/tdd_test_designer/AGENTS.TDD_TEST_DESIGNER.md`
- `tdd_test_sufficiency_reviewer` -> `agents/roles/tdd_test_sufficiency_reviewer/AGENTS.TDD_TEST_SUFFICIENCY_REVIEWER.md`
- `solution_architect` -> `agents/roles/solution_architect/AGENTS.SOLUTION_ARCHITECT.md`
- `architecture_reviewer` -> `agents/roles/architecture_reviewer/AGENTS.ARCHITECTURE_REVIEWER.md`
- `developer_impl` -> `agents/roles/developer_impl/AGENTS.DEVELOPER_IMPL.md`
- `implementation_reviewer` -> `agents/roles/implementation_reviewer/AGENTS.IMPLEMENTATION_REVIEWER.md`
- `documentation_developer` -> `agents/roles/documentation_developer/AGENTS.DOCUMENTATION_DEVELOPER.md`
- `documentation_reviewer` -> `agents/roles/documentation_reviewer/AGENTS.DOCUMENTATION_REVIEWER.md`
- `post_merge_subtask_analyzer` -> `agents/roles/post_merge_subtask_analyzer/AGENTS.POST_MERGE_SUBTASK_ANALYZER.md`
- `agent_work_optimizer` -> `agents/roles/agent_work_optimizer/AGENTS.AGENT_WORK_OPTIMIZER.md`

## Общие правила (RULES)

- `agents/rules/RULES.ISSUE_WORKFLOW.md`
- `agents/rules/RULES.PR_WORKFLOW.md`
- `agents/rules/RULES.CODE_DEVELOPMENT.md`
- `agents/rules/RULES.TEST_DEVELOPMENT.md`
- `agents/rules/RULES.DOC_DEVELOPMENT.md`
- `agents/rules/RULES.STATE_MACHINE.md`

## State Machine

- Описание переходов: `agents/state-machine/STORY_SUBTASK_STATE_MACHINE.md`
- Машиночитаемая схема: `agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json`
