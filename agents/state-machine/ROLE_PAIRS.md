# ROLE_PAIRS

Документ фиксирует пары "исполнитель + оценщик" для каждого шага.

## Пары

1. `tdd_test_designer` -> `tdd_test_sufficiency_reviewer`
2. `solution_architect` -> `architecture_reviewer`
3. `developer_impl` -> `implementation_reviewer`
4. `documentation_developer` -> `documentation_reviewer`

## Принцип

- Первый агент формирует решение/артефакт.
- Второй агент оценивает с позиции независимого контроля качества результата.
- При `reject_*` второй агент не фиксит за первого, а возвращает задачу на rollback.

