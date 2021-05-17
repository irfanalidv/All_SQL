select sum(ins.money) as money from incentives as ins


select sum(ins.money) as money from campaigns as c
INNER JOIN answers as a ON c.id = a.campaign_id
INNER JOIN projects as p ON c.project_id = p.id
inner join incentives as ins
on c.incentive_id=ins.id


/* Incentives from feedback not reviewed */

SELECT sum(ins.money) as sum

FROM   answers a 
       inner join campaigns c 
               ON c.id = a.campaign_id 
       inner join users u 
               ON u.id = c.user_id 
              
       inner join projects p 
               ON c.project_id = p.id 
               inner join incentives as ins
               
on c.incentive_id=ins.id
WHERE  a.BODY ->> 'type' = 'simple-short' 
       AND a.scored_at IS NULL
       AND a.answered_at IS NOT NULL

= 31000

/* status wise */

SELECT sum(ins.money) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
inner join incentives as ins
on c.incentive_id=ins.id
WHERE cs.status = ':campaign-status/draft'

=16154022

SELECT sum(ins.money) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
inner join incentives as ins
on c.incentive_id=ins.id
WHERE cs.status = ':campaign-status/rejected'

=1000


SELECT sum(ins.money) FROM campaigns as c
INNER JOIN campaign_status as cs
ON cs.campaign_id = c.id
inner join incentives as ins
on c.incentive_id=ins.id
WHERE cs.status = ':campaign-status/modifying'

=5100

-----------------------------------

select * from incentives as ins
inner join campaigns as cs on 
ins.id=cs.incentive_id
inner join operations as ops on
ops.campaign_id=cs.id
limit 3

-----------------------------


SELECT ( select sum(ins.money)/100 from incentives as ins
inner join campaigns as cs on 
ins.id=cs.incentive_id
inner join operations as ops on
ops.campaign_id=cs.id
) as Incentive_Money_USD,


( select sum(ops.amount)/100 
from operations as ops
) as Total_Operation_Amount,


( select sum(ops.amount)/100 from incentives as ins
inner join campaigns as cs on 
ins.id=cs.incentive_id
inner join operations as ops on
ops.campaign_id=cs.id
WHERE campaign_id IS NOT NULL
) as Opeartion_amount_Campaign,

(select sum(ops.amount)/100 from operations as ops
WHERE campaign_id IS NULL) as Opeartion_amount_except_Campaign





============================

SELECT ( select sum(ins.money)/100 from incentives as ins
inner join campaigns as cs on 
ins.id=cs.incentive_id
inner join operations as ops on
ops.campaign_id=cs.id
) as Incentive_Money_USD,


( select sum(ops.amount)/100 
from operations as ops
) as Total_Operation_Amount,


( select sum(ops.amount)/100 from incentives as ins
inner join campaigns as cs on 
ins.id=cs.incentive_id
inner join operations as ops on
ops.campaign_id=cs.id
WHERE campaign_id IS NOT NULL
) as Opeartion_amount_Campaign,

(select sum(ops.amount)/100 from operations as ops
WHERE campaign_id IS NULL) as Opeartion_amount_except_Campaign,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='stripe') as Operation_origin_strip,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='referal') as Operation_origin_referal,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='campaign') as Operation_origin_campaign,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='tip') as Operation_origin_tip,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='Manual action') as Operation_origin_Manual_action,

(select sum(ops.amount)/100 from operations as ops 
where ops.origin='manual') as Operation_origin_Manual_action


----------------------


/* added the new data set informational */

select (
select sum(amount)/100 from operations
where amount >0

) as total_amout, 

(

select abs(sum(amount))/100 from operations 
WHERE campaign_id IS NOT NULL
and origin='campaign'
and amount <0

) as spend_on_campaign,

(

select abs(sum(amount))/100 from operations 
WHERE campaign_id IS NULL
and origin='campaign'
and amount <0

) as spend_on_NULL_campaign,

(
select abs(sum(amount))/100 from operations 
WHERE origin='campaign'
and amount <0

) as spend_camp,

(
select abs(sum(amount))/100 from operations
where origin='tip'
and amount <0
) as spend_on_mes_tip,

(
select abs(sum(amount))/100 from operations
where origin='manual'
and amount <0
) as spend_on_client_manual_added_v1,

(
select abs(sum(amount))/100 from operations
where origin='Manual action'
and amount <0
) as spend_on_client_manual_added_v2




------------------


select (

select sum(amount)/100 from operations
where amount >0

) as total_amout_Added, 

(

select abs(sum(amount))/100 from operations 
WHERE campaign_id IS NOT NULL
and origin='campaign'
and amount <0

) as spent_on_campaign,

(

select abs(sum(amount))/100 from operations 
WHERE campaign_id IS NULL
and origin='campaign'
and amount <0

) as spent_on_NULL_campaign,

(

select abs(sum(amount))/100 from operations 
WHERE origin='campaign'
and amount <0

) as Total_spent_camp,

(
select abs(sum(amount))/100 from operations
where origin='tip'
and amount <0
) as spent_on_mes_tip,

(
select abs(sum(amount))/100 from operations
where origin='manual'
and amount <0
) as spent_on_client_manual_added_v1,

(
select abs(sum(amount))/100 from operations
where origin='Manual action'
and amount <0
) as spent_on_client_manual_added_v2,

(
select abs(sum(amount))/100 from operations
where origin='referal'
and amount <0
) as spent_on_referal




