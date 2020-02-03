------------------------------------------------------------------------------    
-- REPASSE_MEDICO
-- CORRETO
------------------------------------------------------------------------------    
select *
from (
 
    select
        case 
            when (
                -- Calculo do percentual a repassar para os medicos
                -- pegando da tabela de regras de repasse
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
                        and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                        and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                        and (
                            itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                            itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                        )
                    order by cd_pro_fat, cd_convenio asc
                ) v_itreg_repasse
                where rownum = 1
            ) = 100 then '100 - COM PACOTE - ANALISAR'
            when (
                -- Calculo do percentual a repassar para os medicos
                -- pegando da tabela de regras de repasse
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
                        and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                        and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                        and (
                            itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                            itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                        )
                    order by cd_pro_fat, cd_convenio asc
                ) v_itreg_repasse
                where rownum = 1
            ) <> 100 then 'COM PACOTE'
        end TIPO,
        nm_paciente,
        (
            -- Calculo do percentual a repassar para os medicos
            -- pegando da tabela de regras de repasse
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
                    and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                    and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                    and (
                        itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                        itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                    )
                order by cd_pro_fat, cd_convenio asc
            ) v_itreg_repasse
            where rownum = 1
        ) PERCENTUAL,
        (
            (
                (
                    -- Calculo do percentual a repassar para os medicos
                    -- pegando da tabela de regras de repasse
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
                            and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                            and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                            and (
                                itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                                itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                            )
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
            join atendime s_atendime on
                s_atendime.cd_atendimento = s_itreg_amb.cd_atendimento
            where s_itreg_amb.sn_pertence_pacote = 'S'
                and trunc(s_atendime.dt_atendimento) between :DINICIAL and :DFINAL
        )
        and trunc(atendime.dt_atendimento) between :DINICIAL and :DFINAL
        and (
            atendime.cd_prestador = :ID_PRESTADOR or
            itreg_amb.cd_atendimento in (
                select distinct s_itreg_amb.cd_atendimento 
                from itreg_amb s_itreg_amb
                join atendime s_atendime on
                    s_atendime.cd_atendimento = s_itreg_amb.cd_atendimento
                where s_itreg_amb.sn_pertence_pacote = 'S'
                    and s_itreg_amb.cd_prestador = :ID_PRESTADOR
                    and trunc(s_atendime.dt_atendimento) between :DINICIAL and :DFINAL
            )
        )
        and itreg_amb.sn_pertence_pacote = 'N'
        --and itreg_amb.cd_atendimento in (23083)
        
    -- ---------------------------------
    -- ATENCAO: UNION => UNION + DISTINCT / UNION ALL = somente UNION
    -- ---------------------------------
    union all
 
    select
        case
            when (
                -- Calculo do percentual a repassar para os medicos
                -- pegando da tabela de regras de repasse
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
                        and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                        and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                        and (
                            itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                            itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                        )
                    order by cd_pro_fat, cd_convenio asc
                ) v_itreg_repasse
                where rownum = 1
            ) = 100 then '100 - SEM PACOTE - ANALISAR'
            when (
                -- Calculo do percentual a repassar para os medicos
                -- pegando da tabela de regras de repasse
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
                        and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                        and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                        and (
                            itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                            itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                        )
                    order by cd_pro_fat, cd_convenio asc
                ) v_itreg_repasse
                where rownum = 1
            ) <> 100 then 'SEM PACOTE'
        end TIPO,
        paciente.nm_paciente,
        (
            -- Calculo do percentual a repassar para os medicos
            -- pegando da tabela de regras de repasse
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
                    and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                    and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                    and (
                        itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                        itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                    )
                order by cd_pro_fat, cd_convenio asc
            ) v_itreg_repasse
            where rownum = 1
        ) PERCENTUAL,
        (
            (
                (
                    -- Calculo do percentual a repassar para os medicos
                    -- pegando da tabela de regras de repasse
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
                            and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                            and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                            and (
                                itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                                itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                            )
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
    where itreg_amb.cd_atendimento not in (
            select distinct s_itreg_amb.cd_atendimento 
            from itreg_amb s_itreg_amb
            join atendime s_atendime on
                s_atendime.cd_atendimento = s_itreg_amb.cd_atendimento
            where s_itreg_amb.sn_pertence_pacote = 'S'
                and trunc(s_atendime.dt_atendimento) between :DINICIAL and :DFINAL
        )
        and itreg_amb.cd_gru_fat in (6, 7, 8)
        and trunc(atendime.dt_atendimento) between :DINICIAL and :DFINAL
        and (
            atendime.cd_prestador = :ID_PRESTADOR or
            itreg_amb.cd_prestador = :ID_PRESTADOR
        )
        and (
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
                    and itreg_repasse.sn_pertence_pacote = itreg_amb.sn_pertence_pacote
                    and nvl(itreg_repasse.cd_convenio, itreg_amb.cd_convenio) = itreg_amb.cd_convenio
                    and (
                        itreg_repasse.cd_pro_fat = itreg_amb.cd_pro_fat or
                        itreg_repasse.cd_gru_fat = itreg_amb.cd_gru_fat
                    )
                order by cd_pro_fat, cd_convenio asc
            ) v_itreg_repasse
            where rownum = 1
        ) < 100
        --and itreg_amb.cd_atendimento in (23083)
)
where nvl(vl_a_pagar, 0) > 0
    and nvl(cd_prestador, :ID_PRESTADOR) = :ID_PRESTADOR
order by nm_paciente, vl_a_pagar
;
