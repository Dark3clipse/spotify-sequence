SELECT s.*
FROM sequences AS s
INNER JOIN (
    SELECT session_id
    FROM sequences
    GROUP BY session_id
    ORDER BY RAND()
    LIMIT 10
) as r
ON s.session_id = r.session_id
