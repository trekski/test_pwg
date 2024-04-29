select 
	MAX(smiley_id) AS smiley_code,
	smiley_url,
	emotion,
	smiley_width as w,
	smiley_height as h
from 
phpbb_smilies AS ps 
group by 2, 3, 4, 5
order by 1 asc