select name,text,first_name, last_name from channels as c
inner join networks as n
on n.id=c.network_id
inner join messages as m
on m.channel_id=c.network_id
inner join users as u 
on u.id=m.user_id
where n.user_id=m.user_id


select text, first_name from scored_messages as sm
inner join messages m
on m.id=sm.message_id
inner join channels as c
on c.network_id=m.channel_id
inner join users as u
on u.id=m.user_id
limit 3



