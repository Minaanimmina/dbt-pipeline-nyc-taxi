SELECT
    z.PULocationID,
    l.Zone AS zone_name,
    l.Borough AS borough,
    COUNT(*) AS volume,
    AVG(z.total_amount) AS revenus_moyens
FROM {{ ref('stg_yellow_taxi_trips') }} z
LEFT JOIN {{ ref('taxi_zone_lookup') }} l
    ON z.PULocationID = l.LocationID
GROUP BY z.PULocationID, l.Zone, l.Borough