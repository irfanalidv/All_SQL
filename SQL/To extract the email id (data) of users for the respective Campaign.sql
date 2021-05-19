/* users in BFA part IV */
Select u.id from networks as nt inner join network_members as nm
on nt.id=nm.network_id
inner join users as u on u.id=nm.user_id
where
nt.id='d5c0b2c0-f6ac-47d1-9238-d8e71463bcf3'
and nm.user_id not in
(
  select nm.user_id from networks as nt
  inner join network_members as nm on nm.network_id=nt.id
  inner join users as u on
  nm.user_id=u.id
  where nt.id='022d7c6f-45c5-4c8e-b9b7-4428fe67326c'
)

---

/* users in BFA part I not in part Iv*/
Select u.id from networks as nt inner join network_members as nm
on nt.id=nm.network_id
inner join users as u on u.id=nm.user_id
where
nt.id='d242dcce-4c98-4c43-815f-4c2747f82c57'
and nm.user_id not in
(
  select nm.user_id from networks as nt
  inner join network_members as nm on nm.network_id=nt.id
  inner join users as u on
  nm.user_id=u.id
  where nt.id='022d7c6f-45c5-4c8e-b9b7-4428fe67326c'
)
and nm.user_id not in

(
Select u.id from networks as nt inner join network_members as nm
on nt.id=nm.network_id
inner join users as u on u.id=nm.user_id
where
nt.id='d5c0b2c0-f6ac-47d1-9238-d8e71463bcf3'
and nm.user_id not in
(
  select nm.user_id from networks as nt
  inner join network_members as nm on nm.network_id=nt.id
  inner join users as u on
  nm.user_id=u.id
  where nt.id='022d7c6f-45c5-4c8e-b9b7-4428fe67326c'
)
)

---

/* Users who have applied but got rejected from the gig or not worked in any projects*/

select distinct(i.user_id) from invitations as i
inner join users as u on u.id=i.user_id
where i.accepted_at is not null
and u.role in (':role/freelancer',':role/verified-freelancer')
and i.user_id not in
(
select distinct(nm.user_id) from network_members as nm
inner join networks as nt on nt.id=nm.network_id
where nt.id in
(
select distinct(nt.id) from networks as nt inner join network_members as nm
on nt.id=nm.network_id
where nm.user_id='a6ae2022-b66d-4fb1-a366-fae1f66e2ce0' /* robot */
)
)

---
/* Inactive users */

with inactive_users as (
WITH subq AS (SELECT distinct us.id as user_id,m.id, m.created_at as created_at ,
 rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
 FROM messages as m
 INNER JOIN users us ON m.user_id = us.id
 where us.role in (':role/freelancer', ':role/verified-freelancer')
 group by us.id, us.first_name, us.last_name, m.created_at,m.id
 ORDER BY m.id, m.created_at DESC )

Select count(distinct(users.id)) as ID from users where users.id not in
(
SELECT user_id
FROM subq
WHERE rank = 1
 AND created_at <= (NOW() - INTERVAL '1 month')
)

),

users_not_in_BFA as 

(
select id from users
where role in (':role/freelancer',':role/verified-freelancer')
and id not in
(
Select u.id from networks as nt inner join network_members as nm
on nt.id=nm.network_id
inner join users as u on u.id=nm.user_id
where
nt.id='d5c0b2c0-f6ac-47d1-9238-d8e71463bcf3'
or 
nt.id='d242dcce-4c98-4c43-815f-4c2747f82c57'
and nm.user_id not in
(
 select nm.user_id from networks as nt
 inner join network_members as nm on nm.network_id=nt.id
 inner join users as u on
 nm.user_id=u.id
 where nt.id='022d7c6f-45c5-4c8e-b9b7-4428fe67326c'
)
)

)

select ID::text from users_not_in_BFA 
union 
select id::text from inactive_users 

