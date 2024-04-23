with
    game_wide as (select * from {{ ref("int_game_wide") }}),
    schedule as (select * from {{ ref("stg_schedule") }}),
    final as (select t1.*, t2.status
                from game_wide t1
                        inner join
                    schedule t2
                        on t1.gameid = t2.gameid)
    select * from final
