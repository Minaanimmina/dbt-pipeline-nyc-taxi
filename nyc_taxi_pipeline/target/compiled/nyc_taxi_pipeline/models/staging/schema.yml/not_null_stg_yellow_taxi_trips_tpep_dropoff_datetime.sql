
    
    



select tpep_dropoff_datetime
from `nyc-taxi-dbt-devia`.`staging`.`stg_yellow_taxi_trips`
where tpep_dropoff_datetime is null


