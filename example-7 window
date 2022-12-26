with t1 as(
  with t as (
    select
      year,
      month,
      plan,
      quantity
    from
      sales
    where
      year = 2020
    order by
      month
  )
  select
    year,
    month,
    case
      when plan = 'silver' then rank() over (
        partition by plan
        order by
          quantity desc
      )
      else 0
    end as silver,
    case
      when plan = 'gold' then rank() over (
        partition by plan
        order by
          quantity desc
      )
      else 0
    end as gold,
    case
      when plan = 'platinum' then rank() over (
        partition by plan
        order by
          quantity desc
      )
      else 0
    end as platinum
  from
    t
)
select
  year,
  month,
  sum(silver) as silver,
  sum(gold) as gold,
  sum(platinum) as platinum
from
  t1
group by
  year,
  month
order by
  month

