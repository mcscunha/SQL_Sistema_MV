-- REPASSE_MEDICO
-- CORRETO
select *
from (
    /**/
    select
        'COM PACOTE',
        nm_paciente,
        (
            select vl_percent_pago
            from (
                select 
                    itreg_repasse.cd_reg_repasse,
                    itreg_repasse.cd_convenio,
                    itreg_repasse.cd_gru_pro,
                    itreg_repasse.cd_gru_fat,
                    itreg_repasse.cd_pro_fat,
                    itreg_repasse.vl_percent_pago
                from itreg_repasse
                where itreg_repasse.cd_reg_repasse = 4
                    and nvl(trunc(itreg_repasse.dt_vigencia), trunc(sysdate)) <= trunc(sysdate)
                    and nvl(itreg_repasse.cd_gru_fat, itreg_amb.cd_gru_fat) = itreg_amb.cd_gru_fat
                    and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                    and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                    and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
                order by cd_pro_fat, cd_convenio asc
            ) v_itreg_repasse
            where rownum = 1
        ) PERCENTUAL,
        (
            (
                (
                    select vl_percent_pago
                    from (
                        select 
                            itreg_repasse.cd_reg_repasse,
                            itreg_repasse.cd_convenio,
                            itreg_repasse.cd_gru_pro,
                            itreg_repasse.cd_gru_fat,
                            itreg_repasse.cd_pro_fat,
                            itreg_repasse.vl_percent_pago
                        from itreg_repasse
                        where itreg_repasse.cd_reg_repasse = 4
                            and nvl(trunc(itreg_repasse.dt_vigencia), trunc(sysdate)) <= trunc(sysdate)
                            and nvl(itreg_repasse.cd_gru_fat, itreg_amb.cd_gru_fat) = itreg_amb.cd_gru_fat
                            and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                            and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                            and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
                        order by cd_pro_fat, cd_convenio asc
                    ) v_itreg_repasse
                    where rownum = 1
                ) *
                itreg_amb.vl_total_conta
            ) / 100 
        ) VL_A_PAGAR,
        itreg_amb.vl_total_conta,
        itreg_amb.cd_reg_amb, 
        itreg_amb.hr_lancamento, 
        itreg_amb.qt_lancamento, 
        itreg_amb.vl_unitario, 
        itreg_amb.cd_atendimento, 
        itreg_amb.cd_prestador,
        itreg_amb.cd_gru_fat, 
        itreg_amb.cd_convenio, 
        itreg_amb.cd_pro_fat, 
        pro_fat.ds_pro_fat,
        itreg_amb.vl_percentual_paciente,
        itreg_amb.sn_pertence_pacote,
        itreg_amb.tp_mvto,
        itreg_amb.cd_conta_pacote
        ,itreg_amb.cd_mvto
    from itreg_amb
    join atendime on
        atendime.cd_atendimento = itreg_amb.cd_atendimento
    join pro_fat on
        pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
    join paciente on
        paciente.cd_paciente = atendime.cd_paciente
    where itreg_amb.cd_atendimento in (
            select distinct s_itreg_amb.cd_atendimento 
            from itreg_amb s_itreg_amb
            where s_itreg_amb.sn_pertence_pacote = 'S'
                and trunc(s_itreg_amb.hr_lancamento) between  '01/07/2019' and '31/07/2019'
        )
        and trunc(itreg_amb.hr_lancamento) between '01/07/2019' and '31/07/2019'
        and (
            atendime.cd_prestador = :ID_PRESTADOR or
            itreg_amb.cd_prestador = :ID_PRESTADOR
        )
        and itreg_amb.sn_pertence_pacote = 'N'
        and itreg_amb.cd_atendimento in (20640,21022,21061,21740,21735,22497)    
       
    -- ---------------------------------
    -- ATENCAO:
    -- ---------------------------------
    --  UNION = UNION + DISTINCT
    --  UNION ALL = somente UNION
    -- ---------------------------------
    union all

    select 
        'SEM PACOTE',
        paciente.nm_paciente,
        (
            select vl_percent_pago
            from (
                select 
                    itreg_repasse.cd_reg_repasse,
                    itreg_repasse.cd_convenio,
                    itreg_repasse.cd_gru_pro,
                    itreg_repasse.cd_gru_fat,
                    itreg_repasse.cd_pro_fat,
                    itreg_repasse.vl_percent_pago
                from itreg_repasse
                where itreg_repasse.cd_reg_repasse = 4
                    and nvl(trunc(itreg_repasse.dt_vigencia), trunc(sysdate)) <= trunc(sysdate)
                    and nvl(itreg_repasse.cd_gru_fat, itreg_amb.cd_gru_fat) = itreg_amb.cd_gru_fat
                    and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                    and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                    and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
                order by cd_pro_fat, cd_convenio asc
            ) v_itreg_repasse
            where rownum = 1
        ) PERCENTUAL,
        (
            (
                (
                    select vl_percent_pago
                    from (
                        select 
                            itreg_repasse.cd_reg_repasse,
                            itreg_repasse.cd_convenio,
                            itreg_repasse.cd_gru_pro,
                            itreg_repasse.cd_gru_fat,
                            itreg_repasse.cd_pro_fat,
                            itreg_repasse.vl_percent_pago
                        from itreg_repasse
                        where itreg_repasse.cd_reg_repasse = 4
                            and nvl(trunc(itreg_repasse.dt_vigencia), trunc(sysdate)) <= trunc(sysdate)
                            and nvl(itreg_repasse.cd_gru_fat, itreg_amb.cd_gru_fat) = itreg_amb.cd_gru_fat
                            and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                            and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                            and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
                        order by cd_pro_fat, cd_convenio asc
                    ) v_itreg_repasse
                    where rownum = 1
                ) *
                (
                    select sum(s2_itreg_amb.vl_total_conta) vl_total_conta
                    from itreg_amb s2_itreg_amb 
                    where s2_itreg_amb.cd_atendimento = itreg_amb.cd_atendimento
                )
            ) / 100 
        ) VL_A_PAGAR,
        (
            select sum(s2_itreg_amb.vl_total_conta) vl_total_conta
            from itreg_amb s2_itreg_amb 
            where s2_itreg_amb.cd_atendimento = itreg_amb.cd_atendimento
        ) vl_total_conta,
        itreg_amb.cd_reg_amb, 
        itreg_amb.hr_lancamento, 
        itreg_amb.qt_lancamento, 
        itreg_amb.vl_unitario, 
        itreg_amb.cd_atendimento, 
        itreg_amb.cd_prestador,
        itreg_amb.cd_gru_fat, 
        itreg_amb.cd_convenio, 
        itreg_amb.cd_pro_fat, 
        pro_fat.ds_pro_fat,
        itreg_amb.vl_percentual_paciente,
        itreg_amb.sn_pertence_pacote,
        itreg_amb.tp_mvto,
        itreg_amb.cd_conta_pacote
        ,itreg_amb.cd_mvto
    from itreg_amb
    join atendime on
        atendime.cd_atendimento = itreg_amb.cd_atendimento
    join pro_fat on
        pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
    join paciente on
        paciente.cd_paciente = atendime.cd_paciente
    where itreg_amb.cd_atendimento not in (
            select distinct s_itreg_amb.cd_atendimento 
            from itreg_amb s_itreg_amb
            where s_itreg_amb.sn_pertence_pacote = 'S'
                and trunc(s_itreg_amb.hr_lancamento) between  '01/07/2019' and '31/07/2019'
        )
        and itreg_amb.cd_gru_fat in (6, 7, 8)
        and trunc(itreg_amb.hr_lancamento) between '01/07/2019' and '31/07/2019'
        and (
            atendime.cd_prestador = :ID_PRESTADOR or
            itreg_amb.cd_prestador = :ID_PRESTADOR
        )
        and itreg_amb.cd_atendimento in (20640,21022,21061,21740,21735,22497)    
        /**/
)
where nvl(vl_a_pagar, 0) > 0
    and nvl(cd_prestador, :ID_PRESTADOR) = :ID_PRESTADOR
order by ds_pro_fat
;


-- =================================================================


select distinct 
    itreg_repasse.vl_percent_pago,
    (itreg_repasse.vl_percent_pago * itreg_amb.vl_unitario * qt_lancamento)/100 VL_A_PAGAR,
    itreg_amb.* 
from itreg_amb
join reg_amb on
    itreg_amb.cd_reg_amb = reg_amb.cd_reg_amb
join conta_pacote on
    conta_pacote.cd_reg_amb = reg_amb.cd_reg_amb
join atendime on
    atendime.cd_atendimento = itreg_amb.cd_atendimento
join itreg_repasse on
    nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
    and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
where reg_amb.dt_lancamento between '01/07/2019' and '31/07/2019'
    and itreg_amb.cd_prestador = 53
    and itreg_amb.sn_pertence_pacote = 'S'
    
union

select distinct 
    -1, 
    (-1 * itreg_amb.vl_unitario * qt_lancamento)/100,
    itreg_amb.* 
from itreg_amb
join reg_amb on
    reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
join atendime on
    atendime.cd_atendimento = itreg_amb.cd_atendimento
where reg_amb.cd_reg_amb not in (
    select distinct 
        itreg_amb.cd_reg_amb
    from itreg_amb
    join reg_amb on
        itreg_amb.cd_reg_amb = reg_amb.cd_reg_amb
    join conta_pacote on
        conta_pacote.cd_reg_amb = reg_amb.cd_reg_amb
    join atendime on
        atendime.cd_atendimento = itreg_amb.cd_atendimento
    join itreg_repasse on
        nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
        and itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat
    where reg_amb.dt_lancamento between '01/07/2019' and '31/07/2019'
        and itreg_amb.cd_prestador = 53
        and itreg_amb.sn_pertence_pacote = 'S'
    )
    and trunc(itreg_amb.hr_lancamento) between '01/07/2019' and '31/07/2019'
    and itreg_amb.cd_prestador = 53
    and itreg_amb.sn_pertence_pacote = 'N'
order by
    2
    
    