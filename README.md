# Atom Learning — SATs Score Modelling
## Objective

Build a reproducible dbt pipeline in BigQuery that calculates a subject-level score for each pupil using the supplied assessment data.

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