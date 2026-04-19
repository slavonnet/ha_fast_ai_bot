# RULES.PR_WORKFLOW

- PR обязан ссылаться на исходную issue/story.
- PR обязан отражать, какие роли уже прошли accept.
- Перед merge обязательны: code review, TDD coverage check, docs check.
- После merge запускается `post_merge_subtask_analyzer`.
- Если по итогам выявлены пробелы — создаются новые issue и связываются с исходной.

