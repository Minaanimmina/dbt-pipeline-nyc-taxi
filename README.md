# NYC Yellow Taxi — Pipeline de Données avec DBT & BigQuery

![GitHub Actions](https://github.com/Minaanimmina/dbt-pipeline-nyc-taxi/actions/workflows/monthly_pipeline.yml/badge.svg)
![Python](https://img.shields.io/badge/python-3.12-blue)
![DBT](https://img.shields.io/badge/dbt-1.11.7-orange)
![BigQuery](https://img.shields.io/badge/Google-BigQuery-blue)
![Looker Studio](https://img.shields.io/badge/Looker-Studio-green)

Pipeline de données professionnel traitant **90 millions de trajets de taxis jaunes new-yorkais (2024-2025)**. Le projet implémente une architecture data warehouse moderne avec ingestion, transformation, tests de qualité, orchestration automatisée et visualisation des KPIs.

---

## Objectif / Use case métier

La NYC Taxi & Limousine Commission (TLC) publie chaque mois des millions d'enregistrements de trajets. Ces données brutes sont riches mais inexploitables en l'état — elles contiennent des anomalies, des valeurs manquantes, et ne sont pas structurées pour l'analyse.

Ce projet répond à plusieurs questions métier :

- **Quelles sont les heures de pointe ?** → Optimiser la disponibilité des taxis
- **Quelles zones sont les plus lucratives ?** → Guider les chauffeurs vers les zones rentables
- **Comment évoluent les revenus dans le temps ?** → Identifier les tendances saisonnières
- **Quel mode de paiement génère le plus de pourboires ?** → Comprendre les comportements clients

---

## Dataset source

| Attribut | Détail |
| --- | --- |
| **Source** | [NYC Taxi & Limousine Commission](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) |
| **Type** | Yellow Taxi Trip Records |
| **Format** | Fichiers Parquet mensuels |
| **Période** | Janvier 2024 → Décembre 2025 (24 mois) |
| **Volume brut** | ~90 millions de trajets / ~8 GB compressé |
| **URL de base** | `https://d37ci6vzurychx.cloudfront.net/trip-data/` |
| **Référentiel zones** | [Taxi Zone Lookup Table](https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv) |

**Note :** Depuis 2025, une colonne `cbd_congestion_fee` a été ajoutée aux données pour refléter le nouveau péage de congestion à Manhattan. Le pipeline gère cette différence de schéma automatiquement.

---

## Architecture globale

``` ascii
┌─────────────────────────────────────────────────────────────────┐
│                        SOURCE EXTERNE                           │
│         NYC TLC — Fichiers Parquet mensuels                     │
└──────────────────────────┬──────────────────────────────────────┘
                           │ Script Python (Google Colab)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RAW (BigQuery)                               │
│              raw.yellow_taxi_trips                              │
│           90M lignes — données brutes intactes                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ DBT — couche Staging
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STAGING (BigQuery)                            │
│  staging.stg_yellow_taxi_trips  →  83M lignes (nettoyées)       │
│  staging.int_trip_metrics       →  83M lignes (enrichies)       │
│  staging.taxi_zone_lookup       →  265 zones (référentiel)      │
└──────────────────────────┬──────────────────────────────────────┘
                           │ DBT — couche Marts
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FINAL (BigQuery)                             │
│  fact_trips · daily_summary · monthly_summary                   │
│  hourly_patterns · zone_analysis · payment_analysis             │
│  weekly_revenue · global_kpis                                   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│              LOOKER STUDIO — Dashboard 5 pages                  │
│     KPIs interactifs · Analyses temporelle et géographique      │
└─────────────────────────────────────────────────────────────────┘
```

### Couches DBT

| Couche | Dossier | Rôle | Schema BigQuery |
| --- | --- | --- | --- |
| Staging | `models/staging/` | Nettoyage des données brutes | `staging` |
| Intermediate | `models/intermediate/` | Catégorisations et enrichissements métier | `staging` |
| Marts | `models/marts/` | Agrégations pour l'analyse | `final` |

---

## Stack technique

| Outil | Version | Usage |
| --- | --- | --- |
| **Python** | 3.12 | Ingestion des données (script de chargement) |
| **Google BigQuery** | — | Data Warehouse cloud |
| **DBT Core** | 1.11.7 | Transformation et modélisation des données |
| **dbt-bigquery** | 1.11.1 | Adaptateur DBT pour BigQuery |
| **Google Cloud SDK** | — | Authentification OAuth locale |
| **GitHub Actions** | — | Orchestration et CI/CD |
| **Looker Studio** | — | Dashboard et visualisation |
| **uv** | 0.10+ | Gestion des dépendances Python |
| **WSL2 (Ubuntu)** | — | Environnement de développement |
| **Git** | — | Versioning du code |

---

## Performance / Volumétrie

| Table | Schema | Lignes | Taille approx. |
| --- | --- | --- | --- |
| `yellow_taxi_trips` | raw | 90 400 000 | ~18 GB |
| `stg_yellow_taxi_trips` | staging | 83 441 105 | ~15 GB |
| `int_trip_metrics` | staging | 83 441 105 | ~18 GB |
| `fact_trips` | final | 83 441 105 | ~11 GB |
| `daily_summary` | final | 731 | < 1 MB |
| `monthly_summary` | final | 24 | < 1 MB |
| `hourly_patterns` | final | 24 | < 1 MB |
| `zone_analysis` | final | 263 | < 1 MB |
| `payment_analysis` | final | 6 | < 1 MB |
| `weekly_revenue` | final | 7 | < 1 MB |
| `global_kpis` | final | 1 | < 1 MB |
| `taxi_zone_lookup` | staging | 265 | < 1 MB |

**Temps d'exécution `dbt run` complet :** ~45-80 secondes (4 threads en parallèle)

**Coût BigQuery :** Le projet utilise le free tier (1 TB/mois offert). Chaque `dbt run` scanne environ 15 GB — soit ~60 runs gratuits par mois.

---

## Prérequis

- Compte Google Cloud Platform avec projet BigQuery créé
- Python 3.12+
- [uv](https://docs.astral.sh/uv/) installé
- Google Cloud CLI (gcloud) installé dans WSL
- WSL2 (Ubuntu) recommandé sur Windows
- Compte GitHub

---

## Installation et setup

### 1. Cloner le repository

```bash
git clone https://github.com/Minaanimmina/dbt-pipeline-nyc-taxi.git
cd dbt-pipeline-nyc-taxi
```

### 2. Installer les dépendances

```bash
cd nyc_taxi_pipeline
uv sync
```

### 3. Authentification Google Cloud

```bash
gcloud auth application-default login
```

Cette commande ouvre un navigateur pour se connecter avec son compte Google. À relancer si les credentials expirent.

### 4. Configurer le profil DBT

Le fichier `profiles.yml` est déjà inclus dans le projet. Vérifier que le `project` correspond à votre projet GCP :

```yaml
nyc_taxi_pipeline:
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: votre-projet-gcp
      dataset: staging
      location: US
      threads: 4
```

### 5. Vérifier la connexion

```bash
uv run dbt debug --profiles-dir .
# Résultat attendu : All checks passed!
```

### 6. Charger les données brutes

Les données sont chargées via un script Python dans Google Colab. Ouvrir [ce notebook](notebooks/nyc_taxi_dbt_devia_script_extraction.ipynb) et exécuter toutes les cellules. Le script télécharge les 24 fichiers Parquet mensuels (2024-2025) et les charge dans `raw.yellow_taxi_trips`.

### 7. Lancer le pipeline DBT

```bash
# Charger la seed (référentiel zones)
uv run dbt seed --profiles-dir .

# Exécuter tous les modèles
uv run dbt run --profiles-dir .

# Lancer les tests de qualité
uv run dbt test --profiles-dir .
```

---

## Structure du projet

```
dbt-pipeline-nyc-taxi/
├── .github/
│   └── workflows/
│       └── monthly_pipeline.yml     ← Automatisation mensuelle
├── nyc_taxi_pipeline/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_yellow_taxi_trips.sql  ← Nettoyage données brutes
│   │   │   └── schema.yml                 ← Sources + tests qualité
│   │   ├── intermediate/
│   │   │   ├── int_trip_metrics.sql       ← Enrichissement métier
│   │   │   └── schema.yml
│   │   └── marts/
│   │       ├── daily_summary.sql          ← Résumé quotidien
│   │       ├── monthly_summary.sql        ← Résumé mensuel
│   │       ├── hourly_patterns.sql        ← Patterns horaires
│   │       ├── zone_analysis.sql          ← Analyse par zone
│   │       ├── payment_analysis.sql       ← Analyse paiements
│   │       ├── weekly_revenue.sql         ← Revenus hebdomadaires
│   │       ├── fact_trips.sql             ← Table de faits
│   │       ├── global_kpis.sql            ← KPIs globaux
│   │       └── schema.yml
│   ├── seeds/
│   │   └── taxi_zone_lookup.csv           ← Référentiel zones TLC
│   ├── macros/
│   │   └── generate_schema_name.sql       ← Override schemas DBT
│   ├── dbt_project.yml                    ← Configuration DBT
│   └── profiles.yml                       ← Connexion BigQuery
├── pyproject.toml                         ← Dépendances uv
└── uv.lock                                ← Versions figées
```

---

## Pipeline DBT

### Lignage des données

``` ascii
raw.yellow_taxi_trips (source externe)
        │
        ▼
staging.stg_yellow_taxi_trips      ← nettoyage + métriques de base
        │
        ▼
staging.int_trip_metrics           ← catégorisations métier
        │
        ├──► final.fact_trips
        ├──► final.daily_summary
        ├──► final.monthly_summary
        ├──► final.hourly_patterns
        ├──► final.zone_analysis ◄── seeds.taxi_zone_lookup
        ├──► final.payment_analysis
        ├──► final.weekly_revenue
        └──► final.global_kpis
```

### Transformations implémentées

**Nettoyage (staging) :**
- Exclusion des montants négatifs (`fare_amount`, `total_amount`)
- Exclusion des trajets avec dates incohérentes (pickup > dropoff)
- Filtrage des distances aberrantes (0.1 à 100 miles uniquement)
- Exclusion des zones NULL

**Enrichissements (intermediate) :**
- Durée du trajet en minutes
- Vitesse moyenne (miles/heure)
- Taux de pourboire (%)
- Catégorisation des distances : Court / Moyen / Long / Très long
- Périodes temporelles : Rush Matinal / Journée / Rush Soir / Soirée / Nuit
- Jour de la semaine ordonné (1-Lundi → 7-Dimanche)

### Commandes essentielles

```bash
# Vérifier la connexion BigQuery
uv run dbt debug --profiles-dir .

# Exécuter tous les modèles
uv run dbt run --profiles-dir .

# Exécuter un seul modèle
uv run dbt run --select daily_summary --profiles-dir .

# Forcer la recréation complète
uv run dbt run --select daily_summary --profiles-dir . --full-refresh

# Lancer les tests
uv run dbt test --profiles-dir .

# Charger les seeds
uv run dbt seed --profiles-dir .

# Générer et servir la documentation
uv run dbt docs generate --profiles-dir .
uv run dbt docs serve --profiles-dir .
```

---

## Tests & qualité des données

DBT permet de définir des tests automatiques qui s'exécutent après chaque run. Si un test échoue, le pipeline s'arrête et une alerte est générée.

### Tests implémentés

| Colonne | Test | Raison |
|---|---|---|
| `tpep_pickup_datetime` | `not_null` | Sans date de pickup, impossible d'analyser temporellement |
| `tpep_dropoff_datetime` | `not_null` | Nécessaire pour calculer la durée du trajet |
| `fare_amount` | `not_null` | Métrique financière centrale |
| `PULocationID` | `not_null` | Nécessaire pour l'analyse géographique |
| `payment_type` | `accepted_values [0,1,2,3,4,5]` | Valeurs hors dictionnaire TLC = données corrompues |

### Résultat

```
Done. PASS=5 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=5 ✅
```

### Point notable

La valeur `0` pour `payment_type` n'est pas documentée dans le dictionnaire officiel TLC mais apparaît dans les données réelles. Après analyse, elle a été acceptée plutôt que filtrée pour ne pas perdre ces trajets dans les analyses de volume.

---

## CI/CD — GitHub Actions

### Ce qui est automatisé

Le pipeline DBT s'exécute automatiquement **le 1er de chaque mois à minuit** via GitHub Actions :

1. Création d'une machine virtuelle Ubuntu
2. Authentification auprès de BigQuery via Service Account
3. Installation des dépendances avec `uv`
4. Exécution de `dbt run` → mise à jour de toutes les tables
5. Exécution de `dbt test` → validation de la qualité des données

### Déclencheurs

| Déclencheur | Quand |
|---|---|
| `schedule` | Le 1er de chaque mois à minuit (`0 0 1 * *`) |
| `workflow_dispatch` | Manuellement depuis l'interface GitHub |

### Secrets requis

| Secret | Description |
|---|---|
| `GCP_SERVICE_ACCOUNT_KEY` | Clé JSON du Service Account BigQuery Admin |

### Fichier workflow

```yaml
name: Monthly NYC Taxi Pipeline

on:
  schedule:
    - cron: '0 0 1 * *'
  workflow_dispatch:

jobs:
  run_pipeline:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      - name: Install uv
        run: |
          curl -LsSf https://astral.sh/uv/install.sh | sh
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      - uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SERVICE_ACCOUNT_KEY }}
      - name: Install dependencies
        run: cd nyc_taxi_pipeline && uv sync
      - name: Run DBT
        run: |
          cd nyc_taxi_pipeline
          uv run dbt run --profiles-dir .
          uv run dbt test --profiles-dir .
```

### Limitation actuelle

Le workflow actuel relance uniquement DBT sur les données existantes. Le chargement automatique des nouveaux fichiers Parquet mensuels depuis NYC TLC n'est pas encore intégré — c'est une prochaine étape (voir section Limitations).

---

## Visualisation & Dashboard

Le dashboard Looker Studio expose les KPIs clés du projet en 5 pages interactives.

> 🔗 **[Accéder au dashboard](https://lookerstudio.google.com/s/kXBxIFVNT5Q)**

### Structure du dashboard

| Page | Contenu |
|---|---|
| **Accueil** | 5 scorecards globaux (trajets, revenus, distances, pourboires) |
| **Vue d'ensemble** | Évolution mensuelle, répartition semaine/weekend |
| **Analyse temporelle** | Patterns horaires, distance par jour de semaine |
| **Analyse financière** | Modes de paiement, pourboires, rentabilité |
| **Analyse géographique** | Top 10 zones, évolution quotidienne, revenus par zone |

### KPIs principaux

| KPI | Valeur |
| --- | --- |
| Total trajets 2024-2025 | 83 441 047 |
| Revenus totaux | $2 398 586 051 |
| Distance moyenne / trajet | 3,48 miles |
| Revenu moyen / trajet | $28,75 |
| Pourboire moyen | $3,21 |
| % trajets par carte bancaire | 72,4% |
| Zone la plus populaire | Upper East Side South (3,8M trajets) |
| Zone la plus lucrative | Newark Airport ($108 revenu moyen) |

---

## Documentation DBT

La documentation DBT est auto-générée et hébergée sur GitHub Pages. Elle contient le lignage complet des données, les descriptions de chaque modèle et colonne, ainsi que les tests de qualité associés.

> 🔗 **[Accéder à la documentation](https://minaanimmina.github.io/dbt-pipeline-nyc-taxi/)**

Pour régénérer la documentation localement :

```bash
uv run dbt docs generate --profiles-dir .
uv run dbt docs serve --profiles-dir .
# Ouvrir http://localhost:8080
```

---

## Limitations connues & Prochaines étapes

### Limitations actuelles

**1. Chargement des données non automatisé**  
Le script Python de chargement des fichiers Parquet tourne dans Google Colab manuellement. Il n'est pas encore intégré dans le workflow GitHub Actions.

**2. Pas de bucket Google Cloud Storage**  
Les données sont chargées directement de l'URL source vers BigQuery. L'architecture standard recommande de passer par un bucket GCS comme couche intermédiaire (meilleur coût, meilleure traçabilité).

**3. Documentation DBT non mise à jour automatiquement**  
La branche `gh-pages` doit être mise à jour manuellement après chaque `dbt docs generate`.

### Prochaines étapes

- [ ] Intégrer le script Python de chargement dans GitHub Actions
- [ ] Ajouter un bucket Google Cloud Storage comme couche RAW intermédiaire
- [ ] Automatiser le déploiement de la documentation DBT dans GitHub Actions
- [ ] Ajouter des tests de qualité sur les modèles marts (not_null, valeurs min/max)
- [ ] Implémenter des snapshots DBT pour le suivi des changements dans le temps
- [ ] Connecter un outil de monitoring (ex: Elementary) pour alertes sur la qualité des données

---

## Auteur

**Mina G.**

Projet réalisé dans le cadre de la formation Développeur en Intelligence Articielle (RNCP 37827 Niveau 6)

---

## Licence

Ce projet est réalisé à des fins pédagogiques.
Les données NYC Taxi sont publiques et fournies par la [NYC Taxi & Limousine Commission](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page).