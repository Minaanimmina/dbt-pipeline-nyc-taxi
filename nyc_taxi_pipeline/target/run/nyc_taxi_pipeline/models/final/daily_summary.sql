
  
    

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
    END AS type_jour
FROM `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)
GROUP BY
    DATE(tpep_pickup_datetime),
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)),
    type_jour
    );
  