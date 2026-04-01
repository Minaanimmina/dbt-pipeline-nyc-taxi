SELECT *,
    TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, MINUTE) AS duree_minutes,
    EXTRACT(HOUR FROM tpep_pickup_datetime) AS heure_pickup,
    EXTRACT(DAY FROM tpep_pickup_datetime) AS day_pickup,
    EXTRACT(MONTH FROM tpep_pickup_datetime) AS month_pickup,
    trip_distance / NULLIF(
        TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, MINUTE) / 60.0,
        0
    ) AS vitesse_moyenne,
    tip_amount / fare_amount * 100 AS pourcentage_pourboire
FROM {{ source('raw', 'yellow_taxi_trips') }}
WHERE tpep_pickup_datetime < tpep_dropoff_datetime
AND fare_amount > 0
AND total_amount > 0
AND trip_distance BETWEEN 0.1 AND 100
AND PULocationID IS NOT NULL
AND DOLocationID IS NOT NULL