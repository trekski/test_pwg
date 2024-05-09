SELECT
    topic_id,
    poll_title
FROM
    phpbb_topics AS pt
WHERE
    poll_title <> ''
ORDER BY
    topic_id ASC;