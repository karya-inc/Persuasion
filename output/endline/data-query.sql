SELECT 
    mta.worker_id,
    mta.output->'data'->>'sound_legible' as sound_legible,
    mta.output->'data'->>'recording_confidence' as recording_confidence,
    mta.output->'data'->>'eligible_for_training' as eligible_for_training,
    mt.input->'files'->>'audio' as audio
FROM 
    microtask_assignment mta
JOIN
    microtask mt on mta.microtask_id = mt.id 
WHERE
    mta.task_id = '12266' AND mta.status = 'VERIFIED'
ORDER BY
    mta.worker_id;