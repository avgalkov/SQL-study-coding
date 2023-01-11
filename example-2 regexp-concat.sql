SELECT
  CONCAT(
    module_id,
    '.',
    lesson_position,
    '.',
    LPAD(step_position, 2, '0'),
    ' ',
    step_name
  ) AS Шаг
FROM
  lesson
  JOIN step USING(lesson_id)
  JOIN step_keyword USING(step_id)
  JOIN keyword USING(keyword_id)
WHERE
  step_name IN (
    SELECT
      step_name
    FROM
      step
    WHERE
      REGEXP_INSTR (keyword_name, CONCAT('\\b', 'MAX', '\\b'))
      OR REGEXP_INSTR (keyword_name, CONCAT('\\b', 'AVG', '\\b'))
  )
GROUP BY
  1
HAVING
  COUNT(keyword_name) = 2
ORDER BY
  1