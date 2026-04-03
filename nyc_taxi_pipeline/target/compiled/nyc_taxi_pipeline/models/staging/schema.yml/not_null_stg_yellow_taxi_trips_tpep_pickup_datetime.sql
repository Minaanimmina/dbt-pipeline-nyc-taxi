
    
    



select tpep_pickup_datetime
from `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
where tpep_pickup_datetime is null


