WITH
    home_team_score AS (
        SELECT
            season,
            home_team_api_id AS team_api_id,
            COUNT(*) AS total_matches,
            SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) AS wins,
            SUM(CASE WHEN home_team_goal < away_team_goal THEN 1 ELSE 0 END) AS losses,
            SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) AS draws
        FROM
            {{source('soccer_bronze','match')}}
        GROUP BY
            season, home_team_api_id
            ),
    away_team_score AS (
        SELECT
            season,
            away_team_api_id AS team_api_id,
            COUNT(*) AS total_matches,
            SUM(CASE WHEN away_team_goal > home_team_goal THEN 1 ELSE 0 END) AS wins,
            SUM(CASE WHEN away_team_goal < home_team_goal THEN 1 ELSE 0 END) AS losses,
            SUM(CASE WHEN away_team_goal = home_team_goal THEN 1 ELSE 0 END) AS draws
        FROM
            {{source('soccer_bronze','match')}}
        GROUP BY
            season, away_team_api_id
            ),
    team_performance As (
        select
            *
        FROM
            away_team_score
        UNION ALL
        select
            *
        FROM
            home_team_score

    ),
    aggregated_performance AS (
        SELECT
            season,
            team_api_id,
            SUM(total_matches) AS total_matches,
            SUM(wins) AS wins,
            SUM(losses) AS losses,
            SUM(draws) AS draws
        FROM
            team_performance
        GROUP BY
            season, team_api_id
    ),
    final AS (
        SELECT
            ap.season,
            t.team_long_name As team_name,
            ap.total_matches,
            ap.wins,
            ap.losses,
            ap.draws
        FROM
            aggregated_performance ap
        JOIN
            {{source('soccer_bronze','team')}} t
            ON ap.team_api_id = t.team_api_id
            )
    select * from final
