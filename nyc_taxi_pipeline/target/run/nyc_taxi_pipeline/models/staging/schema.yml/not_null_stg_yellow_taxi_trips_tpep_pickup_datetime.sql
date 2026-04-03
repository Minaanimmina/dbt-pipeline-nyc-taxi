
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select tpep_pickup_datetime
from `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
where tpep_pickup_datetime is null



  
  
      
    ) dbt_internal_test