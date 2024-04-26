with labeled_data as (
	select
		post_id,
		bbcode_uid ,
		post_text ,
		post_text like '%[u:' || bbcode_uid || '%' as has_u,
		post_text like '%[b:' || bbcode_uid || '%' as has_b,
		post_text like '%[i:' || bbcode_uid || '%' as has_i,
		post_text like '%[s:' || bbcode_uid || '%' as has_s,
		post_text like '%[sup:' || bbcode_uid || '%' as has_sup,
		post_text like '%[sub:' || bbcode_uid || '%' as has_sub,
		post_text like '%[quote:' || bbcode_uid || '%' as has_quote,
		post_text like '%[code:' || bbcode_uid || '%' as has_code,
		post_text like '%[list:' || bbcode_uid || '%' as has_list,
		post_text like '%[url%:' || bbcode_uid || '%' as has_url,
		post_text like '%[img:' || bbcode_uid || '%' as has_img,
		post_text like '%[youtube:' || bbcode_uid || '%' as has_youtube,
		post_text like '%[color:' || bbcode_uid || '%' as has_color,
		post_text like '%[size:' || bbcode_uid || '%' as has_size,
		post_text like '%[style:' || bbcode_uid || '%' as has_style,
		post_text like '%[attachment%:' || bbcode_uid || '%' as has_attachment
	from phpbb_posts as pp
),
counted_tags as (
	select
		*,
		has_u::int + 
		has_b::int + 
		has_i::int +
		has_s::int +
		has_sup::int + 
		has_sub::int + 
		has_quote::int + 
		has_code::int +
		has_list::int +
		has_url::int + 
		has_img::int + 
		has_youtube::int + 
		has_color::int + 
		has_size::int + 
		has_style::int as num_different_tags
	from labeled_data
)
select *
from counted_tags
where has_Attachment and post_Text like '%[attachment=1%'

/*
where has_url and post_text like '%pwgay%'
order by length(post_text) - length(replace(post_text, '[url:' || bbcode_uid, '')) desc

http&#58;//pwgay&#46;org/forum/viewtopic&#46;php?p=49965&amp;f=2#p49965
http&#58;//pwgay&#46;7z9&#46;net/forum/viewtopic&#46;php?t=119
http&#58;//pwgay&#46;org/forum/viewtopic&#46;php?f=15&amp;t=2844&amp;start=1335
http&#58;//pwgay&#46;org&#46;/forum/memberlist&#46;php?mode=&amp;sk=m&amp;sd=d
http&#58;//pwgay&#46;org/forum/viewtopic&#46;php?f=14&amp;t=3406
http&#58;//www&#46;pwgay&#46;org/portal
http&#58;//pwgay&#46;org
http&#58;//pwgay&#46;7z9&#46;net/forum/viewtopic&#46;php?p=6248#6248
http&#58;//pwgay&#46;7z9&#46;net/forum/groupcp&#46;php?g=57
http&#58;//pwgay&#46;7z9&#46;net/link&#46;php?15

select * from phpbb_attachments pa 

select * from phpbb_posts pp where post_attachment <> 0
*/

select * from phpbb_posts pp  where post_id  = 43096

select attach_id , real_filename, split_part(real_filename, '.', 2)  from phpbb_attachments pa 
where split_part(real_filename, '.', 2) = '3'

select * from phpbb_attachments where attach_id in (110, 111, 108, 109) --> 39977

select * from phpbb_posts pp  where post_id  = 39977

select * from phpbb_posts pp  where post_attachment <> 0 
and post_text not like '%[attachment%'
-- 36460
-- post_text: na pewno

select * from phpbb_attachments where post_msg_id = 36460


-- where post_msg_id = 43096
/*
122	duckduck.JPG
121	ubuntu.JPG
120	orange.JPG
*/