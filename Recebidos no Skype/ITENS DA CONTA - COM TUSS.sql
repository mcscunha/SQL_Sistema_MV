select a.cd_pro_fat codigo_mv
      ,b.ds_pro_fat desc_codigo_mv
      ,c.cd_tuss    codigo_tuss
      ,c.ds_tuss    desc_codigo_tuss
      ,to_date(to_char(a.dt_lancamento,'dd/mm/rrrr') || to_char(a.hr_lancamento,' hh24:mi:ss'),'dd/mm/rrrr hh24:mi:ss') data_hora_lancamento
      ,a.qt_lancamento  quantidade_lancamento
      ,a.vl_total_conta valor_total
from       dbamv.itreg_fat a
inner join dbamv.pro_fat   b on b.cd_pro_fat = a.cd_pro_fat
left  join dbamv.tuss      c on c.cd_pro_fat = a.cd_pro_fat
                            and (c.cd_convenio is null or c.cd_convenio in (35,36))
                            and c.dt_fim_vigencia is null
where a.cd_reg_fat = 128697
