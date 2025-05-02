SELECT COUNT(id) AS number_of_runs, AVG(score) AS average_score, MAX(score) AS max_score, AVG(run_time) AS average_time, MIN(run_time) AS min_time
FROM Run 
WHERE level_id = %s