with
    final as (
        select
            id as team_id,
            team_api_id,
            team_fifa_api_id,
            team_long_name,
            team_short_name as team_logo_name
        from {{source('soccer_bronze','team')}}

    )
select * from final