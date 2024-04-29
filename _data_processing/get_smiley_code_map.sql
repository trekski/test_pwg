select 
	code,
	MAX(smiley_id) over (partition by smiley_url) as smiley_id
from 
phpbb_smilies AS ps 