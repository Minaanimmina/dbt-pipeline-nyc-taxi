SELECT
    -- Toutes les colonnes de staging
    *,

    -- Catégorisation des distances
    CASE
        WHEN trip_distance <= 1 THEN 'Court (≤ 1 mile)'
        WHEN trip_distance <= 5 THEN 'Moyen (1-5 miles)'
        WHEN trip_distance <= 10 THEN 'Long (5-10 miles)'
        ELSE 'Très long (> 10 miles)'
    END AS categorie_distance,

    -- Catégorisation des périodes temporelles
    CASE
        WHEN heure_pickup BETWEEN 6 AND 9 THEN 'Rush Matinal'
        WHEN heure_pickup BETWEEN 10 AND 15 THEN 'Journée'
        WHEN heure_pickup BETWEEN 16 AND 19 THEN 'Rush Soir'
        WHEN heure_pickup BETWEEN 20 AND 23 THEN 'Soirée'
        ELSE 'Nuit'
    END AS periode_temporelle,

    -- Catégorisation des jours de la semaine
    CASE EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime)
        WHEN 2 THEN '1-Lundi'
        WHEN 3 THEN '2-Mardi'
        WHEN 4 THEN '3-Mercredi'
        WHEN 5 THEN '4-Jeudi'
        WHEN 6 THEN '5-Vendredi'
        WHEN 7 THEN '6-Samedi'
        WHEN 1 THEN '7-Dimanche'
    END AS jour_semaine

FROM {{ ref('stg_yellow_taxi_trips') }}