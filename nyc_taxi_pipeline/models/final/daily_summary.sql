SELECT
    DATE(tpep_pickup_datetime) AS date_pickup,
    COUNT(*) AS nombre_trajets,
    AVG(trip_distance) AS distance_moyenne,
    SUM(total_amount) AS revenus_totaux
FROM {{ ref('stg_yellow_taxi_trips') }}
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)
GROUP BY DATE(tpep_pickup_datetime)