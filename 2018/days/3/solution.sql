create extension if not exists cube;

create table claims (
  id bigint primary key,
  claim cube
);

create index claim_cube_idx on claims using gist (claim);

with id_parts as (
  select (regexp_split_to_array(claim, '[^0-9]+'))[2:6] as parts from input
)
insert into claims
select
  cast(parts[1] as bigint),
  cast('(' || parts[2] || ',' || parts[3] || '),(' || (cast(parts[2] as bigint) + cast(parts[4] as bigint))::text || ','|| (cast(parts[3] as bigint) + cast(parts[5] as bigint))::text || ')' as cube)
from id_parts;

create view collisions as
select
  distinct on (cube_inter(lclaim.claim, rclaim.claim))
  case when lclaim.id < rclaim.id then lclaim.id || '-' || rclaim.id else rclaim.id || '-' || lclaim.id end as overlap_id,
  cube_inter(lclaim.claim, rclaim.claim) as claim_overlap
from claims lclaim
  join claims rclaim
    on lclaim.claim && rclaim.claim
         and lclaim.id != rclaim.id;

create view part_1_solution as
with overlaps_x as (
  select overlap_id, generate_series(cast(claim_overlap -> 1 as bigint), cast(claim_overlap -> 3 as bigint) - 1, 1) as x
  from collisions
  where (claim_overlap -> 1) < (claim_overlap -> 3)
  order by overlap_id
), overlaps_y as (
  select overlap_id, generate_series(cast(claim_overlap -> 2 as bigint), cast(claim_overlap -> 4 as bigint) - 1, 1) as y
  from collisions
  where (claim_overlap -> 2) < (claim_overlap -> 4)
  order by overlap_id
), overlap_points as (
  select
    x, y, count(*), array_agg(overlap_id)
  from overlaps_x
    join overlaps_y using (overlap_id)
  group by x, y
)
select 1 as part, count(*) as answer
from overlap_points;

create view part_2_solution as
with p2sol as (
  select id from claims
  except
  select distinct cast(regexp_split_to_table(overlap_id, '-') as bigint) from collisions
)
select 2 as part, p2sol.id as answer from p2sol;

select * from part_1_solution
union all
select * from part_2_solution;
