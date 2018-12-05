
create table regexp as
  select 'Aa|aA|Bb|bB|Cc|cC|Dd|dD|Ee|eE|Ff|fF|Gg|gG|Hh|hH|Ii|iI|Jj|jJ|Kk|kK|Ll|lL|Mm|mM|Nn|nN|Oo|oO|Pp|pP|Qq|qQ|Rr|rR|Ss|sS|Tt|tT|Uu|uU|Vv|vV|Ww|wW|Xx|xX|Yy|yY|Zz|zZ' as regexp;

create table polymer as
with recursive tmp(line, removed, iter) as (
  select
    regexp_replace(line, regexp, '') as line,
    (regexp_matches(line, regexp))[1] as removed,
    0 as iter
  from input, regexp
  union all
  select
    regexp_replace(line, regexp, '') as line,
    (regexp_matches(line, regexp))[1] as removed,
    iter + 1
  from tmp, regexp
  where removed notnull
)
select
  line
from tmp
order by iter desc
limit 1;

create view part_2_solution as
with recursive tmp(letter, line, removed, iter) as (
  with removals as (
    select chr(97 + offs) as letter
    from generate_series(0, 25) as offs
  )
  select
    letter,
    regexp_replace(line, '[' || letter || upper(letter) || ']', '', 'g') as line,
    letter as removed,
    0 as iter
  from polymer, regexp, removals
  union all
  select
    letter,
    regexp_replace(line, regexp, '') as line,
    (regexp_matches(line, regexp))[1] as removed,
    iter + 1
  from tmp, regexp
  where removed notnull
)
select min(length(line)) as answer
from tmp;

select 1 as part, length(line) as answer from polymer
union all
select 2 as part, answer from part_2_solution;
