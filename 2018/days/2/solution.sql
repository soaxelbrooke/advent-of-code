
create view part_1_solution as
with id_letters as (
  select id, regexp_split_to_table(id, '') letter from input
), id_letter_counts as (
  select id, letter, count(*) as letter_count from id_letters group by id, letter
), id_stats as (
  select
    id,
    bool_or(letter_count = 2) as has_double,
    bool_or(letter_count = 3) as has_triple
  from id_letter_counts
  group by id
)
select 1 as part, cast(count(*) filter (where has_double) * count(*) filter (where has_triple) as text) as answer
from id_stats;


create view part_2_solution as
with id_letters as (
  select
    (row_number() over ()) - idx_offset as idx,
    id,
    letter
  from (
    select id, regexp_split_to_table(id, '') as letter, sum(length(id)) over (order by id) as idx_offset from input
    order by id
  ) tmp_id_letters
),
letter_distances as (
  select
    left_id.id as left_id,
    right_id.id as right_id,
    sum(cast(left_id.letter != right_id.letter as integer)) as letter_distance
  from id_letters left_id
    full outer join id_letters right_id
    on left_id.idx = right_id.idx and left_id.id != right_id.id
  group by left_id, right_id
  order by letter_distance asc
  limit 1
),
mismatched_ids as (
  select
    regexp_split_to_table(left_id, '') as left_letter,
    regexp_split_to_table(right_id, '') as right_letter
  from letter_distances
)
select 2 as part, string_agg(left_letter, '') as answer from mismatched_ids where left_letter = right_letter;

select * from part_1_solution
union all
select* from part_2_solution;
