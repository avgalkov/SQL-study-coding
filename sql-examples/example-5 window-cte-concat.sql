with table_1 as (
  select
    lesson_id,
    student_id,
    sum(submission_time - attempt_time) as время
  from
    step
    join step_student using(step_id)
  where
    submission_time - attempt_time <= 14400
  group by
    lesson_id,
    student_id
),
table_2 as (
  select
    lesson_id,
    round(avg(время) / 3600, 2) as Среднее_время
  from
    table_1
  group by
    lesson_id
)
select
  ROW_NUMBER() OVER(
    order by
      Среднее_время
  ) as Номер,
  concat(module_id, '.', lesson_position, ' ', lesson_name) as Урок,
  Среднее_время
from
  table_2
  join lesson using(lesson_id)
order by
  Среднее_время;