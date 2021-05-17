/*EXPLAIN (ANALYZE, BUFFERS)*/


---------------------------------
/*updating active users on 24th of SEP*/

WITH subq AS (SELECT m.id,
                      us.first_name, us.last_name, m.created_at,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.first_name, us.last_name, m.created_at,m.id
                      ORDER BY m.id, m.created_at DESC)
SELECT *
FROM subq
WHERE rank = 1
      AND created_at >= (NOW() - INTERVAL '1 week');


WITH subq AS ((SELECT m.id,
                      us.first_name, us.last_name, m.created_at,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.first_name, us.last_name, m.created_at,m.id
                      ORDER BY m.id, m.created_at DESC)
                UNION
                (
                 SELECT a.id,
                      us.first_name, us.last_name, a.created_at,
                      rank() OVER (PARTITION BY a.id ORDER BY a.created_at DESC) AS rank
                      FROM answers as a
                      INNER JOIN users us ON a.user_id = us.id
                      group by us.first_name, us.last_name, a.created_at,a.id
                      ORDER BY a.id, a.created_at DESC
                )  
                      )
                      
SELECT *
FROM subq
WHERE rank = 1
      AND created_at >= (NOW() - INTERVAL '1 week');
      


---------------------------------

SELECT   campaign_id, status, created_at
FROM     campaign_status
WHERE    status = ':campaign-status/running'
AND      created_at >= (NOW() - INTERVAL '1 week')
ORDER BY campaign_id, created_at DESC

-----------------

WITH subq AS (SELECT campaign_id,
                      status,
                      created_at,
                      rank() OVER (PARTITION BY campaign_id ORDER BY created_at DESC) AS rank
                      FROM campaign_status
                      GROUP BY campaign_id, status, created_at
                      ORDER BY campaign_id, created_at DESC)
SELECT *
FROM subq
WHERE rank = 1
      AND status = ':campaign-status/running'
      AND created_at >= (NOW() - INTERVAL '1 week');

`rank()` count rows. But it can only count rows inside a PARTITION. A partition is like a group by but acts over logical groups and not over the whole table. So you need to count each rows of the group (grouped by campaign_id) and you want to count the rows by creation time
So for each `campaign_id`, the row `1` is going to be the most recent one (by `created_at`), the row `2` is going to be the next most recent, and so on…
Then you want to query these partitions and only keep the first row (most recent row for this `campaign_id`)
So to recap:
`WITH name as (select…)` creates subqueries (or named queries)
`rank() OVER (PARTITION BY <group key> ORDER BY <sorting key>)` count rows to sort them out in each group and labels them `1`, `2`, `3`
`INTERVAL '1 week'` allows you to express relative time in a easy way.


The time complexity is affected by this line. GROUP BY is `O(n)` in Postgres, so is PARTITION BY. But since there is a BTree index on `campaign_id` I think the GROUP BY is costless here, except if there is a global ORDER BY on some other column on the table, in which case it should be `O(log_f(m))` where `f` is the BTree filling factor and `m` is the number of elements in the biggest group.
 

------------------

/*
":campaign-status/rejected"
":campaign-status/modifying"
":campaign-status/draft"
":campaign-status/validating"
":campaign-status/done"
":campaign-status/running"
*/

/*Total Number*/

SELECT count (*) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.status = ':campaign-status/done'
and c.created_at >= CURRENT_TIMESTAMP - INTERVAL '16888' hour /* time can be changed */

SELECT count (*) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
WHERE cs.status = ':campaign-status/rejected'


select distinct translation_key from 
campaign_status_steps

/*
"project_status_steps.waiting_for_modification"
"project_status_steps.retired"
"project_status_steps.rejected"
"project_status_steps.data_analysis_in_progress"
"project_status_steps.in_progress"
"project_status_steps.finished"
"project_status_steps.draft"
"project_status_steps.waiting_for_validation"
*/



select * from campaign_invitations as ci
inner join campaigns as c
on c.id=ci.campaign_id
inner join projects as p
on p.id=c.project_id
limit 3



select first_name, last_name, ci.created_at,p.tags,p.description from campaign_invitations as ci
inner join campaigns as c
on c.id=ci.campaign_id
inner join projects as p
on p.id=c.project_id
inner join users as u
on u.id=ci.user_id
limit 3


