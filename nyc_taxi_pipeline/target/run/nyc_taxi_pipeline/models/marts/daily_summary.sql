
  
    

    create or replace table `nyc-taxi-dbt-devia`.`final`.`daily_summary`
      
    
    

    
    OPTIONS()
    as (
      SELECT
    DATE(tpep_pickup_datetime) AS date_pickup,
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)) AS mois,
    COUNT(*) AS nombre_trajets,
    AVG(trip_distance) AS distance_moyenne,
    SUM(total_amount) AS revenus_totaux,
    AVG(total_amount) AS revenu_moyen_par_trajet,
    AVG(tip_amount) AS pourboire_moyen,
    AVG(pourcentage_pourboire) AS taux_pourboire_moyen,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Semaine'
    END AS type_jour,
    CASE EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime)
        WHEN 2 THEN '1-Lundi'
        WHEN 3 THEN '2-Mardi'
        WHEN 4 THEN '3-Mercredi'
        WHEN 5 THEN '4-Jeudi'
        WHEN 6 THEN '5-Vendredi'
        WHEN 7 THEN '6-Samedi'
        WHEN 1 THEN '7-Dimanche'
    END AS jour_semaine
FROM `nyc-taxi-dbt-devia`.`staging`.`int_trip_metrics`
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)
GROUP BY
    DATE(tpep_pickup_datetime),
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)),
    type_jour,
    jour_semaine
    );
  