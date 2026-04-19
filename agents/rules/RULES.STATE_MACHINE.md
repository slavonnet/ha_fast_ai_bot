# RULES.STATE_MACHINE

## [STATE.PREFIX_POLICY]

Разрешенные префиксы state labels:

- `req_`
- `in_work_`
- `done_`
- `accept_`
- `reject_`

Правило:

- states каждой роли определяются только в `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`;
- любые другие префиксы запрещены;
- дубли state labels вне role state files запрещены.

## [TRANSITION.SOURCE]

- Переходы и next-step принадлежат только оркестратору:
  - `agents/roles/orchestrator_story/ORCHESTRATION_STATE_MACHINE.json`
- Глобальные файлы в `agents/state-machine/` — указатели (pointer), не источник правды.

## [LABEL.MUTATION_POLICY]

- `orchestrator_story` может:
  - ставить/снимать `req_start_*`;
  - выполнять cleanup labels при rollback.
- Любая не-оркестратор роль может изменять только labels своего `role_id`:
  - `in_work_<role_id>`
  - `done_<role_id>`
  - `accept_<role_id>`
  - `reject_<role_id>`
- Изменение labels других ролей запрещено.

## [ORCHESTRATION.RULES]

1. Только `orchestrator_story` определяет следующий шаг.
2. После каждого `accept_<role_id>` оркестратор запускает `req_start_agent_work_optimizer`.
3. При `reject_<role_id>` оркестратор применяет rollback policy.
4. Для параллельной безопасности role-worker обязан использовать `in_work_<role_id>` lock.
