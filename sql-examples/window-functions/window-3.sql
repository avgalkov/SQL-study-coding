# Отбираем ТОП 10 % среди курьеров по кол-ву доставок за весь период
select
  courier_id,
  orders_count,
  courier_rank
from
  (
    select
      courier_id,
      count(distinct order_id) as orders_count,
      row_number() over (
        order by
          count(order_id) desc
      ) as courier_rank
    from
      courier_actions
    where
      action = 'deliver_order'
    group by
      courier_id
    order by
      orders_count desc
  ) t1
where
  courier_rank <= (
    select
      round(0.1 * count(distinct courier_id))
    from
      courier_actions
  )
order by
  courier_rank,
  courier_id