drop table if exists users cascade;
drop table if exists posts cascade;

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    username VARCHAR NOT NULL
);

CREATE TABLE posts (
    post_id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT,
    rating SMALLINT,
    creation_date TIMESTAMP NOT NULL,
    post_name TEXT NOT NULL,
    post_text TEXT NOT NULL,
    status VARCHAR,
    CONSTRAINT user_constraint
        FOREIGN KEY (user_id)
	        REFERENCES users (user_id)
);

CREATE OR REPLACE FUNCTION average_post_rating()
RETURNS FLOAT
LANGUAGE plpgsql
AS $$
DECLARE
   average_rating FLOAT;
BEGIN
   SELECT avg(rating)
   INTO average_rating
   FROM posts;

   RETURN average_rating;
END;
$$;

CREATE OR REPLACE FUNCTION post_count()
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
   pcount BIGINT;
BEGIN
   SELECT count(*)
   INTO pcount
   FROM posts;

   RETURN pcount;
END;
$$;

INSERT INTO users VALUES (3, 'sinner');
INSERT INTO users VALUES (4, 'humanity-restored');
INSERT INTO users VALUES (9, 'goodnight');

INSERT INTO posts VALUES (111, 3, 14, DATE '2011-09-29', 'yolo', 'yeah?', 'active');
INSERT INTO posts VALUES (12, 3, 34, DATE '2017-10-22', 'Do Androids Dream of Electric Sheep?', '?', 'active');
INSERT INTO posts VALUES (7, 4, 3,  DATE '2018-11-12', 'dx/dt', 'love', 'archived');
INSERT INTO posts VALUES (15, 9, NULL,  DATE '2018-11-12', 'some', 'love', 'active');

-- 1
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = current_user
GROUP BY privilege_type, grantee;

-- 2
CREATE USER loverboy WITH PASSWORD 'dbcreator';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO loverboy;

SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'posts' AND grantee = 'loverboy';

-- 3
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM loverboy;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA public FROM loverboy;

-- 4
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'loverboy'
GROUP BY privilege_type, grantee;

-- 5
GRANT SELECT(post_id, post_name, post_text) ON posts TO loverboy;

-- 6
GRANT EXECUTE ON ROUTINE main.public.post_count() TO loverboy;

-- 7
-- tested

-- 8
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM loverboy;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA public FROM loverboy;
DROP USER loverboy;

SELECT * FROM posts;

-- 9
DO $$
    BEGIN
        UPDATE posts
        SET rating = 0
        WHERE rating IS NULL;
        IF (SELECT count(*) FROM posts) % 2 = 1
            THEN
                ROLLBACK;
            ELSE
                COMMIT;
        END IF;
END
$$;

SELECT * FROM posts;

-- 10
CREATE OR REPLACE PROCEDURE post_name_mod(old_name VARCHAR, new_name VARCHAR)
AS $$
DECLARE
    post_count BIGINT;
BEGIN
    SELECT count(*) INTO post_count
    FROM posts WHERE post_name = old_name;
    IF post_count % 2 = 0 THEN
        ROLLBACK;
    ELSE
        UPDATE posts SET post_name = new_name
        WHERE post_name = old_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

CALL post_name_mod('yolo', 'NEW YOLO');
SELECT * FROM posts;
