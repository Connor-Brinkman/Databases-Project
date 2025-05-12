DELETE FROM Friend
WHERE followed_user_id = (SELECT id FROM "User" WHERE nickname = %s)
AND following_user_id = %s