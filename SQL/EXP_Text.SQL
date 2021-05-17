select u.id, body
FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
       inner join projects p 
               ON c.project_id = p.id
               where a.body ->> 'type' = 'simple-short' and
               p.language_id=1 and u.language_id=1

        limit 100


-------------------
select
    body ->> 'type' = 'simple-short'
from answers
limit 3
