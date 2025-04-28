SELECT
    worker_id,
    output->'data'->>'interested' as interested
    ...
FROM
    microtask_assignment
WHERE
    task_id = '12319'
AND 
    status = 'VERIFIED';