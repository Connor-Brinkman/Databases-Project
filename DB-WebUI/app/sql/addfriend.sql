INSERT INTO Friend (following_user_id, followed_user_id) VALUES (
    (SELECT id FROM User WHERE id = %s),
    (SELECT id FROM User WHERE id = %s)
)