WITH responses AS (
    SELECT *
    FROM {{ ref('int_responses_cleaned') }}
)

, session_results AS (
    SELECT pupil_id
    , session_id
    , subject_name
    , COUNT(*) AS total_answers
    , COUNTIF(is_correct IS TRUE) AS total_correct
    , total_questions
    , sats_year
    , (COUNT(*) = total_questions) AS is_complete
    FROM responses r
    GROUP BY r.pupil_id, session_id, subject_name, total_questions, sats_year
)

, score_conversion AS (
    SELECT *
    FROM {{ ref('int_score_conversion') }}
)

SELECT pupil_id
, session_id
, subject_name
, total_answers
, total_correct
, total_questions
, sats_year
, is_complete
, ( SELECT MAX(sc.scaled_score)
    FROM score_conversion sc
    WHERE 1=1
         AND sc.year = sats_year
         AND sc.paper = subject_name
         AND sc.pcent < total_correct / total_questions
) AS SATs_scaled_score
FROM session_results 
WHERE is_complete = true

