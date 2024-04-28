select 
	post_id_txt || ': {{ t: ' || topic_id || ', p: ' || post_page || ' }}' as data_col
from (
	select
		pp.post_id,
        pp.post_id::varchar post_id_txt,
		pp.topic_id::varchar,
		(DIV(
			rank() over (
				partition by pp.topic_id
				order by pp.post_time
				)
			,{posts_per_page}
		)+1)::varchar as post_page
	from
		phpbb_posts as pp
		left join phpbb_topics as pt
			on pp.topic_id = pt.topic_id 
	where
		pt.forum_id in (
			{forums}
	)
) as t
order by post_id asc