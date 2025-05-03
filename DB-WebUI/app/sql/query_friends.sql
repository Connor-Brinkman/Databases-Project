SELECT u.nickname
FROM "User" AS u
WHERE u.id IN (SELECT f.followed_user_id FROM Friend AS f WHERE f.following_user_id = %s);