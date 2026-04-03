
  
    

    create or replace table `nyc-taxi-dbt-devia`.`final`.`monthly_summary`
      
    
    

    
    OPTIONS()
    as (
      SELECT
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)) AS mois,
    COUNT(*) AS nombre_trajets,
    AVG(trip_distance) AS distance_moyenne,
    SUM(total_amount) AS revenus_totaux,
    AVG(total_amount) AS revenu_moyen_par_trajet,
    AVG(pourcentage_pourboire) AS taux_pourboire_moyen
FROM `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) IN (2024, 2025)
GROUP BY FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime))
ORDER BY mois
    );
  