WITH raw_assessments AS (
    SELECT * FROM {{ source('atom_raw', 'assessments') }}
)

SELECT session_id
    , pupil_id
    , assessment_id
    , session_type
    , style
    , year_group_at_sitting
    , total_questions
    , is_complete
    , is_deleted
    , started_at
    , finished_at
FROM 
    raw_assessments