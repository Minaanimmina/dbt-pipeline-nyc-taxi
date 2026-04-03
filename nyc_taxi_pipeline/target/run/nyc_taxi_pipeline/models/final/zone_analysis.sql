
  
    

    create or replace table `nyc-taxi-dbt-devia`.`final`.`zone_analysis`
      
    
    

    
    OPTIONS()
    as (
      SELECT
    z.PULocationID,
    l.Zone AS zone_name,
    l.Borough AS borough,
    COUNT(*) AS volume,
    AVG(z.total_amount) AS revenus_moyens
FROM `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips` z
LEFT JOIN `nyc-taxi-dbt-devia`.`staging`.`taxi_zone_lookup` l
    ON z.PULocationID = l.LocationID
GROUP BY z.PULocationID, l.Zone, l.Borough
    );
  