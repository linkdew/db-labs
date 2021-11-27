drop table if exists users cascade;
drop table if exists roles cascade;
drop table if exists posts cascade;
drop table if exists old_posts cascade;

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    username VARCHAR NOT NULL
);

CREATE TABLE roles (
    user_id BIGINT PRIMARY KEY,
    role VARCHAR NOT NULL
);

CREATE TABLE posts (
    post_id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT ,
    rating SMALLINT,
    creation_date TIMESTAMP NOT NULL,
    post_name TEXT NOT NULL,
    post_text TEXT NOT NULL,
    status VARCHAR,
    CONSTRAINT user_constraint
        FOREIGN KEY (user_id)
	        REFERENCES users (user_id)
);

CREATE TABLE old_posts (
    post_id BIGINT NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL ,
    rating SMALLINT,
    creation_date TIMESTAMP NOT NULL,
    post_name TEXT NOT NULL,
    post_text TEXT NOT NULL,
    status VARCHAR
);

INSERT INTO users VALUES (1, '_myasnoy_sashlyk_');
INSERT INTO users VALUES (3, 'loverboy');
INSERT INTO users VALUES (4, 'humanity-restored');
INSERT INTO users VALUES (5, 'sanitar_lesa333');
INSERT INTO users VALUES (9, 'goodnight');
INSERT INTO users VALUES (6, 'SWEETprince');
INSERT INTO users VALUES (12, 'xXteafarmerXx');

INSERT INTO posts VALUES (1, 1, 4, DATE '2019-02-04', 'First Post', 'how to?  ', 'active');
INSERT INTO posts VALUES (2, NULL, 5,  DATE '2021-11-04', 'Second Post?', 'help me...', 'active');
INSERT INTO posts VALUES (11, 12, NULL, DATE '2020-11-14', 'Why?', 'test', 'active');
INSERT INTO posts VALUES (3, 1, NULL,  DATE '2019-07-23', 'Diff?', 'help', 'active');
INSERT INTO posts VALUES (111, 3, 14, DATE '2011-09-29', 'yolo', 'yeah?', 'active');
INSERT INTO posts VALUES (24, 12, -5,  DATE '2015-05-12', 'One?', 'my tea', 'archived');
INSERT INTO posts VALUES (12, 3, 34, DATE '2017-10-22', 'Do Androids Dream of Electric Sheep?', '?', 'active');
INSERT INTO posts VALUES (101, 4, 15,  DATE '2014-06-13', 'Diff?', 'wow', 'archived');
INSERT INTO posts VALUES (43, 6, 14, DATE '2021-03-30', 'dx/dt', 'how to?', 'archived');
INSERT INTO posts VALUES (7, 5, NULL,  DATE '2018-11-12', 'dx/dt', 'love', 'archived');
INSERT INTO posts VALUES (15, 9, -1,  DATE '2018-11-12', 'some', 'love', 'active');

INSERT INTO old_posts VALUES (12, 3, 34, DATE '2017-10-22', 'Do Androids Dream of Electric Sheep?', '?', 'active');
INSERT INTO old_posts VALUES (101, 4, 15,  DATE '2014-06-13', 'Diff?', 'wow', 'archived');
INSERT INTO old_posts VALUES (43, 6, 14, DATE '2021-03-30', 'dx/dt', 'how to?', 'archived');
INSERT INTO old_posts VALUES (7, 5, NULL,  DATE '2018-11-12', 'Do we?', 'love', 'archived');
INSERT INTO old_posts VALUES (15, 9, -1,  DATE '2018-11-12', 'some', 'love', 'active');
INSERT INTO old_posts VALUES (16, 6, 4, DATE '2011-12-04', 'е', 'is e real?', 'active');
INSERT INTO old_posts VALUES (5, 12, 5,  DATE '2012-12-04', 'ее Post?', 'help me...', 'active');
INSERT INTO old_posts VALUES (124, 5, 5, DATE '2010-11-14', 'ее?', 'test', 'active');

INSERT INTO roles VALUES (3, 'admin');
INSERT INTO roles VALUES (12, 'admin');
INSERT INTO roles VALUES (4, 'moder');
INSERT INTO roles VALUES (9, 'moder');
INSERT INTO roles VALUES (5, 'admin');
INSERT INTO roles VALUES (6, 'darksoul (st. moder)');


CREATE OR REPLACE VIEW view_1 AS
    SELECT *
    FROM posts;

CREATE OR REPLACE VIEW view_2 AS
    SELECT *
    FROM posts
    WHERE rating > 10;

CREATE OR REPLACE VIEW view_3 AS
    SELECT *
    FROM posts
    WHERE rating > 10 AND status = 'active';

CREATE OR REPLACE VIEW view_4 AS
    SELECT post_id, post_name, rating
    FROM posts;

CREATE OR REPLACE VIEW view_5 AS
    SELECT post_name AS "Post name", status AS "Current post status"
    FROM posts;

CREATE OR REPLACE VIEW view_6 AS
    SELECT post_id, concat(post_name, ' is ', status) AS "Post name and status"
    FROM posts;

CREATE OR REPLACE VIEW view_7 AS
    SELECT post_name, creation_date,
           CASE
               WHEN creation_date < DATE '2019-01-01' THEN 'old post'
               WHEN creation_date > DATE '2019-01-01' THEN 'pretty new post'
           END freshness
    FROM posts;

CREATE OR REPLACE VIEW view_8 AS
    SELECT *
    FROM posts
    LIMIT 7;

CREATE OR REPLACE VIEW view_9 AS
    SELECT *
    FROM posts
    ORDER BY random()
    LIMIT 8;

CREATE OR REPLACE VIEW view_10 AS
    SELECT *
    FROM posts
    WHERE rating is NULL;

CREATE OR REPLACE VIEW view_11 AS
    SELECT *
    FROM posts
    WHERE post_text LIKE '%?%';

CREATE OR REPLACE VIEW view_12 AS
    SELECT *
    FROM posts
    ORDER BY rating;

CREATE OR REPLACE VIEW view_13 AS
    SELECT *
    FROM posts
    ORDER BY rating, status DESC;

CREATE OR REPLACE VIEW view_14 AS
    SELECT *
    FROM posts
    ORDER BY substr(status, 5, 8);

CREATE OR REPLACE VIEW view_15 AS
    SELECT post_id, coalesce(NULLIF(rating, NULL), '0') AS "rating"
    FROM posts
    ORDER BY coalesce(NULLIF(rating, NULL), '0');

CREATE OR REPLACE VIEW view_16 AS
    SELECT post_name, creation_date,
           CASE
               WHEN creation_date < DATE '2019-01-01' THEN 'old post'
               ELSE 'pretty new post'
           END freshness
    FROM posts
    ORDER BY freshness DESC;

CREATE OR REPLACE VIEW view_17 AS
    SELECT *
    FROM posts
    UNION ALL
    SELECT *
    FROM old_posts;

CREATE OR REPLACE VIEW view_18 AS
    SELECT *
    FROM posts
    NATURAL JOIN users; -- based on foreign key

CREATE OR REPLACE VIEW aux_19 AS
    SELECT post_name, post_text, status
    FROM posts
    WHERE user_id = 1;

CREATE OR REPLACE VIEW view_19 AS
    SELECT *
    FROM posts
    WHERE (post_name, post_text, status)
    IN (
        SELECT post_name, post_text, status FROM posts
        INTERSECT
        SELECT post_name, post_text, status FROM aux_19
    );

CREATE OR REPLACE VIEW view_20 AS
    SELECT * FROM posts
    EXCEPT
    SELECT * FROM old_posts;

CREATE OR REPLACE VIEW view_21 AS
    SELECT posts.*
    FROM posts
    LEFT OUTER JOIN users
    ON users.user_id = posts.user_id
    WHERE users.user_id IS NULL;

CREATE OR REPLACE VIEW view_22 AS
    SELECT p.post_name, u.username, r.role
    FROM posts p JOIN users u
    ON p.user_id = u.user_id
    LEFT JOIN roles r on p.user_id = r.user_id;

CREATE OR REPLACE VIEW view_23 AS
    SELECT count(u.user_id) AS "role count", r.role
    FROM users u JOIN roles r on u.user_id = r.user_id
    GROUP BY r.role;

CREATE OR REPLACE VIEW view_24 AS
    SELECT count(u.user_id) AS "users made that post name count", p.post_name
    FROM users u LEFT OUTER JOIN posts p on u.user_id = p.user_id
    GROUP BY p.post_name;

CREATE OR REPLACE VIEW view_25 AS
    SELECT u.user_id, u.username, p.post_name
    FROM users u FULL OUTER JOIN posts p on u.user_id = p.user_id;

CREATE OR REPLACE VIEW view_26 AS
    SELECT post_id, coalesce(NULLIF(rating, NULL), '0') AS "rating"
    FROM posts
    ORDER BY coalesce(NULLIF(rating, NULL), '0');

CREATE OR REPLACE VIEW view_27 AS
    SELECT substr(word.post_name, iter.pos, 1) AS "word iteration"
    FROM (SELECT post_name FROM posts WHERE post_name = 'yolo') word,
         (SELECT id AS pos FROM _indexes) iter
    WHERE iter.pos < length(word.post_name) + 1;

CREATE OR REPLACE VIEW view_28 AS
    SELECT ' '''' ' AS "result";

CREATE OR REPLACE VIEW view_29 AS
   SELECT post_name,
    replace(translate(post_name,'ABCEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz?/',
    '_______________________________________________________'),'_', ' ')
       AS "only d letter"
   FROM posts;

CREATE OR REPLACE VIEW view_30 AS
    SELECT replace(translate(textdata,'0123456789','0000000000'),'0','') AS textdata,
           cast(replace(translate(lower(textdata),'abcdefghijklmnopqrstuvwxyz',
           rpad('z',26,'z')),'z','') AS INTEGER) AS number
    FROM textdata_30;

CREATE OR REPLACE VIEW view_31 AS
    SELECT name, replace( replace( translate( replace(name, '.', ''),
            'abcdefghijklmnopqrstuvwxyz',
            rpad('0',26,'0') ), '0','' ), ' ','.' ) ||'.' AS "result"
    FROM names_31;

CREATE OR REPLACE VIEW view_32 AS
    SELECT post_name, post_id
    FROM posts
    WHERE post_id IN (
        SELECT cast(result as integer) AS result
        FROM (
            SELECT split_part(list.vals, ',', iter.pos) as result
            FROM (
                SELECT id AS pos from _indexes) iter,
                (SELECT ','||'1, 3, 7'||''||',' AS vals FROM _index) list
                WHERE iter.pos <= length(list.vals)-length(replace(list.vals, ',', ''))
            ) z
    WHERE length(result) > 0
    );

CREATE OR REPLACE VIEW view_33 AS
    SELECT min(rating) AS "min rating", max(rating) AS "max rating"
    FROM posts;

CREATE OR REPLACE VIEW view_34 AS
    SELECT count(*) AS "posts amount"
    FROM posts;

CREATE OR REPLACE VIEW view_35 AS
    SELECT count(rating) AS "not null rating count"
    FROM posts;

CREATE OR REPLACE VIEW view_36 AS
    SELECT sum(rating) AS "rating sum"
    FROM posts;

CREATE OR REPLACE VIEW view_37 AS
    SELECT creation_date, date_part('day', now() - creation_date) as "days posted on forum"
    FROM posts;

CREATE OR REPLACE VIEW view_38 AS
    SELECT to_char(cast(date_trunc('year', current_date) AS DATE) + series.id-1,'DAY'), count(*)
    FROM generate_series(1, 366) series(id)
    WHERE series.id <= (cast(date_trunc('year', current_date) + INTERVAL '12 month' AS DATE) - cast(date_trunc('year', current_date) AS DATE))
    GROUP BY to_char(cast(date_trunc('year', current_date) AS DATE) + series.id-1,'DAY');

CREATE OR REPLACE VIEW view_39 AS
    SELECT
    CASE
         WHEN max(to_char(tmp2.dy+x.id, 'DD'))::int = 29 THEN 'year is leap'
         WHEN max(to_char(tmp2.dy+x.id, 'DD'))::int = 28 THEN 'year isn''t leap'
    END "Is this year leap?"

   FROM (
       SELECT dy, to_char(dy,'MM') AS mth
       FROM (
           SELECT cast(cast(date_trunc('year', current_date) AS DATE) + INTERVAL '1 month' AS DATE) AS dy
           FROM _index
       ) tmp1
   ) tmp2, generate_series (0, 29) x(id)
   WHERE to_char(tmp2.dy + x.id,'MM') = tmp2.mth;

CREATE OR REPLACE VIEW view_40 AS
    SELECT firstday, cast(firstday + INTERVAL '1 month' - INTERVAL '1 day' AS DATE) AS lastday
    FROM (
         SELECT cast(date_trunc('month', current_date) AS DATE) AS firstday
         FROM _index
    ) x;

CREATE OR REPLACE VIEW view_41 AS
    SELECT max(case dw when 2 then dm end) AS Mo,
           max(case dw when 3 then dm end) AS Tu,
           max(case dw when 4 then dm end) AS We,
           max(case dw when 5 then dm end) AS Th,
           max(case dw when 6 then dm end) AS Fr,
           max(case dw when 7 then dm end) AS Sa,
           max(case dw when 1 then dm end) AS Su
FROM (
    SELECT *
        FROM (
            SELECT cast(date_trunc('month', current_date) AS DATE) + x.id,
    to_char(cast(date_trunc('month', current_date) AS DATE) + x.id,'iw') AS wk,
    to_char(cast(date_trunc('month', current_date) AS DATE) + x.id,'dd') AS dm,
    cast(to_char(cast(date_trunc('month', current_date) AS DATE) + x.id,'d') AS INTEGER) AS dw,
    to_char( cast( date_trunc('month', current_date) AS DATE) + x.id,'mm') AS month,
    to_char(current_date, 'mm') AS mth
    FROM generate_series (0, 31) x(id)
        ) x
    WHERE mth = month
    ) y
    GROUP BY wk
    ORDER BY wk;

CREATE OR REPLACE VIEW view_42 AS
    SELECT *
    FROM
    (SELECT (DATE '1970-01-01'+ t4*10000 + t3*1000 + t2*100 + t1*10 + t0) date_interval
    FROM
    (SELECT 0 t0 UNION SELECT 1 UNION SELECT 2 union SELECT 3 UNION SELECT 4 UNION
     SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,

    (SELECT 0 t1 UNION SELECT 1 UNION SELECT 2 union SELECT 3 UNION SELECT 4 UNION
     SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,

    (SELECT 0 t2 UNION SELECT 1 UNION SELECT 2 union SELECT 3 UNION SELECT 4 UNION
     SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,

    (SELECT 0 t3 UNION SELECT 1 UNION SELECT 2 union SELECT 3 UNION SELECT 4 UNION
     SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,

    (SELECT 0 t4 UNION SELECT 1 UNION SELECT 2 union SELECT 3 UNION SELECT 4 UNION
     SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4) v

    WHERE date_interval between '2021-11-19' and '2021-12-14'
    ORDER BY date_interval;

CREATE OR REPLACE VIEW view_43 AS
    SELECT 'date '||y.id||' overlaps date '||x.id AS "overlapping"
    FROM dates_43 x,
         dates_43 y
    WHERE
        y.date1 >= x.date1
        and y.date1 <= x.date2
        and x.id != y.id
