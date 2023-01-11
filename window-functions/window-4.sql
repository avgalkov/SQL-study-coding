# Выбираем всех курьеров, которые отработали в компании более 10 дней и джойним запрос с количестов их доставок за весь период
select
  t1.courier_id,
  days_employed :: int,
  delivered_orders
from
  (
    select
      distinct courier_id,
      DATE_PART(
        'day',
        (
          select
            max(time)
          from
            courier_actions
        ) - min(time) over (partition by courier_id)
      ) as days_employed
    from
      courier_actions
  ) t1
  join (
    select
      courier_id,
      count(distinct order_id) as delivered_orders
    from
      courier_actions
    where
      action = 'deliver_order'
    group by
      courier_id
  ) t2 on t1.courier_id = t2.courier_id
where
  days_employed >= 10
order by
  days_employed desc,
  t1.courier_id