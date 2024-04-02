with
    schedule as (
        select gameid, year, status from {{source('commercial_raw','schedules')}}
    )
select *
from schedule
