{{
  config(
    labels = {'contains_pii': 'no', 'table_layer': 'gold'}
  )
}}

with
    match_wide as (
                select
                    home_team_goal,
                    away_team_goal,
                    season,
                    league_id,
                    country_id
                from {{ ref("team_wide") }}
    ),
    league as (
               select
                    id as league_id,
                    name as league_name,
               from {{source('soccer_bronze','league')}}
    ),
    country as (
               select
                    id as country_id,
                    name as country_name
               from {{source('soccer_bronze','country')}}
    ),
    final as (
              select
                    league_name,
                    country_name,
                    season,
                    AVG(m.home_team_goal + m.away_team_goal) AS avg_goals_per_match,
                    round(MAX(m.home_team_goal + m.away_team_goal),2) AS max_goals_in_a_match
              from match_wide m
              JOIN league l
                    ON m.league_id = l.league_id
              JOIN country c
                    ON m.country_id = c.country_id
            GROUP BY
                    l.league_name,
                    c.country_name,
                    m.season)
    select * from final
