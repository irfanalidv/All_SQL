https://www.periscopedata.com/blog/use-self-joins-to-calculate-your-retention-churn-and-reactivation-metrics

postgresql

https://stackoverflow.com/questions/16492842/how-to-calculate-retention-month-over-month-using-sql

simple retention model:
http://blog.metricadb.com/post/44824108745/calculating-rolling-cohort-retention-with-sql



who have used our platform

SELECT date_trunc('day',created_at)::date AS date_, first_name, last_name FROM users AS us
WHERE first_name IS NOT NULL
AND us.id IN (

(select m.user_id FROM messages AS m
INNER JOIN  users AS u ON u.id=m.user_id)

UNION

(SELECT a.user_id FROM answers AS a 
INNER JOIN users AS u ON u.id=a.user_id)

)
ORDER BY created_at DESC limit 50


-------
output : 





---

who have not used our platform

SELECT date_trunc('day',created_at)::date AS date_, first_name, last_name FROM users AS us
WHERE first_name IS NOT NULL
AND us.id IN (

(select m.user_id FROM messages AS m
INNER JOIN  users AS u ON u.id=m.user_id)

UNION

(SELECT a.user_id FROM answers AS a 
INNER JOIN users AS u ON u.id=a.user_id)

)
ORDER BY created_at DESC limit 50



---

