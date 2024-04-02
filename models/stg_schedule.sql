with
    schedule as (
        select gameid, year, status from `bigquery-public-data.baseball.schedules`
    )
select *
from schedule
