/*  \d+ users  */


/* New Users / month - Date_trunc*/
Select date_trunc('week',created_at)::date as week,
count(*) from users
group by week
order by week

WITH subq AS ((SELECT us.id as user_id,m.id as activity,
                      us.first_name as first_name, us.last_name as last_name, m.created_at,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.id, us.first_name, us.last_name, m.created_at,m.id
                      ORDER BY m.id, m.created_at DESC)
                UNION
                (
                 SELECT us.id as user_id,a.id as activity,
                      us.first_name as first_name, us.last_name as last_name, a.created_at,
                      rank() OVER (PARTITION BY a.id ORDER BY a.created_at DESC) AS rank
                      FROM answers as a
                      INNER JOIN users us ON a.user_id = us.id
                      group by us.id, us.first_name, us.last_name, a.created_at,a.id
                      ORDER BY a.id, a.created_at DESC
                )  
                      )

SELECT first_name, last_name
FROM subq
WHERE rank = 1
group by user_id, first_name, last_name
limit 50

---------------------------------------------------------------------
/* order by user created */




WITH subq AS ((SELECT us.id as user_id,us.created_at as activity,
                      us.first_name as first_name, us.last_name as last_name,
                      rank() OVER (PARTITION BY us.id ORDER BY us.created_at DESC) AS rank
                      FROM users as us
                      INNER JOIN messages as m ON m.user_id = us.id
                      group by us.id, us.first_name, us.last_name
                      ORDER BY us.created_at DESC)
                UNION
                (
                 SELECT us.id as user_id,us.created_at as activity,
                      us.first_name as first_name, us.last_name as last_name,
                      rank() OVER (PARTITION BY us.id ORDER BY us.created_at DESC) AS rank
                      FROM users as us
                      INNER JOIN answers as a ON a.user_id = us.id
                      group by us.id, us.first_name, us.last_name
                      ORDER BY us.created_at DESC
                      
                )  
                      )

SELECT first_name, last_name
FROM subq
WHERE rank = 1
group by user_id, first_name, last_name
limit 50


----------------------
/* possible users transaction */


WITH subq AS ((SELECT us.id as user_id, us.created_at as date1,
                      us.first_name as first_name, us.last_name as last_name,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.id, us.first_name, us.last_name,m.created_at,m.id
                      ORDER BY date1 DESC)
                UNION
                (
                 SELECT us.id as user_id, us.created_at as date1,
                      us.first_name as first_name, us.last_name as last_name,
                      rank() OVER (PARTITION BY a.id ORDER BY a.created_at DESC) AS rank
                      FROM answers as a
                      INNER JOIN users us ON a.user_id = us.id
                      group by us.id, us.first_name, us.last_name,a.created_at, a.id
                      ORDER BY date1 DESC
                )  
                      )

SELECT user_id, date_trunc('day',date1)::date as date, first_name, last_name
FROM subq
WHERE rank = 1
AND first_name is not null
group by date1, user_id, first_name, last_name
ORDER BY date1 DESC
limit 50
------------------------------
/*try one more*/

select us.id as user_id1, date_trunc('day',us.created_at)::date as date1 ,us.first_name as first_name, us.last_name as last_name
from users as us
INNER JOIN messages m ON m.user_id = us.id
INNER JOIN answers a ON a.user_id = us.id
WHERE first_name is not null
group by date1, user_id1, first_name, last_name
ORDER BY date1 DESC
limit 50

----------------

SELECT date_trunc('day',created_at)::date AS date_, first_name, last_name FROM users AS us
WHERE first_name IS NOT NULL
AND us.id IN (

(select m.user_id FROM messages AS m
INNER JOIN  users AS u ON u.id=m.user_id)

UNION

(SELECT a.user_id FROM answers AS a 
INNER JOIN users AS u ON u.id=a.user_id)

)
ORDER BY created_at DESC limit 50


-------------------------------

/* Users from  one month who have not used our platform */


SELECT date_trunc('day',created_at)::date AS date_, first_name, last_name FROM users AS us
WHERE first_name IS NOT NULL
AND us.id NOT IN (

(select m.user_id FROM messages AS m
INNER JOIN  users AS u ON u.id=m.user_id)

UNION

(SELECT a.user_id FROM answers AS a 
INNER JOIN users AS u ON u.id=a.user_id)

)

AND us.created_at >= (NOW() - INTERVAL '1 month')

ORDER BY created_at DESC limit 50




"Total Newest Users without any activity"





======
/* users retention */
SELECT
count(distinct users.id) as created_account,
count(distinct messages.user_id) as messages_done
count(distinct answers.user_id) as answers_done
FROM users
LEFT JOIN messages
ON users.id = messages.user_id
AND messages.created_at >= date_trunc('day', now() - interval '1 month')
AND messages.created_at < date_trunc('day', now())
LEFT JOIN answers
ON users.id = answers.user_id
AND answers.created_at >= date_trunc('day', now() - interval '1 month')
AND answers.created_at < date_trunc('day', now())
WHERE users.created_at >= date_trunc('day', now() - interval '1 month')
AND users.created_at < date_trunc('day', now() );

-----------------------------

/* Loyal Users from past 4 months with us */


WITH Month4 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '4 month')
               AND messages.created_at < date_trunc('day', now() - interval '3 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '4 month')
                 AND answers.created_at < date_trunc('day', now() - interval '3 month')
                )  
                
                ),

Month3 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '3 month')
               AND messages.created_at < date_trunc('day', now() - interval '2 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '3 month')
                 AND answers.created_at < date_trunc('day', now() - interval '2 month')
                )  
                
                ),


Month2 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '2 month')
               AND messages.created_at < date_trunc('day', now() - interval '1 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '2 month')
                 AND answers.created_at < date_trunc('day', now() - interval '1 month')
                )  
                
                ),


Month1 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '1 month')
               AND messages.created_at < date_trunc('day', now() )
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '1 month')
                 AND answers.created_at < date_trunc('day', now() )
                )  
                
                )
                
SELECT first_name, last_name FROM users as u

where u.id IN
(

select Month4.users_ID from Month4
LEFT JOIN Month3
ON Month3.users_ID = Month4.users_ID
LEFT JOIN Month2
ON Month2.users_ID = Month4.users_ID
LEFT JOIN Month1
ON Month1.users_ID = Month4.users_ID

)

order by u.created_at
--------------------------
/* INNER JOIN works for users who had been with us for the entire month */

WITH Month4 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '4 month')
               AND messages.created_at < date_trunc('day', now() - interval '3 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '4 month')
                 AND answers.created_at < date_trunc('day', now() - interval '3 month')
                )  
                
                ),

Month3 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '3 month')
               AND messages.created_at < date_trunc('day', now() - interval '2 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '3 month')
                 AND answers.created_at < date_trunc('day', now() - interval '2 month')
                )  
                
                ),


Month2 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '2 month')
               AND messages.created_at < date_trunc('day', now() - interval '1 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '2 month')
                 AND answers.created_at < date_trunc('day', now() - interval '1 month')
                )  
                
                ),


Month1 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '1 month')
               AND messages.created_at < date_trunc('day', now() )
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '1 month')
                 AND answers.created_at < date_trunc('day', now() )
                )  
                
                )
                
SELECT first_name, last_name FROM users as u

where u.id IN

(

select Month4.users_ID from Month4
INNER JOIN Month3
ON Month3.users_ID = Month4.users_ID
INNER JOIN Month2
ON Month2.users_ID = Month4.users_ID
INNER JOIN Month1
ON Month1.users_ID = Month4.users_ID

)

group by u.id, u.first_name,u.last_name

-------------------------------------------

/* List of users who have reactivated after 4 months */

WITH Month4 AS (

               (
               
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '4 month')
               AND messages.created_at < date_trunc('day', now() - interval '3 month')
               
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '4 month')
                 AND answers.created_at < date_trunc('day', now() - interval '3 month')
                )  
                
                ),

Month3 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '3 month')
               AND messages.created_at < date_trunc('day', now() - interval '2 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '3 month')
                 AND answers.created_at < date_trunc('day', now() - interval '2 month')
                )  
                
                ),


Month2 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '2 month')
               AND messages.created_at < date_trunc('day', now() - interval '1 month')
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '2 month')
                 AND answers.created_at < date_trunc('day', now() - interval '1 month')
                )  
                
                ),


Month1 AS (

               (
               SELECT distinct user_id as users_ID
               FROM messages  WHERE 
               messages.created_at >= date_trunc('day', now() - interval '1 month')
               AND messages.created_at < date_trunc('day', now() )
               )  
              
               UNION
               
                (
                 SELECT distinct user_id as users_ID 
                 FROM answers where 
                 answers.created_at >= date_trunc('day', now() - interval '1 month')
                 AND answers.created_at < date_trunc('day', now() )
                )  
                
                )
                
SELECT distinct id as ID, first_name, last_name FROM users as u

where u.id IN

(

select Month4.users_ID from Month4
where Month4.users_ID

NOT IN 

(

select Month3.users_ID from Month3
JOIN Month2
ON Month2.users_ID = Month3.users_ID

)



AND Month4.users_ID IN

(

select users_ID from Month1

)

)

group by u.id, u.first_name,u.last_name

--------------------------------------------


/* users sign up weekly */

Select date_trunc('week',created_at)::date as week,
count(*) from users
group by week
order by week



/* users messages/answers weekly created at app.brainsfeed.com*/

WITH Sign_Ups AS (

		SELECT date_trunc('week',created_at)::date as sign_up_week,
		count(DISTINCT id ) as Sign_ups from users
                WHERE 
                users.created_at >= date_trunc('day', now() - interval '4 month')
                AND 
                users.created_at <= date_trunc('hour', now() )
		GROUP BY sign_up_week
		ORDER BY sign_up_week
 
                ),

Messages AS (

		SELECT date_trunc('week',created_at)::date as Mes_cre_week,
		count(DISTINCT id ) as Messages from messages
                WHERE 
                messages.created_at >= date_trunc('day', now() - interval '4 month')
                AND 
                messages.created_at <= date_trunc('hour', now() )
		GROUP BY Mes_cre_week
		ORDER BY Mes_cre_week
 
                ),

Answers AS (

		SELECT date_trunc('week',created_at)::date as Ans_Cre_week,
		count(DISTINCT id ) as Answers from answers
                WHERE 
                answers.created_at >= date_trunc('day', now() - interval '4 month')
                AND 
                answers.created_at <= date_trunc('hour', now() )
		GROUP BY Ans_Cre_week
		ORDER BY Ans_Cre_week
 
                ),

                
Projects AS (

		SELECT date_trunc('week',created_at)::date as Pre_Cre_week,
		count(DISTINCT id ) as Projects from projects
                WHERE 
                projects.created_at >= date_trunc('day', now() - interval '4 month')
                AND 
                projects.created_at <= date_trunc('hour', now() )
		GROUP BY Pre_Cre_week
		ORDER BY Pre_Cre_week
 
                )

SELECT * FROM Sign_Ups
LEFT JOIN Messages ON
Messages.Mes_cre_week=Sign_Ups.sign_up_week
LEFT JOIN Answers ON 
Answers.Ans_Cre_week=Sign_Ups.sign_up_week
LEFT JOIN Projects ON
Projects.Pre_Cre_week=Sign_Ups.sign_up_week
ORDER BY Sign_Ups.sign_up_week



--------------------------------------
/* Users geo activity */

WITH subq AS ((SELECT us.id as user_id,m.id as activity,
                      us.first_name as first_name, us.last_name as last_name, m.created_at,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.id, us.first_name, us.last_name, m.created_at,m.id
                      ORDER BY m.id, m.created_at DESC)
                UNION
                (
                 SELECT us.id as user_id,a.id as activity,
                      us.first_name as first_name, us.last_name as last_name, a.created_at,
                      rank() OVER (PARTITION BY a.id ORDER BY a.created_at DESC) AS rank
                      FROM answers as a
                      INNER JOIN users us ON a.user_id = us.id
                      group by us.id, us.first_name, us.last_name, a.created_at,a.id
                      ORDER BY a.id, a.created_at DESC
                )  
                      )
                      
SELECT subq.user_id, cs.iso2 as country_name, 
count(cs.iso2) as number_of_users 
FROM subq
inner join profiles as pf on
subq.user_id=pf.user_id
inner join countries as cs on 
pf.country_id=cs.id
WHERE rank = 1
      AND created_at >= (NOW() - INTERVAL '1 month')      
group by subq.user_id, cs.iso2;

/*
select cs.iso2 as name, count(cs.iso2) as number_of_users from countries as cs
inner join profiles as pf on
pf.country_id=cs.id
inner join users as us on 
us.id=pf.user_id
group by cs.iso2
limit 3

*/
-------------------------------------------------

 /* country wise users interaction here we can see that the overall */



WITH subq AS ((SELECT distinct us.id as user_id,m.id as activity,
                      us.first_name as first_name, us.last_name as last_name, m.created_at,
                      rank() OVER (PARTITION BY m.id ORDER BY m.created_at DESC) AS rank
                      FROM messages as m
                      INNER JOIN users us ON m.user_id = us.id
                      group by us.id, us.first_name, us.last_name, m.created_at,m.id
                      ORDER BY m.id, m.created_at DESC)
                UNION
                (
                 SELECT distinct us.id as user_id,a.id as activity,
                      us.first_name as first_name, us.last_name as last_name, a.created_at,
                      rank() OVER (PARTITION BY a.id ORDER BY a.created_at DESC) AS rank
                      FROM answers as a
                      INNER JOIN users us ON a.user_id = us.id
                      group by us.id, us.first_name, us.last_name, a.created_at,a.id
                      ORDER BY a.id, a.created_at DESC
                )  
                      )
                      
SELECT cs.name,count(cs.name) as c_name
from subq
inner join profiles as pf on
subq.user_id=pf.user_id
inner join countries as cs on
pf.country_id=cs.id
WHERE rank = 1
      AND created_at >= (NOW() - INTERVAL '1 month')      
group by subq.user_id, cs.id;

/*

select cs.iso2 as name, count(cs.iso2) as number_of_users from countries as cs
inner join profiles as pf on
pf.country_id=cs.id
inner join users as us on 
us.id=pf.user_id
group by cs.iso2
limit 3

*/
