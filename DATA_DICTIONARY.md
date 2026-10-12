# Data dictionary

Scores run from 0 (the task cannot be performed by current GenAI) to 1 (it could be performed entirely by GenAI). They measure technical potential, not expected job loss. See the working paper for the method.

## `Final_Scores_ISCO08_Gmyrek_et_al_2025.xlsx` (one row per task, 3,265 rows, 427 occupations)

| Variable | Meaning |
|---|---|
| `label4d`, `label1d` | Occupation (four-digit) and major group (one-digit) labels, "code - title" |
| `ISCO_08`, `Title` | ISCO-08 four-digit code and occupation title |
| `taskID` | Task number within the occupation |
| `Task_ISCO` | Task description from ISCO-08 |
| `score_2023` | Task score from the 2023 index (ILO Working Paper 96) |
| `Weaviate Status` | Status (success or fail) of the retrieval call to the Weaviate vector database that supplies similar, already-scored tasks to the GPT-4o scoring assistant |
| `predicted_score_2025_gpt4o`, `prediction_justification_gpt4o` | 2025 score predicted by GPT-4o and the model's written reasoning |
| `weaviate_status_gemini` | The same retrieval status for the Gemini run (one task shows "fail") |
| `predicted_score_2025_gemini`, `prediction_justification_gemini` | 2025 score predicted by Gemini Flash 1.5 and its reasoning |
| `score_2025` | Final 2025 task score. For tasks with `source` = predicted it is the mean of the two model predictions. For `source` = reconciled it is the score set after expert reconciliation |
| `source` | `predicted` (3,219 tasks) or `reconciled` (46 tasks) |
| `mean_score_2023`, `mean_score_2025` | Occupation mean of its task scores (the same value on every task row of the occupation) |
| `SD_2023`, `SD_2025` | Standard deviation of the occupation's task scores |
| `potential25` | 2025 exposure category of the occupation (see below) |
| `potential23` | Category from the 2023 index: Automation Potential, Augmentation Potential, The Big Uknown (sic), Not affected |

## `4digits_with_tasks.xlsx` (one row per task, same 3,265 rows)

A reduced table used to draw the tree viewer.

| Variable | Meaning |
|---|---|
| `isco08_1d`, `isco08_2d`, `isco08_3d`, `isco08_4d` | ISCO-08 group at each level, "code - title" |
| `isco08_5d` | The task, written as "(2025 score) - task text" (the name is only a tree level, not a five-digit code) |
| `potential25` | 2025 exposure category of the occupation (see below) |
| `task_color` | Score band of the task (see below) |

## Score bands (`task_color`)

`task_color` bins the task score: Very Low (below 0.25), Low (0.25 to 0.49), Medium (0.50 to 0.74), High (0.75 and above). It is used to colour tasks in the tree viewer.

## Exposure categories (`potential25`)

`potential25` is the exposure category of the **occupation**, repeated on every task row of that occupation. It is not a task-level value. It is set from the occupation's mean (μ) and standard deviation (σ) of task scores:

| Category | Rule |
|---|---|
| Exposed: Gradient 4 | μ ≥ 0.6 and μ − σ ≥ 0.5 |
| Exposed: Gradient 3 | 0.5 ≤ μ < 0.6 and μ + σ ≥ 0.5 |
| Exposed: Gradient 2 | 0.4 ≤ μ < 0.5 and μ + σ ≥ 0.5 |
| Exposed: Gradient 1 | μ < 0.4 and μ + σ ≥ 0.5 |
| Minimal Exposure | μ < 0.5 and μ + σ > 0.4 |
| Not Exposed | everything else |

Because the category repeats on each task row, counting rows counts tasks, not occupations.
