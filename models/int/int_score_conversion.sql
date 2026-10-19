{{ config (
    materialized = "table"
) }}

WITH score_conversion AS (
    SELECT *
    FROM {{ ref('score_conversion') }}
)

SELECT
    year
    , CASE 
        WHEN paper = 'Mathematics' THEN 'Maths'
        WHEN paper = 'English grammar, punctuation and spelling' THEN 'English'
        ELSE NULL
    END AS paper
    , raw_score/highest_raw_score AS pcent
    , scaled_score
FROM score_conversion
WHERE year > 2024
AND paper IN ('Mathematics', 'English grammar, punctuation and spelling')
