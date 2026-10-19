{% macro get_sats_year(date_column) %}
    CASE
        WHEN CAST({{ date_column }} AS DATE) < DATE(
            EXTRACT(YEAR FROM CAST({{ date_column }} AS DATE)),
            7,
            15
        )
        THEN EXTRACT(YEAR FROM CAST({{ date_column }} AS DATE)) - 1
        ELSE EXTRACT(YEAR FROM CAST({{ date_column }} AS DATE))
    END
{% endmacro %}