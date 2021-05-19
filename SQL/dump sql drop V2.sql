
Name:
Active Users - Current week
Description:
How many questions each active users answered last week




 select count (a.id) as activity, us.first_name, us.last_name from answers a
INNER JOIN users us ON a.user_id = us.id
WHERE a.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour
group by us.first_name, us.last_name
order by activity DESC

------------------------

﻿
Name:
Project added / day


SELECT date_trunc('day',p.created_at) as day, count (*) FROM projects as p
group by day
order by day

-----------

Name:
Feedback - Volume - Current week


SELECT count (*) FROM answers as p
WHERE p.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour

-------------------
name:
Feedback per campaign


select count(a.id), c.created_at as datum, c.name as "campaign", p.name as "project" from campaigns as c
INNER JOIN answers as a ON c.id = a.campaign_id
INNER JOIN projects as p ON c.project_id = p.id
Group by campaign, datum, project
order by datum DESC

----------------------------------------------------------

Name:
Count(*) Feedback / week - date_trunc





Select date_trunc('week',created_at) as week,
count(*) from answers us
group by week
order by week

------------------------------------------------------------------
Name:
Total Users - DDB





SELECT count (*) from users
-----------------------------------------------------------------------------

Name:
New Users / month - Date_trunc



Select date_trunc('week',created_at)::date as week,
count(*) from users
group by week
order by week

--------------------------------------------

Name:
Feedback - not reviewed


SELECT count(a.score) AS feedback, 
 p.name, 
 u.email, 
 c.name, 
 c.created_at 
FROM answers a 
 inner join campaigns c 
 ON c.id = a.campaign_id 
 inner join users u 
 ON u.id = c.user_id 
 inner join projects p 
 ON c.project_id = p.id 
WHERE a.BODY ->> 'type' = 'simple-short' 
 AND a.scored_at IS NULL
 AND a.answered_at IS NOT NULL
GROUP BY p.name, 
 u.email, 
 a.score, 
 c.name, 
 c.created_at 
ORDER BY feedback DESC;

---------------------------------------------------------------------------------------

Name:


New Validated Projects current week



SELECT count (*) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.campaign_status_step_id = 4 -- 4 = validé
and c.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour

-----------------------------------------------------
Name:
Top 50 Newest Users with Bio


Select created_at, email, last_name, first_name, biography from users
order by created_at DESC limit 50

-------------------------------------------------------------------------
Name:
Project's owner list



SELECT p.created_at as "date", p.name, us.first_name, us.last_name, us.email FROM projects as p
INNER JOIN users as us ON us.id = p.user_id
order by date DESC

-----------------------------------------

Name:
Activity per user per week


select date_trunc('week',a.created_at) as week,
count (a.id) as activity, us.first_name, us.last_name from answers a
INNER JOIN users us ON a.user_id = us.id
group by us.first_name, us.last_name, week
order by week

----------------------------------------------------------------------------------------
Name:
Validated Campaign per week [trunc]


SELECT date_trunc('week',c.created_at) as week, count (*) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.campaign_status_step_id = 4 -- 4 = validé
and c.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour
group by week
order by week

-------------------------------------------------------------------------------

Name:
Feedback^reputation / month
