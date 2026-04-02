SELECT
    z.PULocationID,
    l.Zone AS zone_name,
    l.Borough AS borough,
    COUNT(*) AS volume,
    AVG(z.total_amount) AS revenus_moyens,
    AVG(z.duree_minutes) AS duree_moyenne_minutes,
    AVG(z.vitesse_moyenne) AS vitesse_moyenne
FROM {{ ref('int_trip_metrics') }} z
LEFT JOIN {{ ref('taxi_zone_lookup') }} l
    ON z.PULocationID = l.LocationID
GROUP BY z.PULocationID, l.Zone, l.Borough