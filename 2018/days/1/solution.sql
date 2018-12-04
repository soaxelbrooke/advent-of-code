
create view deltas as
select
  row_number() over () as delta_num,
  cast(ltrim(operation, '+') as bigint) as delta
from input;

create view part_1_solution as
  select 1 as part, sum(delta) as answer from deltas;


create view part_2_solution as
with frequencies as (
  select
    row_number() over () as freq_number,
    sum(delta) over (order by tmp.iteration, delta_num) as freq
  from (
    select * from deltas, generate_series(0, 1000) as iteration
  ) tmp
),
frequency_frequencies as (
  select freq, array_agg(freq_number) freq_numbers from frequencies group by 1
)
select 2 as part, freq as answer from frequency_frequencies order by freq_numbers[2] asc nulls last limit 1;

select * from part_1_solution
union all
select * from part_2_solution;
