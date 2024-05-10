WITH
thread_stats AS (
    SELECT
        topic_id,
        to_timestamp(MIN(post_time)) AS first_post
    FROM
        phpbb_posts pp2
    GROUP BY
        1
)
,forum_stats AS (
    SELECT
        pt.forum_id,
        MIN(first_post) AS first_post
    FROM
        phpbb_topics                    AS pt 
        LEFT join thread_stats          AS ts
            ON pt.topic_id = ts.topic_id
    GROUP BY 1
)
SELECT
    f1.forum_id                         AS grp_id,
    f1.forum_name                       AS grp_name,
    f2.forum_id,
    f2.forum_name,
    f2.forum_desc                       AS forum_description,
    f2.forum_topics                     AS forum_thread_count,
    f2.forum_posts                      AS forum_post_count,
    data_po_polsku(fs.first_post::DATE) AS forum_first_post,
    data_po_polsku(
        to_timestamp(
            f2.forum_last_post_time
        )::DATE
    )                                   AS forum_last_post
FROM
    phpbb_forums                        AS f1 
    LEFT JOIN phpbb_forums              AS f2
        ON f2.parent_id = f1.forum_id
    LEFT JOIN forum_stats               AS fs
        ON f2.forum_id = fs.forum_id
WHERE
	f2.parent_id <> 0
	AND f2.forum_id NOT IN ({exlcude_forums})
ORDER BY
	f1.forum_id ASC,
	f2.forum_id ASC