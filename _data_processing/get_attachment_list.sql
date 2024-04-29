select
	post_msg_id,  
	rank() over (partition by post_msg_id order by attach_id asc) -1 as att_order	,
	physical_filename ,
	real_filename ,
	attach_comment AS comment,
	"extension" as ext, 
	mimetype 
from
    phpbb_attachments AS pa 