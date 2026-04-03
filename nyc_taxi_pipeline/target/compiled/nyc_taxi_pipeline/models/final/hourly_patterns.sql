SELECT
    heure_pickup,
    COUNT(*) AS demande,
    SUM(total_amount) AS revenus,
    AVG(total_amount) AS revenu_moyen,
    AVG(vitesse_moyenne) AS vitesse_moyenne,
    AVG(pourcentage_pourboire) AS taux_pourboire_moyen,
    CASE
        WHEN heure_pickup BETWEEN 6 AND 9 THEN 'Rush Matinal'
        WHEN heure_pickup BETWEEN 10 AND 15 THEN 'Journée'
        WHEN heure_pickup BETWEEN 16 AND 19 THEN 'Rush Soir'
        WHEN heure_pickup BETWEEN 20 AND 23 THEN 'Soirée'
        ELSE 'Nuit'
    END AS periode
FROM `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
GROUP BY heure_pickup