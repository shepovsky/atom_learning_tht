WITH assessments AS (
    SELECT *
    FROM {{ ref('stg_assessments') }}
)

SELECT session_id
    , pupil_id
    , assessment_id
    , year_group_at_sitting
    , total_questions
    , is_complete
    , started_at
    , finished_at
    , {{ get_sats_year('finished_at') }} AS sats_years
FROM assessments
WHERE assessments.finished_at IS NOT NULL
AND assessments.is_complete = true