SELECT
windows.*
FROM
windows
INNER JOIN
houses
ON
windows.house_id = houses.id
INNER JOIN
humans
ON
humans.house_id = houses.id
WHERE
humans.id = 2;
