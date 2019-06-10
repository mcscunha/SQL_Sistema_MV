select
    'PARTICULAR',
    count(reg_amb.vl_total_conta) Qtde,
    sum(reg_amb.vl_total_conta) TotalConta
from dbamv.reg_amb
where 1 = 1
    and nvl(reg_amb.sn_fechada, 'N') = 'N'
    and reg_amb.cd_remessa is not null
    and trunc(dbamv.reg_amb.dt_lancamento) between '01/04/2019' and '30/04/2019' 
union all
select
    'CONVENIOS',
    count(reg_amb.vl_total_conta) Qtde,
    sum(reg_amb.vl_total_conta) TotalConta
from dbamv.reg_amb
where 1 = 1
    and nvl(reg_amb.sn_fechada, 'N') = 'S'
    and reg_amb.cd_remessa is not null
    and trunc(dbamv.reg_amb.dt_lancamento) between '01/04/2019' and '30/04/2019' 
union all
select
    'TOTAL',
    count(reg_amb.vl_total_conta) Qtde,
    sum(reg_amb.vl_total_conta) TotalConta
from dbamv.reg_amb
where 1 = 1
    and reg_amb.cd_remessa is not null
    and trunc(dbamv.reg_amb.dt_lancamento) between '01/04/2019' and '30/04/2019' 
;
