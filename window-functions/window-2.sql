# Вычисляем долю отмененных заказов относительно оформленных в текущий момент времени
select
  user_id,
  order_id,
  action,
  time,
  created_orders,
  canceled_orders,
  round(
    (
      canceled_orders :: decimal / created_orders :: decimal
    ),
    2
  ) as cancel_rate
from
  (
    select
      user_id,
      order_id,
      action,
      time,
      count(order_id) filter(
        where
          action = 'create_order'
      ) over (
        partition by user_id
        order by
          time RANGE UNBOUNDED PRECEDING
      ) as created_orders,
      count(order_id) filter(
        where
          action = 'cancel_order'
      ) over (
        partition by user_id
        order by
          time RANGE UNBOUNDED PRECEDING
      ) as canceled_orders
    from
      user_actions
    order by
      user_id,
      order_id,
      action,
      time
  ) t1
order by
  user_id,
  order_id,
  action,
  time