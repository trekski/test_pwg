select 
	MAX(smiley_id) AS smiley_code,
	smiley_url,
	emotion 
from 
phpbb_smilies AS ps 
group by 2, 3
order by 1 asc