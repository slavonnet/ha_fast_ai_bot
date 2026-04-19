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
- `Stage 9`

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

### Рекомендуемый порядок импорта

1. Сначала создать все Meta issues (`STG0..STG9`).
2. Затем создать все Subtask issues.
3. После импорта пройтись по Subtask и добавить:
   - ссылку на Parent Meta,
   - ссылки на `Depends on`,
   - owner.

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

## 7) Визуализация общего прогресса в GitHub

Рекомендуется создать один GitHub Project (board) `HA Fast AI Bot — Master Delivery`.

### Обязательные поля

- `Stage` (single select): `Stage 0` ... `Stage 9`
- `Track` (single select): `H1/H2/H3/H4`
- `Type` (single select): `Meta`, `Subtask`, `Tech Debt`
- `Risk` (single select): `Low/Medium/High/Critical`

### Рекомендуемые представления (Views)

1. **Overview (Table)**  
   Все issues, группировка по `Stage`, сортировка по `Type`.

2. **Stage Board**  
   Group by: `Stage`, filter: `is:open`.

3. **Track Board**  
   Group by: `Track`, filter: `is:open`.

4. **Tech Debt**  
   Filter: `label:tech-debt is:open`, group by `Risk`.

5. **Blocked Items**  
   Filter: `label:blocked is:open`.

6. **Tail Stage (STG9)**  
   Filter: `milestone:"Stage 9"`.

### Быстрые фильтры для наглядности

- `is:open label:meta`
- `is:open label:subtask milestone:"Stage 1"`
- `is:open label:subtask label:track:h2-runtime`
- `is:open label:tech-debt`


## 8) Автоматическое создание issue/обновление прогресса (CLI)

> Выполнять в среде, где `gh` имеет права записи.

### Шаг 1. One-shot bootstrap (создать milestones/labels/issues)

```bash
./scripts/github/apply_github_bootstrap.sh
```

Скрипт выполняет идемпотентно:
- создание milestones `Stage 0..9`,
- создание/обновление labels,
- создание Meta/Subtask issues из seed-пакета,
- вывод сводки `total/open/closed` по каждому этапу.

Если нужен режим только "показать команды" (без выполнения), используйте:

```bash
./scripts/github/bootstrap_project_setup.sh
```

### Шаг 2. Сгенерировать команды создания issues

```bash
./scripts/github/create_issues_from_seed.sh > /tmp/create-issues.sh
bash /tmp/create-issues.sh
```

### Шаг 3. Наглядный прогресс по этапам

```bash
# Сколько задач закрыто по milestone
for s in {0..9}; do
  echo "Stage $s"
  gh issue list --state all --search "milestone:\"Stage $s\"" --json state --jq 'group_by(.state) | map({state: .[0].state, count: length})'
done
```

### Шаг 4. Отдельно смотреть хвосты

```bash
gh issue list --state all --search "milestone:\"Stage 9\"" --limit 200
```
