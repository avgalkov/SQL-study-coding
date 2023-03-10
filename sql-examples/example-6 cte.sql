with res_tab as(
  select
    student_name as Студент,
    concat(
      module_id,
      '.',
      lesson_position,
      '.',
      step_position
    ) as Шаг,
    ROW_NUMBER() over(
      partition by step_id
      order by
        submission_time
    ) as Номер _ попытки,
    result as Результат,
    case
      when submission_time - attempt_time > 3600 then (
        select
          avg(submission_time - attempt_time)
        from
          step_student
          join student on step_student.student_id = student.student_id
          and student_name = 'student_59'
        where
          submission_time - attempt_time <= 3600
      )
      else submission_time - attempt_time
    end as timestamp_attempt,
    step_id,
    submission_time
  from
    step_student
    join student on step_student.student_id = student.student_id
    and student_name = 'student_59'
    join step using(step_id)
    join lesson using(lesson_id)
)
select
  Студент,
  Шаг,
  Номер _ попытки,
  Результат,
  SEC_TO_TIME(round(timestamp_attempt)) as Время _ попытки,
  round(
    timestamp_attempt /(sum(timestamp_attempt) over(partition by Шаг)) * 100,
    2
  ) as Относительное_время
from
  res_tab
order by
  step_id,
  submission_time