SELECT 
COUNT(CASE WHEN ma.status = 'ASSIGNED' THEN 1 ELSE NULL END) AS assigned, 
COUNT(CASE WHEN ma.status IN ('COMPLETED', 'VERIFIED') THEN 1 ELSE NULL END) AS completed, 
a.id AS avatar_id,
w.profile->'data'->'full_name' AS name,
w.phone_number
FROM avatar a 
LEFT JOIN 
microtask_assignment ma ON a.id = ma.avatar_id 
LEFT JOIN
worker w ON a.worker_id = w.id
WHERE a.task_id = '10691' 
AND a.is_linked = 't' 
GROUP BY a.id, w.profile->'data'->'full_name', w.phone_number;
