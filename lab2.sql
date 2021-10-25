CREATE TABLE posts (
    post_id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    rating SMALLINT,
    creation_date TIMESTAMP NOT NULL,
    post_name TEXT NOT NULL,
    post_text TEXT NOT NULL,
    status VARCHAR
);


CREATE OR REPLACE FUNCTION spaces_deletion_func()
  RETURNS TRIGGER
AS $$
BEGIN
NEW.post_name = LTRIM(NEW.post_name);
NEW.post_text = LTRIM(NEW.post_text);
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER spaces_deletion_before_insert
  BEFORE INSERT
  ON posts
  FOR EACH ROW
  EXECUTE FUNCTION spaces_deletion_func();


CREATE OR REPLACE PROCEDURE post_insertion_procedure (
    _post_id BIGINT,
    _user_id BIGINT,
    _rating SMALLINT,
    _post_creation_date TIMESTAMP,
    _post_name TEXT,
    _post_text TEXT,
    _status VARCHAR
)
AS $$
BEGIN
    INSERT INTO posts (post_id, user_id, rating, creation_date, post_name, post_text, status)
    VALUES (_post_id, _user_id, _rating, _post_creation_date, _post_name, _post_text, _status);
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE PROCEDURE post_deletion_procedure(_post_id BIGINT)
AS $$
BEGIN
    DELETE FROM posts
    WHERE post_id = _post_id;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE PROCEDURE post_upvote(_post_id BIGINT)
AS $$
BEGIN
    UPDATE posts
    SET rating = rating + 1
    WHERE post_id = _post_id;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE PROCEDURE post_downvote(_post_id BIGINT)
AS $$
BEGIN
    UPDATE posts
    SET rating = rating - 1
    WHERE post_id = _post_id;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION average_post_rating()
RETURNS FLOAT
LANGUAGE plpgsql
AS $$
DECLARE
   average_rating FLOAT;
BEGIN
   SELECT AVG(rating)
   INTO average_rating
   FROM posts;

   RETURN average_rating;
END;
$$;


INSERT INTO posts VALUES (1, 13, 4, DATE '2019-02-04', '   First Post', ' how to?  ', 'active');
INSERT INTO posts VALUES (2, 3, 5, TIMESTAMP '2019-02-04 00:34', ' Diff?', 'help me...    ', 'deleted');

CALL post_insertion_procedure(
    BIGINT '112',
    BIGINT '3',
    SMALLINT '5',
    TIMESTAMP '2014-02-04',
    TEXT '  Math Problems  ',
    TEXT '        what do u think?',
    VARCHAR 'archived'
    );

CALL post_insertion_procedure(
    BIGINT '65',
    BIGINT '2',
    SMALLINT '-1',
    TIMESTAMP '2016-12-04 12:23:34',
    TEXT '  Problems  ',
    TEXT '        what?',
    VARCHAR 'archived'
    );

CALL post_upvote(65);
CALL post_downvote(112);

CALL post_deletion_procedure(2);

SELECT average_post_rating();
