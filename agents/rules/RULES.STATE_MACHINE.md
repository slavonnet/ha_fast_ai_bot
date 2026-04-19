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

## [STATE.TERMS]

- **State-machine configuration**: файлы переходов/rollback (например orchestrator state machine JSON).
- **Runtime state**: labels на issue (`req_`, `in_work_`, `done_`, `accept_`, `reject_`).
- В этой модели `issue_label == runtime state`.
- Изменение runtime labels по policy разрешено и не считается изменением state-machine configuration.

## [TRANSITION.SOURCE]

- Переходы и next-step принадлежат только соответствующему оркестратору типа задачи:
  - current Story: `agents/roles/orchestrator_story/ORCHESTRATION_STATE_MACHINE.json`
  - recommended target structure: `agents/task_worker/<task_type_id>/ORCHESTRATION_STATE_MACHINE.json`
- Глобальные файлы в `agents/state-machine/` — указатели (pointer), не источник правды.

## [LABEL.MUTATION_POLICY]

- Оркестраторы могут:
  - ставить/снимать `req_start_*`;
  - выполнять cleanup labels при rollback.
- Любая не-оркестратор роль может изменять только labels своего `role_id`:
  - `in_work_<role_id>`
  - `done_<role_id>`
  - `accept_<role_id>`
  - `reject_<role_id>`
- Изменение labels других ролей запрещено.

## [ORCHESTRATION.RULES]

1. Только соответствующий orchestrator конкретного типа задачи определяет следующий шаг.
2. После каждого `accept_<role_id>` оркестратор запускает `req_start_agent_work_optimizer`.
3. При `reject_<role_id>` оркестратор применяет rollback policy.
4. Для параллельной безопасности role-worker обязан использовать `in_work_<role_id>` lock.
