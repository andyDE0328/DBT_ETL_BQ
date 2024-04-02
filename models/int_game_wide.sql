with
    int_game_wide as (
        select
            gameid,
            avg(durationminutes) as avg_duration,
            avg(attendance) as avg_attendence
        from `bigquery-public-data.baseball.games_wide`
        group by gameid
    )
select *
from int_game_wide
