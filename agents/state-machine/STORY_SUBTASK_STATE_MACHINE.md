# STORY/SUBTASK STATE MACHINE (Pointer)

Этот файл не содержит правила переходов, чтобы избежать дублирования.

Single source of truth:

- `agents/state-machine/STORY_SUBTASK_STATE_MACHINE.json`

Важно:

- порядок ролей/rollback/общие правила переходов — только в JSON;
- states каждой роли (`req_/in_work_/done_/accept_/reject_`) — только в `agents/roles/<role_id>/ISSUE_LABELS_<ROLE_ID>.yaml`.
