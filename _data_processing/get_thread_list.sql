/*
thread_topic: Lorem Ipsum dolorowow
category: '0'
tags:
    - global_thread
    - thread_announc
    - thread_sticky
    - thread_plain
thread_icon: icons/smiley.gif
thread_icon_desc: smiley
thread_post_count: 123
thread_order: 123345678
thread_start: "2 sty '23"
thread_end: "4 mar '23"
 */
 with post_counts AS (
	select
		topic_id,
		count(*)::varchar as post_count
	from
		phpbb_posts
	group by 1
 )
select
	pt.topic_id,
	pt.topic_title as thread_topic,
	pt.forum_id as forum,
	CASE pt.topic_type
		when 3 then 'global_thread'
		when 2 then 'thread_announc'
		when 1 then 'thread_sticky'
		else ''
	end
	as thread_type,
	case pt.topic_type
		when 3 then 'yes'
		when '2' then 'yes'
		else 'no'
	end as visible_on_top,	
	pi2.icons_url as thread_icon,
	split_part(split_part(pi2.icons_url, '/', -1), '.', 1) thread_icon_desc,
	case pt.topic_type
		when <> 3 then RANK() over (partition by pt.forum_id order by pt.topic_type desc, pp2.post_time desc)
		else -pp2.post_time
	end as thread_order,
	data_po_polsku(
        to_timestamp(pp.post_time)::date
    ) as thread_start,
	data_po_polsku(
        to_timestamp(pp2.post_time)::date
    ) as thread_end,
	pc.post_count AS thread_post_count
from
	phpbb_topics as pt 
	left join phpbb_icons as pi2
		on pt.icon_id = pi2.icons_id 
	left join phpbb_posts as pp 
		on pt.topic_first_post_id = pp.post_id 
	left join phpbb_posts as pp2
		on pt.topic_last_post_id = pp2.post_id 
	left join post_counts as pc
		on pt.topic_id = pc.topic_id
where pt.forum_id = 3 --{forum}
order by thread_order asc