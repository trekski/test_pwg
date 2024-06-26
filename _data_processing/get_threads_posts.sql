SELECT
    pp.forum_id,
    pf.forum_name,
    pp.topic_id,
    pt.topic_title,
    pp.post_id,
    pp.bbcode_uid,
    pp.post_subject,
    pp.poster_id,
    pp.post_time,
    1 AS post_page,
    to_timestamp(pp.post_time) as post_timestamp,
    TO_CHAR(to_timestamp(pp.post_time)::date, 'yyyy-mm-dd') AS post_date,
    TO_CHAR(to_timestamp(pp.post_time), 'HH24:MI') || '' AS post_time,
    pp.post_text
FROM
    phpbb_posts AS pp
    LEFT JOIN phpbb_forums AS pf
        ON pf.forum_id = pp.forum_id
    LEFT JOIN phpbb_topics AS pt
    	ON pp.topic_id = pt.topic_id 
WHERE
    pp.topic_id = {thread_id}
ORDER BY 
    pp.post_id ASC