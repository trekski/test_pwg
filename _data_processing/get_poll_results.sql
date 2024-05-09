SELECT
    poll_option_id AS n,
    poll_option_text AS answer,
    poll_option_total AS num_votes
FROM
    phpbb_poll_options AS ppo 
WHERE
    topic_id = {topic_id}
ORDER BY
    poll_option_id ASC