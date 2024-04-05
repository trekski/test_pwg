/*
thread_topic: Lorem Ipsum dolorowow
category: '0'
tags:
    - global_thread
    - thread_announc
    - thread_sticky
    - thread_plain
thread_icon: smiley.gif
thread_post_count: 123
thread_order: 123345678
thread_start: "2 sty '23"
thread_end: "4 mar '23"
 */
select
	pt.topic_title as thread_topic,
	pt.forum_id as category,
	CASE pt.topic_type
		when 3 then 'global_thread'
		when 2 then 'thread_announc'
		when 1 then 'thread_sticky'
		else ''
	end
	as tags,
	pi2.icons_url as thread_icon,
	pp2.post_time as thread_order,
	data_po_polsku(
        to_timestamp(pp.post_time)::date
    ) as thread_start,
	data_po_polsku(
        to_timestamp(pp2.post_time)::date
    ) as thread_end
from
	phpbb_topics as pt 
	left join phpbb_icons as pi2
		on pt.icon_id = pi2.icons_id 
	left join phpbb_posts as pp 
		on pt.topic_first_post_id = pp.post_id 
	left join phpbb_posts as pp2
		on pt.topic_last_post_id = pp2.post_id 
where pt.forum_id = 3