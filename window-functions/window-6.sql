#На основе таблиц с заказами и товарами считаем ежедневную вырочку,
# а так же прирост вырочки относительно предыдущего дня, абсолютный и в процентах
select
  date,
  daily_revenue,
  coalesce(
    daily_revenue - lag(daily_revenue, 1) over (
      order by
        date
    ),
    0
  ) as revenue_growth_abs,
  coalesce(
    (
      daily_revenue - lag(daily_revenue, 1) over (
        order by
          date
      )
    ) * 100 / lag(daily_revenue, 1) over (
      order by
        date
    ),
    0
  ) as revenue_growth_percentage
from
  (
    select
      distinct date,
      sum(price) over(partition by date) as daily_revenue
    from
      (
        select
          distinct order_id,
          DATE(creation_time) as date,
          unnest(product_ids) as product_id
        from
          orders
      ) o
      join products p on o.product_id = p.product_id
    where
      order_id not in (
        select
          order_id
        from
          user_actions
        where
          action = 'cancel_order'
        order by
          order_id
      )
  ) t1
order by
  date