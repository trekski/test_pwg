
with ranks as (
    select
        rank_id,
        rank_title,
        rank_min,
        LEAD(rank_min) over (order by rank_min) - 1 as rank_max
    from phpbb_ranks pr 
    where rank_special = 0
)
select 
	pu.user_id,
	pu.username,
	case
		when pu.user_id = 1 then 'guest'  -- anonymous user
		when pu.group_id = 81 then 'admin'
        when pu.group_id = 80 then 'mod'
        when pug.user_id is not null then
            case
                when pu.user_id in (2, 10) then 'ex_admin'
                else 'ex_mod'
            end
        else 'user'
	end as user_role,
	data_po_polsku(to_timestamp(pu.user_regdate)::date) as user_joined_date,
	case
		when pu.user_id = 1 then 0 -- anonymous user
		else user_posts
	end as user_posts,
	case
		when pu.user_id = 1 then 'gość' -- anonymous user
		else ranks.rank_title
	end as rank_title,
    CASE
		WHEN pu.user_from = ''
		THEN '---'
		else pu.user_from
	end as user_from,
	case
		when pu.user_id = 1 then '/assets/avatars/avatar_anonymous.png'
		else
			case pu.user_avatar_type
				when 1 then '/assets/avatars/upload/' ||pu.user_id::varchar || '.' ||  split_part(user_avatar, '.', 2)
				when 2 then user_avatar -- direct link to the image
				when 3 then '/assets/avatars/gallery/' || user_avatar
				else '/assets/avatars/avatar_placeholder.png' -- no avatar, or avatar type 0
			end
	end as user_avatar
from 
	phpbb_users pu 
	left join  phpbb_user_group pug
 		on pu.user_id = pug.user_id
 		and pug.group_id = 34 
 	left join ranks
 		on pu.user_posts
 			between ranks.rank_min
 			and coalesce(ranks.rank_max, pu.user_posts)
 where 
	(
		pu.user_type <> 2
		and pu.user_posts > 0
	) or pu.user_id =1 -- anonymous user
 order by pu.user_id asc