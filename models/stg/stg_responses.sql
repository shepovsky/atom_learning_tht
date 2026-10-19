WITH raw_responses AS (
    SELECT * FROM {{ source('atom_raw', 'responses') }}
)

SELECT response_id
    , pupil_id
    , session_id
    , session_type
    , question_id
    , is_correct
    , is_no_attempt
    , seconds_taken
    , question_number
    , answered_at
FROM 
    raw_responses