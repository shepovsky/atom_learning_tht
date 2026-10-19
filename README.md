# Atom Learning — SATs Score Modelling
## Objective

Build a reproducible dbt pipeline in BigQuery that calculates an estimated SATs scaled score from learners' responses to assessment questions.

## Source Data analysis

### Issues and proposed solutions:

1. **Duplicate responses**

   The `RESPONSES` data contains records that are identical apart from `response_id`. The expected grain is one record per `session_id` / `question_id` combination. Some combinations contain both `TRUE` and `FALSE` values for `is_correct`, while other response attributes, including `answered_at`, are identical.

   **Solution:** Deduplicate responses, retaining one record per `session_id` / `question_id` combination. Where records conflict on `is_correct`, retain the correct response, assuming the source system permits learners to correct an incorrect answer but does not allow a correct answer to be changed to incorrect. This is a business assumption that should be confirmed with the source-system owner.

   Implemented in `int_responses_deduped`.

2. **Subjects without official SATs conversion tables**

   The available GOV.UK Key Stage 2 conversion tables cover Mathematics, English grammar, punctuation and spelling, and English Reading. The source data also contains subjects such as Science, Wellbeing, Screeners and Verbal Reasoning, for which these conversion tables are not applicable.

   **Solution:** Restrict the scoring pipeline to supported subjects and exclude unsupported subjects from the final scored results.

   Implemented in `int_responses_maths_and_eng`.

3. **Responses without matching assessment settings**

   The `RESPONSES` data contains 1,433 records associated with 56 distinct `session_id` values that are absent from `ASSESSMENT_SETTINGS`.

   **Solution:** Exclude orphaned response records from the scoring pipeline.

   Implemented in `int_responses_cleaned`.

### Data assumptions

1. **Assessment completeness**

   `ASSESSMENT_SETTINGS.total_questions` represents the expected number of questions in an assessment. This should match the number of deduplicated responses for each session.

   **Solution:** Compare the expected and actual question counts and expose an `is_complete` flag in `mart_session_results_with_sats_score`. Sessions that do not meet this condition can be investigated separately.

2. **English subject mapping**

   The source data distinguishes English as a subject, whereas the official conversion tables distinguish English grammar, punctuation and spelling from English Reading.

   **Solution:** Use the English grammar, punctuation and spelling conversion table for English assessments. This is a modelling assumption rather than an official equivalence between the two assessment types.

   Implemented in `int_score_conversion`.

## Approach

The pipeline consists of:

1. Staging models for the four raw source tables.
2. A seed containing the SATs score conversion data sourced from GOV.UK.
3. Intermediate models to deduplicate responses, restrict supported subjects and remove orphaned records.
4. A score conversion model that prepares the conversion data for use in the scoring logic.
5. A final mart that aggregates session results, applies the scoring methodology and identifies incomplete assessments.
1. **Duplicate responses**

   The `RESPONSES` data contains records that are identical apart from `response_id`. The expected grain is one record per `session_id` / `question_id` combination. Some combinations contain both `TRUE` and `FALSE` values for `is_correct`, while other response attributes, including `answered_at`, are identical.

   **Solution:** Deduplicate responses, retaining one record per `session_id` / `question_id` combination. Where records conflict on `is_correct`, retain the correct response, assuming the source system permits learners to correct an incorrect answer but does not allow a correct answer to be changed to incorrect. This is a business assumption that should be confirmed with the source-system owner.

   Implemented in `int_responses_deduped`.

2. **Subjects without official SATs conversion tables**

   The available GOV.UK Key Stage 2 conversion tables cover Mathematics, English grammar, punctuation and spelling, and English Reading. The source data also contains subjects such as Science, Wellbeing, Screeners and Verbal Reasoning, for which these conversion tables are not applicable.

   **Solution:** Restrict the scoring pipeline to supported subjects and exclude unsupported subjects from the final scored results.

   Implemented in `int_responses_maths_and_eng`.

3. **Responses without matching assessment settings**

   The `RESPONSES` data contains 1,433 records associated with 56 distinct `session_id` values that are absent from `ASSESSMENT_SETTINGS`.

   **Solution:** Exclude orphaned response records from the scoring pipeline.

   Implemented in `int_responses_cleaned`.

### Data assumptions

1. **Assessment completeness**

   `ASSESSMENT_SETTINGS.total_questions` represents the expected number of questions in an assessment. This should match the number of deduplicated responses for each session.

   **Solution:** Compare the expected and actual question counts and expose an `is_complete` flag in `mart_session_results_with_sats_score`. Sessions that do not meet this condition can be investigated separately.

2. **English subject mapping**

   The source data distinguishes English as a subject, whereas the official conversion tables distinguish English grammar, punctuation and spelling from English Reading.

   **Solution:** Use the English grammar, punctuation and spelling conversion table for English assessments. This is a modelling assumption rather than an official equivalence between the two assessment types.

   Implemented in `int_score_conversion`.

## Approach

The pipeline consists of:

1. Staging models for the four raw source tables.
2. A seed containing the SATs score conversion data sourced from GOV.UK.
3. Intermediate models to deduplicate responses, restrict supported subjects and remove orphaned records.
4. A score conversion model that prepares the conversion data for use in the scoring logic.
5. A final mart that aggregates session results, applies the scoring methodology and identifies incomplete assessments.

## Scoring

Official Key Stage 2 scaled scores cannot be inferred directly from arbitrary assessment percentages. The pipeline therefore uses the official conversion tables as a reference for estimating scaled scores.

For each session, the proportion of correct answers is calculated as:

`total_correct / total_questions`

The corresponding conversion row is selected by finding the highest `raw_score / highest_raw_score` ratio that does not exceed the learner's proportion of correct answers. The associated `scaled_score` is returned.

This is a proportional approximation, not an official SATs scoring procedure. It assumes that the proportion of correct answers can be compared with the raw-score proportions in the conversion table.

## Data Quality and Testing

The project includes dbt data tests for key data-quality requirements, including:

- Uniqueness of the `session_id` / `question_id` combination in the deduplicated responses.
- Non-null requirements for key fields.
- Accepted values for selected categorical fields.
- Validation of the final model's assumptions through session-level completeness checks.

Run the project's configured models and tests to validate the pipeline.

## Running the Project

Configure the BigQuery connection and dbt profile for your environment, then run:

```bash
dbt debug
dbt deps
dbt build
```

To generate and view the project documentation:

```bash
dbt docs generate
dbt docs serve
```

## Documentation and AI Usage

- `plan.md` summarises the project workflow and key tasks.
- `prompts.md` summarises how AI tools were used during planning, implementation and troubleshooting.

The dbt project also contains model and column descriptions, tests and transformation logic to support review and maintenance.
## Scoring

Official Key Stage 2 scaled scores cannot be inferred directly from arbitrary assessment percentages. The pipeline therefore uses the official conversion tables as a reference for estimating scaled scores.

For each session, the proportion of correct answers is calculated as:

`total_correct / total_questions`

The corresponding conversion row is selected by finding the highest `raw_score / highest_raw_score` ratio that does not exceed the learner's proportion of correct answers. The associated `scaled_score` is returned.

This is a proportional approximation, not an official SATs scoring procedure. It assumes that the proportion of correct answers can be compared with the raw-score proportions in the conversion table.

## Data Quality and Testing

The project includes dbt data tests for key data-quality requirements, including:

- Uniqueness of the `session_id` / `question_id` combination in the deduplicated responses.
- Non-null requirements for key fields.
- Accepted values for selected categorical fields.
- Validation of the final model's assumptions through session-level completeness checks.

Run the project's configured models and tests to validate the pipeline.

## Future Improvements

The following enhancements were identified but not implemented within the assessment timeframe:

- **Incremental loading:** Implement incremental processing for `RESPONSES` to avoid reprocessing the entire dataset on every run.
- **Historical snapshots:** Introduce dbt snapshots for the hierarchy, assessment settings and pupil data to preserve changes over time. The current two-column pupil table would need to be extended or otherwise provide sufficient attributes to identify meaningful changes.
- **Source data testing and freshness:** Expand source-level data quality tests and configure source freshness checks where suitable timestamp fields are available.
- **SATs scoring unit tests:** Add dbt unit tests covering representative scoring scenarios, including boundary values, subject mappings, missing conversion rows and expected scaled scores.

## Running the Project

Configure the BigQuery connection and dbt profile for your environment, then run:

```bash
dbt debug
dbt deps
dbt build
```

To generate and view the project documentation:

```bash
dbt docs generate
dbt docs serve
```

## Documentation and AI Usage

- `plan.md` summarises the project workflow and key tasks.
- `prompts.md` summarises how AI tools were used during planning, implementation and troubleshooting.

The dbt project also contains model and column descriptions, tests and transformation logic to support review and maintenance.