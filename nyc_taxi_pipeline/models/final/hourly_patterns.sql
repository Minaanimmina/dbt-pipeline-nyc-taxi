SELECT
    heure_pickup,
    COUNT(*) AS demande,
    SUM(total_amount) AS revenus,
    AVG(vitesse_moyenne) AS vitesse_moyenne
FROM {{ ref('stg_yellow_taxi_trips') }}
GROUP BY heure_pickup