with
    match_data AS (
        SELECT
            match_api_id,
            season,
            home_team_goal,
            away_team_goal,
            home_player_1
        FROM
            {{source('soccer_bronze','match')}}
    ),
    players AS (
        SELECT
            player_api_id,
            player_name,
            height,
            weight
        FROM
             {{source('soccer_bronze','player')}}
    ),
    player_attribute AS (
        SELECT
            player_api_id,
            max(overall_rating) OVER (PARTITION BY player_api_id) as max_overall_rating ,
            date
        FROM
          {{source('soccer_bronze','player_attribute')}}
    ),
    max_date AS (
        SELECT
            MAX(date) as max_date
       FROM
            {{source('soccer_bronze','player_attribute')}}
    ),
    final AS (
        SELECT
            m.season,
            m.match_api_id as match_id,
            p.player_name,
            p.height,
            p.weight,
            (m.home_team_goal + m.away_team_goal) AS goals_scored,
            pa.max_overall_rating as overall_rating
        FROM
            match_data m
        JOIN
            players p
                ON m.home_player_1 = p.player_api_id
        JOIN
            player_attribute pa
                ON p.player_api_id = pa.player_api_id
    )
    SELECT
        *
    FROM
        final

