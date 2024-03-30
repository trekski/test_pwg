with
thread_stats as (
    select
        topic_id,
        to_timestamp(min(post_time)) as first_post
    from
        phpbb_posts pp2
    group by
        1
)
,forum_stats as (
    select
        pt.forum_id,
        min(first_post) as first_post
    from
        phpbb_topics pt 
        left join thread_stats as ts
            on pt.topic_id =ts.topic_id
    group  by 1
)
select
    --f1.forum_id as grp_id,
    --f1.forum_name as grp_name,
    f2.forum_id,
    f2.forum_name ,
    --f2.forum_desc ,
    --f2.forum_topics,
    --f2.forum_posts,
    data_po_polsku(fs.first_post::date) as forum_first_post,
    data_po_polsku(
        to_timestamp(f2.forum_last_post_time)::date
    ) as forum_last_post
from
    phpbb_forums as f1 
    left join phpbb_forums as f2
        on f2.parent_id = f1.forum_id
    left join forum_stats as fs
        on f2.forum_id = fs.forum_id
where f1.parent_id = 0
order by f1.forum_id asc, f2.forum_id asc
