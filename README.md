# Atom Learning — SATs Score Modelling
## Objective

Build a reproducible dbt pipeline in BigQuery that calculates a SATs score based on correctness of learners' responses in assessment questions.

## Source Data analysis

### Issues and proposed solutions:

1. RESPONSES data contains 1433 raw records with 56 distinct session_ids that are not present in ASSESSMENT_SETTINGS.
SOLUTION: remove the orphaned records in intermediate models. 

2. RESPONSES data contain records that would be identical if not for the response_id. The natural grane for this table is one question per sessions, in other words: one record per each session_id / question_id combination.
This issue suggest there might be an issue with the responses data being ingested into the table when response to the same question gets recorded more than once with exact same additional arguments such as answered_at timestamp, seconds_taken, question_number, etc. The is_correct value however can be deferent, false and true, for the same session_id / question_id combination. Logically, we could have used answered_at to detect the latest answer, but answered_at is always the same for each session_id / question_id combination.
SOLUTION: remove duplicate records by keeping only a single record for each session_id / question_id combination; For the id combination that have both is_correct values, false and true, keep the true value assuming that how the system works (it can allow to correct an incorrect answer, but it locks the correct answer in and does nto allow to change it to incorrect - this is all needs to be checked with the person who knows the source system well)

3. The SATs conversion tables on GOV UK exist for the following 3 subjects only English (full name "English grammar, punctuation and spelling"), English Reading and Mathematics. Learning's COURSE_HIERARCHY mentions question subjects other than Maths and English, eg. Science, Wellbeing, Screeners. Since GOV UK does not provide SATs conversions tables on those subjects the relevant records will also be dropped in the intermidiate models and therefore will not be present in the final results. The cleanned RESPONSES will only contain records related to Maths and English

### Data Assumptions:

1. The total_questions value in ASSESSMENT_SETTINGS shows the number of questions that learners get in each assessment and therefore it must match the number of rows per session_id in RESPONSES. If this does not happen, the assessment must be highlighted as faulty and moved to a seperate pool for further investigation.

2. Learning does not split English into two parts. The SATs conversion tables on GOV UK do split English into "English grammar, punctuation and spelling" and "English Reading". In the final model's conversion to SATs score I'll use "English grammar, punctuation and spelling".


## Approach

The planned pipeline consists of:

1. Staging models for the four raw tables.
2. An intermediate model aggregating performance by pupil, assessment sitting, and subject.
3. A final model applying the documented scoring methodology.
## Scoring

Official Key Stage 2 scaled scores cannot automatically be inferred from arbitrary assessment percentages. The scoring approach and its limitations will be documented after inspecting the source data.

## Running the project
dbt debug
dbt build

## Documentation

See docs/ for the AI worklog, selected prompts, and technical decisions.

Data quality findings, model details, and validation results will be added after implementation.