WITH responses AS (
    SELECT *
    FROM {{ ref('stg_responses') }}
)

SELECT
    MAX(response_id) AS response_id,
    ANY_VALUE(pupil_id) AS pupil_id,
    session_id,
    question_id,
    MAX(is_correct) is_correct,
    ANY_VALUE(is_no_attempt) AS is_no_attempt,
    ANY_VALUE(seconds_taken) AS seconds_taken,
    ANY_VALUE(question_number) AS question_number,
    ANY_VALUE(answered_at) AS answered_at
FROM responses
GROUP BY session_id, question_id