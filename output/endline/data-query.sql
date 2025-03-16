SELECT 
    mta.worker_id,
    mta.output->'data'->>'sound_legible' as sound_legible,
    mta.output->'data'->>'recording_confidence' as recording_confidence,
    mta.output->'data'->>'eligible_for_training' as eligible_for_training,
    mt.input->'files'->>'audio' as audio,
    kf.orig_name as original_name
FROM 
    microtask_assignment mta
JOIN
    microtask mt on mta.microtask_id = mt.id
JOIN 
    karya_file kf on mt.input->'files'->>'audio' = kf.name
WHERE
    mta.task_id = '12266' AND mta.status = 'VERIFIED'
ORDER BY
    mta.worker_id;