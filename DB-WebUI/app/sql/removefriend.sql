DELETE FROM Friend
WHERE followed_user_id = %s
AND following_user_id = %s