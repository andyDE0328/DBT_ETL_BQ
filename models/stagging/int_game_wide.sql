with
    int_game_wide as (
        select
            gameid,
            avg(durationminutes) as avg_duration,
            avg(attendance) as avg_attendence
        from {{ ref("stg_game_wide")}}
        group by gameid
    )
select *
from int_game_wide
