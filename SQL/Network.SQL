/*
select count(distinct ns.id ) from networks as ns
inner join private_network_invitations as pn on
ns.id=pn.network_id
*/

select count(distinct id ) from networks
where is_public='t'

