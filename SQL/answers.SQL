select distinct body->>'type' from answers
limit 3

/*
"paragraph"
"yes-no"
"simple-short"

*/


/* unanswered scored projects */

select count(a.score),
       p.name as project_name, 
       c.name as campaign_name,
       date_trunc('week',c.created_at)::date as date
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


-------------------------

/* answers not reviewed */
SELECT count(a.score)::text AS feedback, 
       p.name::text , 
       c.name::text, 
       date_trunc('day', c.created_at)::date as date
FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
       inner join projects p 
               ON c.project_id = p.id 
WHERE  a.BODY ->> 'type' = 'simple-short' 
       OR
       a.BODY ->> 'type' = 'paragraph' 
       AND a.scored_at IS NULL
       AND a.answered_at IS NOT NULL
       AND a.answered_at >= date_trunc('day', now() - interval '2 month')
GROUP  BY p.name, 
          a.score, 
          c.name, 
          c.created_at 
ORDER  BY feedback DESC;


---------------------------

SELECT count(a.score)::text AS feedback, 
       p.name::text , 
       c.name::text, 
       date_trunc('week', a.answered_at)::date as date
FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
       inner join projects p 
               ON c.project_id = p.id 
WHERE  a.BODY ->> 'type' = 'simple-short' 
       OR
       a.BODY ->> 'type' = 'paragraph' 
       AND a.scored_at IS NULL
       AND a.answered_at IS NOT NULL
       AND a.answered_at >= date_trunc('week', now() - interval '1 week')
       AND 
GROUP  BY p.name, 
          a.score, 
          c.name, 
          c.created_at, 
          a.answered_at
ORDER  BY a.answered_at DESC

-------------------

WITH Not_Reviewed_Camp AS (

SELECT c.id::text,
       p.name,
       c.name,
       count(a.score)::text AS feedback
FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
       inner join projects p 
               ON c.project_id = p.id 
WHERE  a.BODY ->> 'type' = 'simple-short' 
       OR
       a.BODY ->> 'type' = 'paragraph' 
       AND a.scored_at IS NULL
       AND a.answered_at IS NOT NULL
       AND a.answered_at >= date_trunc('week', now() - interval '1 week')
       
GROUP  BY c.id,
          p.name,
          c.name
)


