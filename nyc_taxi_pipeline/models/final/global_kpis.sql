SELECT
    COUNT(*) AS total_trajets,
    SUM(total_amount) AS revenus_totaux,
    AVG(trip_distance) AS distance_moyenne,
    AVG(total_amount) AS revenu_moyen_par_trajet,
    AVG(tip_amount) AS pourboire_moyen,
    AVG(pourcentage_pourboire) AS taux_pourboire_moyen
FROM {{ ref('stg_yellow_taxi_trips') }}
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)