SELECT
    pt.topic_id,
    pt.poll_title,
    max(ppo.poll_option_total) AS max_votes
FROM
    phpbb_topics AS pt
    LEFT JOIN phpbb_poll_options AS ppo
        ON pt.topic_id = ppo.topic_id 
WHERE
    poll_title <> ''
GROUP BY 1, 2
ORDER BY
    topic_id ASC;