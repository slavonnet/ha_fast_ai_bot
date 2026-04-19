# GitHub Setup Runbook

Пошаговый runbook для разворачивания рабочей структуры проекта.

## 1) Создание milestones

Создать milestones:

- `Stage 0`
- `Stage 1`
- `Stage 2`
- `Stage 3`
- `Stage 4`
- `Stage 5`
- `Stage 6`
- `Stage 7`
- `Stage 8`

## 2) Создание labels

Обязательные labels:

- `stage`
- `meta`
- `subtask`
- `tech-debt`
- `blocked`
- `risk`

Рекомендуемые labels:

- `track:h1-contracts`
- `track:h2-runtime`
- `track:h3-integration`
- `track:h4-qa-docs-release`

## 3) Импорт Meta/Subtask issues

Источник заготовок:

- Meta issues: `docs/issues/meta/*.md`
- Subtask issues: `docs/issues/subtasks/*.md`

Хелпер команд:

- `scripts/github/create_issues_from_seed.sh`

Примечание: скрипт печатает команды `gh issue create`, их можно выполнить в среде с правами записи в GitHub.

## 4) Привязка задач и зависимостей

Для каждой Subtask issue:

1. Указать parent Meta Issue.
2. Указать зависимости из поля `Depends on`.
3. Добавить track label (`track:h1...h4`).

## 5) Правило работы по этапу

1. Открываем Meta Issue этапа.
2. Запускаем работу по Subtask issues параллельно.
3. Каждую подзадачу ведем через TDD (5-10 UserStory).
4. При выявлении техдолга — сразу создаем Tech Debt issue.
5. Перед закрытием этапа — Stage closure review.

## 6) Release readiness

После закрытия связанных задач этапа:

- проверить, что ничего не упущено;
- проверить CI quality gates;
- обновить документацию;
- только затем помечать этап закрытым.
