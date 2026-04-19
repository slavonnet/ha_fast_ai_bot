# [STG4-04] Prompt and tool exposure guards

- Type: Subtask
- Stage: STG4 (Router, Modes, Prompt Packs)
- Track: H4 QA, Docs & Release
- Parent Meta Issue: STG4-META
- Depends on: STG4-META, STG3-04
- Labels: subtask

## Постановка
Prompt and tool exposure guards

## TDD UserStory (5)
1. As a platform maintainer, I want 'Prompt and tool exposure guards' реализован(а), so that этап 4 можно закрыть без функциональных дыр.
2. As a QA engineer, I want тесты happy-path для 'Prompt and tool exposure guards', so that базовый сценарий стабильно проходит.
3. As a QA engineer, I want edge-case тесты для 'Prompt and tool exposure guards', so that система корректно ведет себя на границах входных данных.
4. As an operator, I want error/fallback сценарии для 'Prompt and tool exposure guards', so that отказ не приводит к ложному успеху.
5. As a release owner, I want docs обновлены по 'Prompt and tool exposure guards', so that изменения воспроизводимы без чтения PLAN.ml.

## Acceptance criteria
- [ ] Реализован функционал подзадачи
- [ ] Есть failing->green цикл тестов
- [ ] Негативные/пограничные сценарии покрыты тестами
- [ ] Обновлена документация по изменению
- [ ] Нет незафиксированного техдолга

## Лог изменений идеи
- Добавлять комментариями по мере реализации

