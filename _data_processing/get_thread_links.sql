select 
pt.topic_id ,
CASE
    WHEN pt.topic_type = 3
    THEN {default_forum_id}
    ELSE pt.forum_id
END AS forum_id,
case
	when pt.topic_type in (3, 2) then 1 -- global and anouncements are not paged => redirect to page 1
	else DIV(RANK() over (partition by pt.forum_id , pt.topic_type in (3, 2) order by pt.topic_type desc, pp2.post_time desc), {threads_per_page}) + 1
end as thread_page
from
	phpbb_topics as pt 
	left join phpbb_posts as pp2
		on pt.topic_last_post_id = pp2.post_id 