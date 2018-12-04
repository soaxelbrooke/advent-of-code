
create table sleep_events (
  session_id bigint,
  dt timestamp,
  guard_id bigint,
  label text
);

insert into sleep_events
with raw_sleep_events as (
  select
    to_timestamp((regexp_matches(log, '\[[0-9\- :]+\]'))[1], '[YYYY-MM-DD HH24:MI]') dt,
    ltrim((regexp_matches(log, '#[0-9]+'))[1], '#') guard_id,
    (regexp_matches(log, 'falls asleep|wakes up|begins shift'))[1] as label
  from input
  order by log
),
sleep_sessionized as (
  select
    dt,
    guard_id,
    sum(case when guard_id isnull then 0 else 1 end) over (order by dt) as session_num,
    label
  from raw_sleep_events
)
select
  session_num,
  dt,
  first_value(cast(guard_id as bigint)) over (partition by session_num order by dt) as guard_id,
  label
from sleep_sessionized;

create table sleeps as
select
  session_id,
  guard_id,
  dt,
  case
    when label = 'wakes up'
      then int4range(
        extract(epoch from age(lag(dt) over (partition by session_id order by dt), date_trunc('day', dt)))::integer / 60 - 1,
        extract(epoch from age(dt, date_trunc('day', dt)))::integer / 60 - 1,
        '(]'
      )
    else null
  end as sleep_range,
  case when label = 'wakes up' then dt - lag(dt) over (partition by session_id order by dt) else null end as time_slept
from sleep_events;

create view part_1_solution as
with sleepiest_guard as (
  select
    guard_id,
    sum(time_slept) filter (where time_slept notnull) total_sleep
  from sleeps
  group by guard_id
  order by total_sleep desc nulls last
  limit 1
),
sleepiest_guard_sleepiest_hour as (
  select
    guard_id,
    minute,
    count(*)
  from generate_series(-30, 100) minute join sleeps
    on sleeps.sleep_range @> minute
  join sleepiest_guard using (guard_id)
  group by guard_id, minute
  order by count desc
  limit 1
)
select 1 as part, guard_id * minute as answer from sleepiest_guard_sleepiest_hour;

create view part_2_solution as
with sleepiest_guard_mintues as (
  select guard_id, minute, count(*)
  from sleeps join generate_series(-30, 100) minute
    on sleeps.sleep_range @> minute
  group by guard_id, minute
  order by count desc
  limit 1
)
select 2 as part, guard_id * minute from sleepiest_guard_mintues;

select * from part_1_solution
union all
select * from part_2_solution;
