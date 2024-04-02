with
    game_wide as (

        select gameid, durationminutes, attendance
        from `bigquery-public-data.baseball.games_wide`

    )
select *
from game_wide
