SELECT
    CASE EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime)
        WHEN 2 THEN '1-Lundi'
        WHEN 3 THEN '2-Mardi'
        WHEN 4 THEN '3-Mercredi'
        WHEN 5 THEN '4-Jeudi'
        WHEN 6 THEN '5-Vendredi'
        WHEN 7 THEN '6-Samedi'
        WHEN 1 THEN '7-Dimanche'
    END AS jour_semaine,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Semaine'
    END AS type_jour,
    COUNT(*) AS nombre_trajets,
    SUM(total_amount) AS revenus_totaux,
    AVG(total_amount) AS revenu_moyen,
    AVG(tip_amount) AS pourboire_moyen
FROM {{ ref('int_trip_metrics') }}
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)
GROUP BY jour_semaine, type_jour