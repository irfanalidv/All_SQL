/*  psql -Umanager -dbftest -hlocalhost -p5433  */

/*finding distinct values ffrom the column */

SELECT DISTINCT(status) AS status FROM campaign_status

/*Active Users - Current week*/

select count (a.id) as activity, us.first_name, us.last_name from answers a
INNER JOIN users us ON a.user_id = us.id
/*Here when applying this where clause not able to retirve data from DB*/
WHERE a.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour
group by us.first_name, us.last_name
order by activity DESC

/*Here we don't have access to id_old,social */
select id,first_name, last_name, gender_id, created_at, language_id from users
limit 3

/*total users activity count */
select count() as activity, us.first_name, us.last_name from answer a
inner join users us on a.user_id=us.id
group by us.first_name, us.last_name
order by activity DESC

/*total feedback received */
select count (*) from answers

/* Validated Campaign per week */
SELECT date_trunc('week',c.created_at)::date as week, count (*) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.status = ':campaign-status/done'
and c.created_at >= CURRENT_TIMESTAMP - INTERVAL '1618' hour
group by week
order by week


SELECT date_trunc('week',c.created_at)::date as week, count (*), status FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.status = ':campaign-status/done'
and c.created_at >= CURRENT_TIMESTAMP - INTERVAL '1618' hour
group by week, status
order by week


/*Testing Json Data
       Feedback - not reviewed*/

SELECT count(a.score) AS feedback, 
       p.name as project_name, 
       c.name as campaign_name, 
       c.created_at 
FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
       inner join projects p 
               ON c.project_id = p.id 
WHERE  a.BODY ->> 'type' = 'simple-short' 
       AND a.scored_at IS NULL
       AND a.answered_at IS NOT NULL
GROUP  BY p.name,  
          a.score, 
          c.name, 
ORDER  BY feedback DESC
limit 3;

/* Feedback per month */
Select extract(month from created_at) as month,
count(*) as score  from answers
group by month
order by month

/* unknown */
Select extract(day from created_at) as dd,
extract(month from created_at) as mon,
count(*) from answers us
where us.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour
group by dd, mon
order by mon



