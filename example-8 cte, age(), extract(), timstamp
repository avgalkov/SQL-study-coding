with t5 as(
  with t3 as (
    with t4 as(
      select
        order_id,
        unnest(product_ids) as product_id
      from
        orders
    )
    select
      order_id,
      count(product_id) as prod_per_order
    from
      t4
    group by
      order_id
  )
  select
    order_id
  from
    t3
  where
    prod_per_order = (
      with t1 as (
        with t as (
          select
            order_id,
            unnest(product_ids) as product_id
          from
            orders
        )
        select
          order_id,
          count(product_id)
        from
          t
        group by
          order_id
      )
      select
        max(count)
      from
        t1
    )
)
select
  t5.order_id,
  u.user_id,
  extract(
    year
    from
      age(
        (
          select
            max(time)
          from
            user_actions
        ),
        u.birth_date
      )
  ) as user_age,
  ca.courier_id,
  extract(
    year
    from
      age(
        (
          select
            max(time)
          from
            user_actions
        ),
        c.birth_date
      )
  ) as courier_age
from
  t5
  join courier_actions ca on t5.order_id = ca.order_id
  join couriers c on ca.courier_id = c.courier_id
  join user_actions ua on ca.order_id = ua.order_id
  join users u on ua.user_id = u.user_id
where
  ca.action = 'deliver_order'
  and ua.action = 'create_order'
order by
  t5.order_id