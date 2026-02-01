SELECT DISTINCT league_name
FROM playerinjuries;


DESCRIBE playerinjuries;



ALTER TABLE playerinjuries
ADD COLUMN days_int INT NULL,
ADD COLUMN injury_from DATE NULL,
ADD COLUMN injury_until DATE NULL;


UPDATE playerinjuries
SET days_int =
  CASE
    WHEN days IS NULL OR TRIM(days) = '' THEN NULL
    ELSE CAST(REGEXP_REPLACE(days, '[^0-9]', '') AS UNSIGNED)
  END;

UPDATE playerinjuries
SET injury_from = STR_TO_DATE(injury_from_parsed, '%m/%d/%y'),
    injury_until = STR_TO_DATE(injury_until_parsed, '%m/%d/%y');

UPDATE playerinjuries
SET injury_from = COALESCE(injury_from, STR_TO_DATE(injury_from_parsed, '%Y-%m-%d')),
    injury_until = COALESCE(injury_until, STR_TO_DATE(injury_until_parsed, '%Y-%m-%d'));



SELECT
  SUM(days_int IS NULL) AS null_days,
  SUM(injury_from IS NULL) AS null_from_dates,
  SUM(injury_until IS NULL) AS null_until_dates
FROM playerinjuries;

SELECT *
FROM playerinjuries
WHERE injury_from IS NOT NULL
  AND injury_until IS NOT NULL
  AND injury_until < injury_from
LIMIT 25;


CREATE OR REPLACE VIEW v_injuries_clean AS
SELECT
  season,
  league_name,
  player_club,
  player_name,
  player_age,
  player_position,
  injury,
  days_int,
  games_missed,
  injury_from,
  injury_until
FROM playerinjuries;


SELECT COUNT(*) AS total_rows FROM playerinjuries;

SELECT days, days_int, injury_from_parsed, injury_from, injury_until_parsed, injury_until
FROM playerinjuries
LIMIT 10;



#Creating Views
CREATE OR REPLACE VIEW v_injuries_clean AS
SELECT
  season,
  league_name,
  player_club,
  player_name,
  player_age,
  player_position,
  injury,
  days_int,
  games_missed,
  injury_from,
  injury_until
FROM playerinjuries
WHERE league_name IS NOT NULL
  AND player_name IS NOT NULL;
  
#Club KPI View
CREATE OR REPLACE VIEW v_club_kpis AS
SELECT
  season,
  league_name,
  player_club,
  COUNT(*) AS total_injuries,
  SUM(days_int) AS total_days_missed,
  SUM(games_missed) AS total_games_missed,
  AVG(days_int) AS avg_days_missed
FROM v_injuries_clean
GROUP BY season, league_name, player_club;

#Player Risk View
CREATE OR REPLACE VIEW v_player_risk AS
SELECT
  season,
  league_name,
  player_club,
  player_name,
  player_position,
  player_age,
  COUNT(*) AS injury_count,
  SUM(days_int) AS total_days_missed,
  AVG(days_int) AS avg_days_missed,
  RANK() OVER (PARTITION BY season, league_name ORDER BY SUM(days_int) DESC) AS risk_rank_in_league
FROM v_injuries_clean
GROUP BY season, league_name, player_club, player_name, player_position, player_age;


SELECT DISTINCT season FROM v_injuries_clean ORDER BY season;

SELECT league_name, COUNT(*) AS injuries
FROM v_injuries_clean
GROUP BY league_name
ORDER BY injuries DESC;

-- List the views (quick check)
SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';

SELECT
  SUM(days_int IS NULL) AS null_days,
  SUM(injury_from IS NULL) AS null_from,
  SUM(injury_until IS NULL) AS null_until
FROM playerinjuries;


SELECT COUNT(*) AS bad_date_order
FROM playerinjuries
WHERE injury_from IS NOT NULL
  AND injury_until IS NOT NULL
  AND injury_until < injury_from;
  
SELECT MIN(days_int) AS min_days, MAX(days_int) AS max_days, AVG(days_int) AS avg_days
FROM playerinjuries;

CREATE INDEX idx_league_season ON playerinjuries(league_name, season);
CREATE INDEX idx_club ON playerinjuries(player_club);
CREATE INDEX idx_injury_from ON playerinjuries(injury_from);


SELECT * FROM v_injuries_clean
INTO OUTFILE '/tmp/v_injuries_clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM v_injuries_clean;

SELECT
  league_name,
  SUM(days_int) AS total_days_missed
FROM playerinjuries
GROUP BY league_name
ORDER BY total_days_missed DESC;


SELECT
  league_name,
  COUNT(*) AS total_injuries
FROM playerinjuries
GROUP BY league_name
ORDER BY total_injuries DESC;


SELECT
  player_club,
  SUM(days_int) AS total_days_missed
FROM playerinjuries
GROUP BY player_club
ORDER BY total_days_missed DESC
LIMIT 10;

SELECT
  injury,
  AVG(days_int) AS avg_days_missed
FROM playerinjuries
WHERE injury IS NOT NULL
GROUP BY injury
HAVING COUNT(*) >= 20
ORDER BY avg_days_missed DESC
LIMIT 10;


SELECT
  player_name,
  player_club,
  league_name,
  COUNT(*) AS injury_count,
  SUM(days_int) AS total_days_missed,
  AVG(days_int) AS avg_days_missed
FROM playerinjuries
GROUP BY player_name, player_club, league_name
HAVING COUNT(*) >= 3
ORDER BY total_days_missed DESC
LIMIT 20;


#Page 2
SELECT
  player_club,
  SUM(days_int) AS total_days_missed
FROM playerinjuries
GROUP BY player_club
ORDER BY total_days_missed DESC;

SELECT
  player_club,
  COUNT(*) AS total_injuries
FROM playerinjuries
GROUP BY player_club
ORDER BY total_injuries DESC;

SELECT
  player_club,
  player_name,
  COUNT(*) AS injury_count,
  SUM(days_int) AS total_days_missed
FROM playerinjuries
GROUP BY player_club, player_name
HAVING COUNT(*) >= 2
ORDER BY total_days_missed DESC;


SELECT
  player_club,
  SUM(games_missed) AS total_games_missed,
  ROUND(SUM(games_missed) / 38.0, 2) AS avg_players_unavailable_per_match
FROM playerinjuries
GROUP BY player_club
ORDER BY avg_players_unavailable_per_match DESC;

SELECT
  player_name,
  COUNT(*) AS injury_count,
  SUM(days_int) AS total_days_missed,
  ROUND(AVG(days_int), 1) AS avg_days_missed
FROM playerinjuries
GROUP BY player_name
HAVING COUNT(*) >= 3
ORDER BY total_days_missed DESC
LIMIT 30;


SELECT
  player_age,
  AVG(days_int) AS avg_days_missed
FROM playerinjuries
GROUP BY player_age
ORDER BY player_age;

SELECT
  player_position,
  COUNT(*) AS injury_count,
  ROUND(AVG(days_int), 1) AS avg_days_missed
FROM playerinjuries
GROUP BY player_position
ORDER BY avg_days_missed DESC;

SELECT
  season,
  COUNT(*) AS total_injuries
FROM playerinjuries
GROUP BY season
ORDER BY season;

SELECT
  MONTH(injury_from) AS injury_month,
  COUNT(*) AS total_injuries
FROM playerinjuries
GROUP BY injury_month
ORDER BY injury_month;

SELECT
  player_club,
  COUNT(*) AS total_injuries,
  SUM(days_int) AS total_days_missed,
  ROUND(SUM(days_int) / COUNT(*), 1) AS impact_efficiency_score
FROM playerinjuries
GROUP BY player_club
HAVING COUNT(*) >= 30
ORDER BY impact_efficiency_score DESC;





