# Медианная стоимость всех заказов из таблицы orders
with t3 as (
  with t2 as (
    select
      order_id,
      order_price,
      count(order_price) over() / 2 as avg_num,
      row_number() over (
        order by
          order_price
      )
    from
      (
        select
          distinct o.order_id,
          sum(price) over(partition by order_id) as order_price
        from
          (
            select
              distinct order_id,
              creation_time as date,
              unnest(product_ids) as product_id
            from
              orders
          ) o
          join products p on o.product_id = p.product_id
        where
          o.order_id not in (
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
  )
  select
    order_price
  from
    t2
  where
    row_number = (
      select
        distinct avg_num
      from
        t2
    )
    or row_number = (
      select
        distinct avg_num + 1
      from
        t2
    )
)
select
  sum(order_price) / 2 as median_price
from
  t3