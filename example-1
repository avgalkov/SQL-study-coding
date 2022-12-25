ALTER TABLE enrollee ADD sex VARCHAR(30);

UPDATE enrollee
SET sex = IF(name_enrollee IN (
            SELECT name_enrollee
            FROM (
                SELECT name_enrollee
                FROM enrollee
                WHERE name_enrollee LIKE '%а %'
            ) table_1
        ), 'female', 'male');

SELECT name_subject,
    male_avg_result,
    female_avg_result
FROM
    subject s
    INNER JOIN (
        SELECT subject_id,
            ROUND(AVG(result), 2) AS male_avg_result
        FROM (
            SELECT subject_id,
                enrollee_id,
                result
            FROM enrollee_subject
            ) table_1
            INNER JOIN enrollee e ON table_1.enrollee_id = e.enrollee_id
        WHERE sex = 'male'
        GROUP BY 1
    ) table_1 ON s.subject_id = table_1.subject_id
    INNER JOIN (
        SELECT subject_id,
            ROUND(AVG(result), 2) AS female_avg_result
        FROM (
            SELECT subject_id,
                enrollee_id,
                result
            FROM enrollee_subject
            ) table_2
            INNER JOIN enrollee e ON table_2.enrollee_id = e.enrollee_id
        WHERE sex = 'female'
        GROUP BY 1
    ) table_2 ON s.subject_id = table_2.subject_id
ORDER BY 1 ASC

