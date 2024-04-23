with
    game_wide as (

        select gameid, durationminutes, attendance
        from {{source('commercial_raw','games_wide')}}

    )
select *
from game_wide
