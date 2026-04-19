# AGENTS.md

Глобальный индекс ролей, правил и state-модели с *понятными LABEL-ссылками* для selective-loading.

## [INDEX.00] Как читать этот файл

- Агент читает только нужные секции по LABEL.
- Каждая ссылка подписана назначением (`what/why/when-load`).
- Для каждой сути есть один source-of-truth.

## [SOURCE.ROLE_RULES] Источник правил роли

- Source-of-truth: `agents/roles/<role_id>/AGENTS.<ROLE_ID>.md`
- Назначение: железные правила конкретной роли.
- Загружать: всегда при запуске роли.

## [SOURCE.ROLE_STATES] Источник states роли

- Source-of-truth: `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`
- Назначение: states конкретной роли (`req_/in_work_/done_/accept_/reject_`).
- Загружать: при проверке/изменении labels.

## [SOURCE.STATE_MACHINE] Источник переходов (next-step)

- Source-of-truth: `agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json`
- Владение: `orchestrator_story`.
- Назначение: порядок ролей, правила rollback, общие ограничения переходов.
- Загружать: только оркестратору и агентам, анализирующим оркестрацию.

## [SOURCE.RULES.GLOBAL]

- `agents/rules/RULES.ISSUE_WORKFLOW.md` (ISSUE lifecycle)
- `agents/rules/RULES.PR_WORKFLOW.md` (PR lifecycle)
- `agents/rules/RULES.CODE_DEVELOPMENT.md` (code rules)
- `agents/rules/RULES.TEST_DEVELOPMENT.md` (TDD/test rules)
- `agents/rules/RULES.DOC_DEVELOPMENT.md` (docs rules)
- `agents/rules/RULES.STATE_MACHINE.md` (state-machine global constraints)

## [ROLE.CATALOG] Список ролей

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

## [PROMPT.CONTRACT]

- `ROLE_PROMPT.md` для роли = шаблон запуска (include + runtime context), а не источник правил.
- Prompt обязан ссылаться на AGENTS role file, rules и state-machine.

## [SELECTIVE.LOADING.QUICK_GUIDE]

- Нужно понять роль -> читать `[ROLE.CATALOG]` и target `AGENTS.<ROLE>.md`.
- Нужно изменить labels роли -> читать `[SOURCE.ROLE_STATES]` target yaml роли.
- Нужно понять следующий шаг -> читать `[SOURCE.STATE_MACHINE]` JSON.
- Нужно проверить общие правила -> читать `[SOURCE.RULES.GLOBAL]`.
