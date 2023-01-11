# На основе информации в таблицах orders и products рассчитываем стоимость каждого заказа,
# ежедневную выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах

select
  order_id,
  creation_time,
  order_price,
  sum(order_price) over (partition by DATE(creation_time)) as daily_revenue,
  (
    order_price / sum(order_price) over (partition by DATE(creation_time))
  ) * 100 as percentage_of_daily_revenue
from
  (
    select
      distinct order_id,
      creation_time as creation_time,
      sum(price) over(partition by o.order_id) as order_price
    from
      (
        select
          distinct order_id,
          creation_time,
          unnest(product_ids) as product_id
        from
          orders
        where
          order_id not in (
            select
              order_id
            from
              user_actions
            where
              action = 'cancel_order'
          )
      ) o
      join products p on o.product_id = p.product_id
  ) t2
order by
  DATE(creation_time) desc,
  percentage_of_daily_revenue desc,
  order_id