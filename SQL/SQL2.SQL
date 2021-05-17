select first_name, from answers as a
inner join campaigns as c
           on c.id=a.campaign_id
inner join users as u
           on u.id=c.user_id
inner join projects as p
           on p.id=c.project_id
limit 3

/* unanswered scored projects */
select count(a.score),
       p.name as project_name, 
       c.name as campaign_name,
       c.created_at 
from answers as a
     inner join users as u
           on u.id=a.user_id
     inner join campaigns as c
           on c.user_id=a.user_id
     inner join projects as p
           on p.id=c.project_id
where a.body ->>'type' = 'simple-short'
           and a.scored_at is null
           and a.answered_at is not null 
group by p.name,
         c.name,
         c.created_at
limit 3

/* Feedback per campaign */
select count(a.id), 
       c.created_at as date_rec, 
       c.name as campaign,
       p.name as project_name 
from campaigns as c
    inner join answers as a
          on a.campaign_id=c.id
    inner join projects as p
          on p.id=c.project_id
group by campaign,
         project_name,
         date_rec
order by date_rec desc
limit 2


select count(a.id), c.created_at as datum, c.name as "campaign", p.name as "project" from campaigns as c
INNER JOIN answers as a ON c.id = a.campaign_id
INNER JOIN projects as p ON c.project_id = p.id
Group by campaign, datum, project
order by datum DESC
limit 4


/* Feedback volumn this week*/

SELECT count (*) FROM answers as a
WHERE a.created_at >= CURRENT_TIMESTAMP - INTERVAL '168' hour

/* Total Feedback collceted */
SELECT count (*) from answers




