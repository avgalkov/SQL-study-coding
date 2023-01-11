with t3 as (
  select
    count(t1.order_id) as par_count,
    product_id1,
    product_id2
  from
    (
      select
        order_id,
        unnest(product_ids) as product_id1
      from
        orders
      where
        order_id not in (
          select
            o.order_id
          from
            orders o
            join user_actions ua on o.order_id = ua.order_id
          where
            action = 'cancel_order'
        )
    ) t1
    join (
      select
        order_id,
        unnest(product_ids) as product_id2
      from
        orders
        where
        order_id not in (
          select
            o.order_id
          from
            orders o
            join user_actions ua on o.order_id = ua.order_id
          where
            action = 'cancel_order'
        )
    ) t2 on t1.order_id = t2.order_id
  where
    t1.product_id1 < t2.product_id2
  group by
    t1.product_id1,
    t2.product_id2
  order by
    par_count desc
)
select
  --p.name as name1,
  --p1.name as name2,
  
  (case 
  when p.name < p1.name then concat('[', p.name, ',', p1.name, ']')
  when p1.name < p.name then concat('[', p1.name, ',', p.name, ']')
  end)
  
   as pair,
  par_count as count_pair
from
  t3
  join products p on t3.product_id1 = p.product_id
  join products p1 on t3.product_id2 = p1.product_id
order by
  par_count desc,pair