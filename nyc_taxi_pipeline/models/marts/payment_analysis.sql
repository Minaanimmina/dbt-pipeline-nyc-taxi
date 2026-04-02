SELECT
    CASE payment_type
        WHEN 0 THEN 'Inconnu'
        WHEN 1 THEN 'Carte bancaire'
        WHEN 2 THEN 'Espèces'
        WHEN 3 THEN 'Sans frais'
        WHEN 4 THEN 'Litige'
        WHEN 5 THEN 'Inconnu'
    END AS mode_paiement,
    COUNT(*) AS nombre_trajets,
    AVG(total_amount) AS revenu_moyen,
    AVG(tip_amount) AS pourboire_moyen,
    AVG(pourcentage_pourboire) AS taux_pourboire_moyen,
    SUM(total_amount) AS revenus_totaux
FROM {{ ref('int_trip_metrics') }}
GROUP BY payment_type