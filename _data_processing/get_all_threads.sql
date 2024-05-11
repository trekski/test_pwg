select distinct
	forum_id,
	topic_id
from 
	phpbb_posts as pp 
where
	forum_id in ({forums})
	and forum_id >= {from_forum}
	and topic_id >= {from_thread}
	and post_id > {from_post}
ORDER BY
	forum_id ASC,
	topic_id ASC