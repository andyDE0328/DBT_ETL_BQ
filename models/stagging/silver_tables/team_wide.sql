with
    team as (
                select
                        team_api_id,
                        team_long_name
                from {{ ref("stg_team") }} ),
    match as (
                select
                        id,
                        date,
                        home_team_goal,
                        away_team_goal,
                        home_team_api_id,
                        away_team_api_id,
                        season
                from {{source('soccer_bronze','match')}}
  ),
    final as
           (
            SELECT
                    m.id AS match_id,
                    m.date,
                    home_team.team_long_name AS home_team_name,
                    away_team.team_long_name AS away_team_name,
                    m.home_team_goal,
                    m.away_team_goal,
                    m.season,
                    m.league_id,
                    m.country_id
            FROM
                    match m
            JOIN
                    team home_team
                        ON m.home_team_api_id = home_team.team_api_id
            JOIN
                    team away_team
                        ON m.away_team_api_id = away_team.team_api_id
           )
    select * from final