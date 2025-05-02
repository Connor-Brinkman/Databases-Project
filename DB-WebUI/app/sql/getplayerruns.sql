SELECT R.id, R.level_id, R.score, R.run_time
FROM Run AS R, User AS U
WHERE U.id = R.user_id