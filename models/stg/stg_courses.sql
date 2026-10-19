WITH raw_courses AS (
    SELECT * FROM {{ source('atom_raw', 'courses') }}
)

SELECT question_id
    , atom_id
    , subtopic_id
    , topic_id
    , subject_id
    , subject_name
FROM 
    raw_courses