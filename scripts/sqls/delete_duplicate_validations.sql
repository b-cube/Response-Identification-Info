DELETE FROM validations
WHERE id IN (SELECT id
FROM (SELECT id,
	     ROW_NUMBER() OVER (partition BY response_id ORDER BY id) AS rnum
     FROM validations) t
WHERE t.rnum > 1);