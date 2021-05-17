WITH network AS (

		SELECT count(distinct id) as c_id from networks
		WHERE
		networks.created_at >= date_trunc('day', now() - interval '1 month')
 
                ),

private_net AS (

		SELECT count(distinct id) as pri_id from networks
		WHERE
		networks.is_public='f'
		AND
		networks.created_at >= date_trunc('day', now() - interval '1 month')
 
                ),

public_net AS (

		SELECT count(distinct id) as pub_id from networks
		WHERE
		networks.is_public='t'
		AND
		networks.created_at >= date_trunc('day', now() - interval '1 month')
 
                ),
                
messages_send AS (

		SELECT us.id as user_id,m.id as activity,
                us.first_name as first_name, us.last_name as last_name, m.created_at,
                rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                FROM messages as m
                INNER JOIN users us ON m.user_id = us.id
                group by us.id, us.first_name, us.last_name, m.created_at,m.id
                ORDER BY m.id, m.created_at DESC
 
                )

select  c_id, from network 
full outer join public_net on
network.c_id=public_net.pub_id
full outer join private_net on
public_net.pub_id=private_net.pri_id
full outer join messages_send on
messages_send.activity=private_net.pri_id


------------------------------------------
/* Direct messages */

select count(ms.id)::text as m_value, count(ms.file_id)::text as cnt_file from messages as ms
inner join channels as cn on
cn.network_id=ms.channel_id
where cn.type=':channel.type/direct'
and ms.created_at >= date_trunc('day', now() - interval '1 month')

