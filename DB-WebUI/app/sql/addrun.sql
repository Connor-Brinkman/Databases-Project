INSERT INTO Run (user_id, level_id, score, run_time) VALUES (
    (SELECT id FROM "User" WHERE id = %s),
    (SELECT id FROM Level WHERE id = %s),
    %s,
    %s
)