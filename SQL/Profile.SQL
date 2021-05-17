/*

accept_projects : does the user wants to receive invitations for campaigns (this is a legacy field, not used anymore)
- public : is my profile visible in search and publicly (not used now but useful)
- one_liner : it's your 1 line title like : `CMO at CompanyXYZ and digital enthusiast`
- _ts : It's for Full Text Search. All fields starting with `_` are low-level fields and the content is most of the time generated. `_ts` is of type `TSVector` and is used to apply Full Text Search Queries on it. You can ignore it.  https://www.postgresql.org/docs/10/datatype-textsearch.html

*/

select user_id,date_trunc('week',born_at)::date as DOB, biography, city_id,  country_id , one_liner, interests, skills, contact from profiles
where biography is not null
AND char_length(biography) > 10 
AND JSONB_ARRAY_LENGTH(skills) > 1

/* updated */

select u.first_name as First_Name,u.last_name as Last_Name,g.name,cs.name, c.name,date_trunc('week',p.born_at)::date as DOB, p.biography, p.one_liner, p.interests::text, p.skills::text, p.contact::text from profiles as p
full outer join cities as c
on c.id=p.city_id
full outer join countries as cs
on cs.id=p.country_id
full outer join users as u
on u.id=p.user_id
full outer join genders as g
on u.gender_id=g.id
where biography is not null
AND char_length(biography) > 10 
AND JSONB_ARRAY_LENGTH(skills) > 1



-------------------

select a.score as Ans_Score,a.body as Ans_Body,u.first_name as First_name,
 u.last_name as Last_Name,g.name as Gender,  
 cs.name as Country_Name
 from answers as a
     inner join users as u
           on u.id=a.user_id
     inner join campaigns as c
           on c.user_id=a.user_id
     inner join projects as p
           on p.id=c.project_id
    inner join profiles as pr
    on u.id=pr.user_id
    inner join cities as ci
    on ci.id=p.city_id
    inner join genders as g
    on u.gender_id=g.id
    inner join countries as cs
    on cs.id=pr.country_id
    limit 3
         
----------------------------------------


select a.score as Ans_Score,a.body as Ans_Body,u.first_name as First_name,
u.last_name as Last_Name,g.name as Gender,  pr.born_at as DOB,
cs.name as Country_Name
from answers as a
    inner join users as u
           on u.id=a.user_id
    inner join campaigns as c
           on c.user_id=a.user_id
    inner join projects as p
           on p.id=c.project_id
    inner join profiles as pr
    on u.id=pr.user_id
    inner join cities as ci
    on ci.id=p.city_id
    inner join genders as g
    on u.gender_id=g.id
    inner join countries as cs
    on cs.id=pr.country_id
    WHERE  a.BODY ->> 'type' = 'simple-short' 
       OR
       a.BODY ->> 'type' = 'paragraph' 
   

--------------------------------


/* campaigns ->> created_at, start_at, end_at */
select a.score as Ans_Score,a.body as Ans_Body,u.first_name as First_name,
 u.last_name as Last_Name,g.name as Gender, date_trunc('week',pr.born_at)::date as DOB,
 cs.name as Country_Name, ci.name as City_Name,c.name as campaign_name, c.description as Camp_Desp,
 css.status as Camp_Status
 from answers as a
     inner join users as u
           on u.id=a.user_id
     inner join campaigns as c
           on c.user_id=a.user_id
     INNER JOIN campaign_status as css
     ON css.campaign_id = c.id
     inner join projects as p
           on p.id=c.project_id
    inner join profiles as pr
    on u.id=pr.user_id
    inner join genders as g
    on u.gender_id=g.id
    inner join countries as cs
    on cs.id=pr.country_id
    inner join cities as ci
    on cs.id=ci.country_id
    WHERE  
    a.BODY ->> 'type' = 'simple-short' 
    OR
    a.BODY ->> 'type' = 'paragraph' 
    AND 
    css.status = ':campaign-status/running'
    or 
    css.status = ':campaign-status/done'

------------------------
/* last */

select a.score as Ans_Score,a.body as Ans_Body,u.first_name as First_name,
 u.last_name as Last_Name,g.name as Gender, date_trunc('week',pr.born_at)::date as DOB,
 cs.name as Country_Name, ci.name as City_Name,c.name as campaign_name, c.description as Camp_Desp, p.name as Proj_Name,
 p.description as Proj_Desc, l.name as Pro_lang, p.tags as Proj_tags,
 p.why as proj_why, p.what as proj_what, p.how as proj_how, p.team as proj_team, p.business as proj_bus, p.innovation as proj_innovation,
 p.challenge as proj_challenges,
 css.status as Camp_Status
 from answers as a
     inner join users as u
           on u.id=a.user_id
     inner join campaigns as c
           on c.user_id=a.user_id
     INNER JOIN campaign_status as css
     ON css.campaign_id = c.id
     inner join projects as p
           on p.id=c.project_id
           
    inner join profiles as pr
    on u.id=pr.user_id
    inner join genders as g
    on u.gender_id=g.id
    inner join countries as cs
    on cs.id=pr.country_id
    inner join cities as ci
    on cs.id=ci.country_id
    inner join languages as l
    on l.id=p.language_id
    WHERE  
    a.BODY ->> 'type' = 'simple-short' 
    OR
    a.BODY ->> 'type' = 'paragraph' 
    AND 
    css.status = ':campaign-status/running'
    or 
    css.status = ':campaign-status/done'

----------------







