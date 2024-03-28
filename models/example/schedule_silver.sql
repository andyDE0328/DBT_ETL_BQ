select t1.*, t2.year  from
(SELECT gameId, avg(durationMinutes) as avg_duration, avg(attendance) as avg_attendence FROM `bigquery-public-data.baseball.games_wide` group by gameId)  t1
inner join
`bigquery-public-data.baseball.schedules` t2
on t1.gameId = t2.gameId