WITH responses AS (
    SELECT *
    FROM {{ ref('int_responses_deduped') }}
)

, courses AS (
    SELECT question_id
        , subject_name
    FROM {{ ref('stg_courses') }}
)

SELECT responses.*
, courses.subject_name
FROM responses
JOIN courses ON responses.question_id = courses.question_id
                AND courses.subject_name IN ('Maths', 'English')