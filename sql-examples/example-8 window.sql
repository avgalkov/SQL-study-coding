with data as (
  select
    year,
    quarter,
    sum(revenue) as revenue,
    lag(sum(revenue), 4) over w as prev,
    round(
      sum(revenue) * 100.0 / lag(sum(revenue), 4) over ()
    ) as perc
  from
    sales
  group by
    year,
    quarter window w as (
      order by
        year,
        quarter
    )
)
select
  year,
  quarter,
  revenue,
  prev,
  perc
from
  data
where
  year = 2020
order by
  quarter;