# Project Plan — SATs Score Modelling

## 1. Environment and Infrastructure

- [x] Set up the project folder and Git repository.
- [x] Configure the Python virtual environment and dbt Core with the BigQuery adapter.
- [x] Configure and test connectivity between dbt, BigQuery, Git and GitHub.

## 2. Business and Source Data Discovery

- [x] Inspect the four source tables in BigQuery.
- [x] Analyse response duplication, assessment coverage and available subject values.
- [x] Investigate the official GOV.UK Key Stage 2 score conversion tables.
- [x] Identify the assumptions and limitations involved in applying official conversion data to mock assessments.

## 3. Data Modelling

- [x] Create staging models for the source tables.
- [x] Prepare the SATs score conversion data as a dbt seed.
- [x] Deduplicate responses and retain supported subjects.
- [x] Remove responses without matching assessment settings.
- [x] Implement the score conversion logic.
- [x] Build the final session-level results mart.
- [x] Add data tests and model documentation.

## 4. Validation and Submission

- [X] Run the final dbt build and resolve any failures.
- [X] Confirm the final models are materialised in BigQuery.
- [X] Generate the dbt documentation.
- [X] Complete the README and supporting project documentation.
- [X] Commit and push the final changes to GitHub.
- [X] Provide the reviewers with repository access and submission details.

## 5. Future Improvements

The following items remain outstanding and were not implemented within the assessment timeframe:

- [ ] Implement incremental loading for `RESPONSES`.
- [ ] Introduce snapshots for hierarchy and assessment settings tables.
- [ ] Review the pupil data structure and implement snapshots that can track meaningful changes over time.
- [ ] Expand source-level data quality tests and configure source freshness checks where suitable timestamp fields are available.
- [ ] Add unit tests for SATs scoring, covering normal cases, boundary conditions and missing conversion records.

## Key Decisions and Assumptions

- The expected response grain is one record per `session_id` / `question_id` combination.
- Where duplicate responses conflict on correctness, the "is_correct = True" response is retained. This assumption should be confirmed with the source-system owner.
- The scoring pipeline uses the available official conversion tables for Mathematics and English grammar, punctuation and spelling.
- English Reading is not scored separately because the source assessment data does not distinguish it from English.
- Assessment completeness is assessed by comparing the expected question count with the actual deduplicated response count.
- The resulting scaled score is an estimate based on proportional raw-score matching, not an official SATs result.