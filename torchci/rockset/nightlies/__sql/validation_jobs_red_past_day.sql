SELECT
  COUNT(*) COUNT,
  job.name
FROM
  commons.workflow_job job
  JOIN commons.workflow_run workflow on workflow.id = job.run_id
WHERE
  job.head_branch = 'main' 
  AND workflow.name = 'cron' 
  AND workflow.event = 'schedule' 
  AND job.conclusion in ('failure', 'timed_out', 'cancelled') 
  AND job.name like CONCAT('%',:channel,'%') 
  AND workflow.repository.full_name = 'pytorch/builder' 
  AND job._event_time >= CURRENT_DATE() - INTERVAL 1 DAY
GROUP BY job.name
ORDER BY COUNT DESC