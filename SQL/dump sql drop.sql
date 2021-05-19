Money as a tip 

select (abs(sum(o.amount))/100)::text as amount_usd from operations as o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
inner join networks as nt
on u.id=nt.user_id
where o.origin='tip'
and 
o.amount < 0
and o.created_at >= date_trunc('day', now() - interval '3 weeks') 


/*SELECT abs(sum(o.amount))/100 as amount FROM operations AS o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
WHERE o.origin='tip'
AND 
o.amount < 0
AND
o.created_at >= date_trunc('day', now() - interval '3 weeks') 
*/
 
/*select (o.amount)/100 as Amount_USD, o.created_at from operations as o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
where
o.amount > 0
AND 
u.id= '50ff1a4d-b2f7-432c-a499-ea015ba83752'
ORDER BY o.created_at DESC
*/

/*SELECT sum(o.amount)/100 as amount FROM operations AS o*/

select u.id, nt.name as network_name,(abs(sum(o.amount))/100)::text as amount_usd from operations as o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
inner join networks as nt
on u.id=nt.user_id
where o.origin='tip'
and
o.amount >0
and 
nt.type=':group'
and
o.created_at >='2019-01-01' 
group by nt.name,u.id
---

---
MONEY IN THE CHANNEL

SELECT u.first_name, u.last_name, nt.name AS Network_Name,(abs(sum(o.amount))/100)::text as Amount_USD from operations as o 
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
inner join networks as nt
on nt.user_id=u.id
WHERE o.origin='tip'
AND
nt.type=':group'
AND 
o.amount >0
GROUP BY u.first_name, u.last_name, nt.name, nt.created_at
ORDER BY nt.created_at DESC


---

---

select (o.amount)/100 as Amount_USD, o.created_at from operations as o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
where
o.amount > 0
AND 
u.id= '50ff1a4d-b2f7-432c-a499-ea015ba83752'
ORDER BY o.created_at DESC

/*SELECT sum(o.amount)/100 as amount FROM operations AS o*/

/*SELECT abs(sum(o.amount))/100 as amount FROM operations AS o
inner join wallets w on o.wallet_id = w.id inner join users u on u.id = w.user_id
WHERE o.origin='tip'
AND 
o.amount < 0
AND
o.created_at >= date_trunc('day', now() - interval '3 weeks') 
*/


---
SELECT (abs(sum(o.amount))/100)::text as Amount_USD FROM operations AS o
JOIN users AS u
ON o.user_id=u.id
JOIN wallets AS w
ON w.id=o.wallet_id
WHERE o.origin='tip'
AND
o.amount <0
---

---
UUID: 50ff1a4d-b2f7-432c-a499-ea015ba83752
select 

(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount >0
AND u.id= '50ff1a4d-b2f7-432c-a499-ea015ba83752'
) as total_money_added, 
(

select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
) 

)as total_money_spend
Total Money_Added excluding BF Team

select 

(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount >0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as total_money_added, 
(

select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
) 

)as total_money_spend
---

---
/*select (

select u.first_name as first_name, u.last_name as last_name, abs(sum(o.amount))/100 as amount from operations as o
join wallets as w
on o.wallet_id=w.id
join users as u
on u.id=w.user_id
where o.amount>0
group by u.id,w.id
order by w.created_at ASC

) as abc,

(
select u.first_name as first_name, u.last_name as last_name, abs(sum(o.amount))/100 as amount from operations as o
join wallets as w
on o.wallet_id=w.id
join users as u
on u.id=w.user_id
where o.amount>0
group by u.id,w.id
order by w.created_at ASC
) as aabc; 

select * from abc as a1
inner join aabc as a
on a.first_name=a1.first_name
*/

/*select u.first_name, u.last_name, abs(sum(o.amount))/100 as amount from operations as o
join wallets as w
on o.wallet_id=w.id
join users as u
on u.id=w.user_id
group by u.id,w.id
order by w.created_at ASC*/

SELECT u.first_name, u.last_name, nt.name AS Network_Name,(sum(o.amount)/100)::text as Amount_USD FROM networks AS nt
JOIN users AS u
ON nt.user_id=u.id
JOIN operations AS o
ON o.user_id=u.id
JOIN wallets AS w
ON w.id=o.wallet_id
WHERE o.origin='tip'
AND
nt.type=':group'
AND 
o.amount >-1
GROUP BY u.first_name, u.last_name, nt.name, nt.created_at
ORDER BY nt.created_at DESC
---

---
select 

(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount >0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as total_money_added, 
(

select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
) 

)as total_money_spend

---

---
select 

(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount >0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as total_money_added, 
(

select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
) 

)as total_money_spend, 
(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where o.origin='tip'
AND 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as spent_on_mes_tip

---

---
select 

(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount >0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as total_money_added, 
(

select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
) 

)as total_money_spend, 
(
select abs(sum(amount))/100 as Amount_USD from wallets as w
join operations as o
on w.id=o.wallet_id
join users as u
on u.id=w.user_id
and u.id=o.user_id
where 
where origin='tip'
AND 
o.amount <0
AND u.id not in
(
select nm.user_id from networks as n
join network_members as nm
on nm.network_id=n.id
join users as u
on u.id=nm.user_id
where 
n.id ='f7b03af4-9f56-4f38-90d0-4d8604c4adcd'
)

) as spent_on_mes_tip,

(
select abs(sum(amount))/100 from operations
where origin='manual'
and amount <0
) as spent_on_client_manual_added_v1,

(
select abs(sum(amount))/100 from operations
where origin='Manual action'
and amount <0
) as spent_on_client_manual_added_v2,

(
select abs(sum(amount))/100 from operations
where origin='referal'
and amount <0
) as spent_on_referal


---

---

/*
select * from wallets as w
join operations as o
on w.id=o.wallet_id
join questions as q
on w.question_id=q.id
limit 3
*/



/*select * from operations as op
join wallets as wl
on wl.id=op.wallet_id
where origin='tip'
*/

/*how many members in the group
SELECT network_id, COUNT (DISTINCT user_id)
 FROM network_members
 group by network_id
 */



SELECT u.first_name, u.last_name, nt.name, nt.description, date_trunc('day',nt.created_at)::date as date_, 
abs(sum(amount))/100 as Amount_USD from networks as nt
JOIN users as u
ON nt.user_id=u.id
join campaigns as cm
on cm.network_id=nt.id
join operations as o
on o.campaign_id=cm.id
join wallets as w
on w.id=o.wallet_id
where o.origin='tip'
AND
nt.type=':group'
AND 
o.amount >0
group by u.first_name, u.last_name"
limit 3

/*
select abs(sum(amount))/100 as Amount_USD,o.id from wallets as w
join operations as o
on w.id=o.wallet_id
where o.origin='tip'
AND 
o.amount >0
group by o.id
*/

/*

/*

WHERE nt.type=':group'
AND nt.name IS NOT NULL
AND archived_at IS NOT NULL
*/

