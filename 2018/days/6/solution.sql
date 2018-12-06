
create extension if not exists cube;

create table locations as
select
  row_number() over () as id,
  line::cube as location
from input;

create index location_idx on locations using gist (location);

create view max_locations as
  select
    max(location -> 1)::integer as max_x,
    max(location -> 2)::integer as max_y
  from locations;

create table infinites as
with outliers as (
  select cast(3 * max_x || ', ' || generate_series(-3 * max_y, 3 * max_y) as cube) as coord from max_locations
  union all
  select cast(generate_series(-3 * max_x, 3 * max_x) || ', ' || 3 * max_x as cube) as coord from max_locations
  union all
  select cast(-3 * max_x || ', ' || generate_series(-3 * max_y, 3 * max_y) as cube) as coord from max_locations
  union all
  select cast(generate_series(-3 * max_x, 3 * max_x) || ', ' || -3 * max_x as cube) as coord from max_locations
)
select distinct
  (
    select location
    from locations
    order by location <#> coord limit 1
  ) as location
from outliers;

create table finites as
select location from locations
except
select location from infinites;

create table unsafe_coord_distances as
with coords as (
  select
    cast(x || ', ' || y as cube) as coord
  from max_locations,
       generate_series(0, 2.5 * max_locations.max_x) as x,
       generate_series(0, 2.5 * max_locations.max_y) as y
)
select
  coord,
  (
    with location_distances as (
      select
        location,
        coord <#> location as distance
      from locations
    ), shared_distances as (
      select
        *,
        lead(distance) over (order by distance) = distance
          or lag(distance) over (order by distance) = distance as shared
      from location_distances
    )
    select
      case when shared then null else location end as location
    from shared_distances
    order by coord <#> location limit 1
  ) as location
from coords;

create view part_1_solution as
with areas as (
  select location, count(*) as area
  from unsafe_coord_distances join finites using (location)
  group by location
  order by area desc
)
select 1 as part, area as answer from areas limit 1;

create table safe_coord_dinstances as
with coords as (
  select
    cast(x || ', ' || y as cube) as coord
  from max_locations,
       generate_series(0, 2.5 * max_locations.max_x) as x,
       generate_series(0, 2.5 * max_locations.max_y) as y
)
select
  coord,
  sum(location <#> coord) as total_distance
from coords, locations
group by coord;

create view part_2_solution as
select 2 as part, count(*) as answer from safe_coord_dinstances where total_distance < 10000;

select * from part_1_solution
union all
select * from part_2_solution;
