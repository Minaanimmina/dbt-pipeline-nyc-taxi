SELECT
    -- Identifiants
    tpep_pickup_datetime,
    tpep_dropoff_datetime,

    -- Localisation
    PULocationID,
    DOLocationID,

    -- Métriques du trajet
    trip_distance,
    categorie_distance,
    duree_minutes,
    vitesse_moyenne,

    -- Temporel
    heure_pickup,
    jour_semaine,    -- qu'on vient d'ajouter dans daily_summary
    periode_temporelle,

    -- Financier
    fare_amount,
    tip_amount,
    total_amount,
    pourcentage_pourboire,
    payment_type

FROM {{ ref('int_trip_metrics') }}