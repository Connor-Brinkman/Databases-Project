SELECT U.nickname, R.score, R.run_time
FROM Run AS R, User AS U
WHERE level_id = %s
AND R.user_id = U.id
ORDER BY R.score DESC
LIMIT 3;