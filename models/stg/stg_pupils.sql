WITH raw_pupils AS (
    SELECT * FROM {{ source('atom_raw', 'pupils') }}
)

SELECT pupil_id
    , is_deleted
FROM 
    raw_pupils