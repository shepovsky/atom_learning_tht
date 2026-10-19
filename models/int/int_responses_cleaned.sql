WITH responses AS (
    SELECT *
    FROM {{ ref('int_responses_maths_and_eng') }}
)

, assessments AS (
    SELECT *
    FROM {{ ref('int_assessments_complete') }}
)

SELECT responses.response_id
    , responses.pupil_id
    , responses.session_id
    , responses.question_id
    , responses.is_correct
    , responses.is_no_attempt
    , responses.seconds_taken
    , responses.question_number
    , responses.answered_at
    , assessments.is_complete
    , assessments.year_group_at_sitting
    , assessments.total_questions
    , assessments.started_at
    , assessments.finished_at
    , assessments.sats_year
FROM responses
INNER JOIN assessments ON responses.session_id = assessments.session_id
