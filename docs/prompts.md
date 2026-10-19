# AI Prompts and Usage

AI assistance was used as a development aid during the project. I used ChatGPT to support planning, investigate dbt and BigQuery behaviour, troubleshoot errors, and improve the project documentation.

## Initial Planning and Data Discovery

I provided the assessment brief and described the intended stack: dbt Core, BigQuery, VS Code and GitHub.

I asked for help breaking down the task, understanding the SATs scoring context, prioritising the work, and identifying the source-data questions that needed investigation before implementation.

## dbt Development

I asked for guidance on:

- Defining composite uniqueness tests and other data-quality tests in dbt YAML.
- Working with source tests and accepted values.
- Creating reusable Jinja macros for academic-year calculations and SATs score conversion.
- Mapping subject names to the labels used in the score conversion data.
- Using aggregate expressions in scoring logic and troubleshooting BigQuery SQL errors.

## Debugging and Validation

I shared dbt and BigQuery error messages to help identify issues with YAML parsing, Boolean tests, aggregate functions and correlated subqueries.

The resulting suggestions were reviewed and adapted to the project. The final SQL and data transformations were validated through dbt execution and testing.

## Documentation and Submission

I used ChatGPT to improve the README, document the modelling assumptions and limitations, organise the project plan, and prepare the final submission communication.

AI-generated suggestions were used as guidance rather than treated as authoritative answers. Business assumptions, source-data findings and the final implementation remain subject to validation against the actual data and assessment requirements.