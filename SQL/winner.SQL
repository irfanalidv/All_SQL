select w.rank, ins.money from winners as w
inner join campaigns as c
on w.campaign_id=c.id
INNER JOIN answers as a ON c.id = a.campaign_id
INNER JOIN projects as p ON c.project_id = p.id
inner join incentives as ins
on c.incentive_id=ins.id



