
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
select count(*) filter (where has_double) * count(*) filter (where has_triple) as checksum
from id_stats;
