
# Вычисляем среднее время в часах, которе проходит между заказами пользователя интернет-сервиса покупки продуктов
select
  user_id,
  round(
    EXTRACT(
      epoch
      FROM
        hours_between_orders
    ) / 3600
  ) as hours_between_orders
from
  (
    select
      distinct user_id,
      avg(time_diff) over (partition by user_id) as hours_between_orders
    from
      (
        select
          user_id,
          order_id,
          time,
          row_number() over (
            partition by user_id
            order by
              time
          ) as order_number,
          lag(time, 1) over (
            partition by user_id
            order by
              time
          ) as time_lag,
          time - lag(time, 1) over (
            partition by user_id
            order by
              time
          ) as time_diff
        from
          user_actions
        where
          order_id not in (
            select
              order_id
            from
              user_actions
            where
              action = 'cancel_order'
          )
        order by
          user_id,
          order_number
      ) t2
    order by
      user_id
  ) t3
where
  hours_between_orders is not null