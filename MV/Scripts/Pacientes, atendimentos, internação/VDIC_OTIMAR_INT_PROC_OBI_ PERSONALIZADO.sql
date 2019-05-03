create or replace view VDIC_OTIMAR_INT_PROC_OBI as
select a.cd_atendimento,a.dt_alta_medica,a.tp_atendimento,a.sn_obito,a.cd_procedimento_alta,
b.ds_procedimento

from atendime a,
procedimento_sus b

where a.cd_procedimento = b.cd_procedimento
