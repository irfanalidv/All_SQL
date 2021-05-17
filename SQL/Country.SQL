select * from cities as c
inner join states as s
on s.id=c.state_id
inner join coountries as ca
on ca.id=c.country_id
limit 3

