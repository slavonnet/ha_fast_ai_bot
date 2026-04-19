# RULES.ISSUE_WORKFLOW

## Общее

- Источник истины для шагов выполнения — labels и комментарии в issue.
- Каждая Story/Subtask issue должна иметь owner и current-state label.
- Если выявлен дополнительный объем, создается дочерняя issue.
- Если выявлен техдолг, создается отдельная issue с label `tech-debt`.

## Обязательные поля issue

- постановка;
- acceptance criteria;
- список TDD UserStory;
- ссылки на связанные задачи;
- история изменений идей (comments).

## Правило завершения

Issue не может перейти в done-статус до прохождения всех req_start -> accept цепочек ролей.

