
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select PULocationID
from `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
where PULocationID is null



  
  
      
    ) dbt_internal_test