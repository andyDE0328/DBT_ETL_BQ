{{ config(
    pre_hook="insert into `project-beyond-418616.stagging.model_logging` values ('fact_game_stats','Started', CURRENT_TIMESTAMP())" ,
    post_hook="insert into `project-beyond-418616.stagging.model_logging` values ('fact_game_stats','Ended', CURRENT_TIMESTAMP())" ,
) }}

with
    game_wide as (select * from {{ ref("int_game_wide") }}),
    schedule as (select * from {{ ref("stg_schedule") }}),
    final as (select t1.*, t2.status,
                t1.avg_duration > {{ var('std_time')}} as is_over_time
              from game_wide t1
                        inner join
                    schedule t2
                        on t1.gameid = t2.gameid)
    select * from final
