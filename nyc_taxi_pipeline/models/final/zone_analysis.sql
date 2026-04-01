SELECT
    PULocationID,
    COUNT(*) AS volume,
    AVG(total_amount) AS revenus_moyens
FROM {{ ref('stg_yellow_taxi_trips') }}
GROUP BY PULocationID