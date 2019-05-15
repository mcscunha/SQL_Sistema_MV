CREATE OR REPLACE FORCE EDITIONABLE VIEW "DBAMV"."VDIC_TEMPO_PACIENTE" (
    "DATA",
    "CD_ATENDIMENTO",
    "HR_AGENDA",
    "HR_ATEND",
    "HR_ATO_ENF",
    "HR_EVOLUCAO",
    "TP_ATO_ENF",
    "HR_ATO_MED",
    "TP_ENF_MED",
    "HR_ALTA",
    "TP_PACIENTE_SALA",
    "TP_TOTAL",
    "NM_PACIENTE",
    "IDADE",
    "NM_PRESTADOR",
    "NM_CONVENIO",
    "TP_CONVENIO",
    "TIPO",
    "SITUACAO",
    "FECHADA",
    "SN_RETORNO",
    "DS_ORI_ATE"
) AS
    SELECT DISTINCT
        dt_atendimento AS data,
        atendime.cd_atendimento,
        MIN(TO_CHAR(vdic_recepcao_agenda.hr_agenda, 'hh24:mi')) AS hr_agenda,
        TO_CHAR(hr_atendimento,'hh24:mi') hr_atend,
        TO_CHAR(hr_enf, 'hh24:mi') hr_ato_enf
    ,
        TO_CHAR(hr_evo_enf, 'hh24:mi') hr_evolucao,
        mod( trunc((MAX(hr_evo_enf - hr_enf)) * 24), 24)
        || ' : '
        || mod(trunc((MAX(hr_evo_enf - hr_enf)) * 1440), 60 ) AS tp_ato_enf,
        TO_CHAR(dh_processo, 'hh24:mi') hr_ato_med,
        mod(trunc((MAX(dh_processo - hr_evo_enf)) * 24), 24)
        || ' : '
        || mod(trunc((MAX(dh_processo - hr_evo_enf)) * 1440), 60) AS tp_enf_med,
        TO_CHAR(hr_alta, 'hh24:mi') hr_alta,
        mod(trunc((MAX(hr_alta - dh_processo)) * 24 ), 24)
        || ' : '
        || mod(trunc((MAX(hr_alta - dh_processo)) * 1440), 60) AS tp_paciente_sala,
        CASE
            WHEN hr_alta IS NOT NULL THEN
                mod(trunc((hr_alta - hr_atendimento) * 24), 24)
                || ' : '
                || mod(trunc((hr_alta - hr_atendimento) * 1440), 60)
            WHEN hr_alta IS NULL THEN
                mod(trunc((SYSDATE - hr_atendimento) * 24), 24)
                || ' : '
                || mod(trunc((SYSDATE - hr_atendimento) * 1440), 60)
        END tp_total,
        paciente.nm_paciente,
        trunc(TO_CHAR(SYSDATE - paciente.dt_nascimento) / 365.25) AS idade,
        nm_prestador,
        nm_convenio,
        tp_convenio,
        -- 15/05/2019 - MuriloCunha - Acrescentado TIPO "PO".
        -- Como "PO" é um ITEM DE AGENDAMENTO, nao dava para utilizar somente a coluna TP_AGENDA,
        -- entao, adicionou-se outra coluna para comparacao de TIPO DE AGENDA
        --
        DECODE(tp_agenda, 'A', 'Ambulatorio', 'E', 'Externo') as TIPO,
        /*
        case
            when ((vdic_recepcao_agenda.tp_agenda in ('A', 'I')) and (cd_item_agendamento in (19, 20, 21, 68, 69, 112, 113, 70, 86))) then 'PO'
            when (vdic_recepcao_agenda.tp_agenda = 'I') then 'EXAME'
            when (vdic_recepcao_agenda.tp_agenda = 'A') then 'AMBULATORIO'
            else 'DESCONHECIDO'
        end as TIPO,
        -- FIM - 15/05/2019 - MuriloCunha
        */
        CASE
            WHEN evo_enf.cd_evo_enf IS NOT NULL
                 AND hr_alta IS NULL THEN
                'Liberado Atendimento'
            WHEN hr_enf IS NOT NULL
                 AND evo_enf.cd_evo_enf IS NULL THEN
                'Em Atendimento Enfermagem'
            WHEN evo_enf.cd_evo_enf IS NOT NULL
                 AND dh_processo IS NOT NULL THEN
                'Em Atendimento Medico'
            WHEN evo_enf.cd_evo_enf IS NULL
                 AND hr_alta IS NULL THEN
                'Aguardando Atendimento'
            WHEN evo_enf.cd_evo_enf IS NULL
                 AND hr_alta IS NOT NULL THEN
                'Liberacao Medica'
            WHEN hr_alta IS NOT NULL THEN
                'Liberacao Medica'
        END situacao,
        sn_fechada,
        atendime.sn_retorno,
        ds_ori_ate
    FROM
        dbamv.atendime
        JOIN dbamv.paciente ON ( atendime.cd_paciente = paciente.cd_paciente )
        JOIN dbamv.prestador ON ( atendime.cd_prestador = prestador.cd_prestador )
        JOIN dbamv.convenio ON ( atendime.cd_convenio = convenio.cd_convenio )
        JOIN tip_situacao ON ( tip_situacao.cd_tip_situacao = atendime.cd_tip_situacao )
        LEFT JOIN evo_enf ON ( evo_enf.cd_atendimento = atendime.cd_atendimento )
        LEFT JOIN vdic_recepcao_agenda ON ( vdic_recepcao_agenda.cd_atendimento = atendime.cd_atendimento )
        LEFT JOIN item_agendamento ON ( item_agendamento.cd_item_agendamento = vdic_recepcao_agenda.cd_item_agendamento )
        LEFT JOIN log_cid ON ( log_cid.cd_atendimento = atendime.cd_atendimento )
        LEFT JOIN itreg_amb ON ( itreg_amb.cd_atendimento = atendime.cd_atendimento )
        LEFT JOIN ori_ate ON ( ori_ate.cd_ori_ate = atendime.cd_ori_ate )
        LEFT JOIN (
            SELECT
                atendime.cd_atendimento,
                atendime.cd_paciente,
                sacr_tempo_processo.dh_processo
            FROM
                atendime
                JOIN sacr_tempo_processo ON ( sacr_tempo_processo.cd_atendimento = atendime.cd_atendimento )
            WHERE
                cd_tipo_tempo_processo = 31
        ) sacr_tempo_processo ON ( sacr_tempo_processo.cd_atendimento = atendime.cd_atendimento )
        LEFT JOIN (
            SELECT
                atendime.cd_atendimento,
                atendime.cd_paciente,
                sacr_tempo_processo.dh_processo AS hr_enf
            FROM
                atendime
                JOIN sacr_tempo_processo ON ( sacr_tempo_processo.cd_atendimento = atendime.cd_atendimento )
            WHERE
                cd_tipo_tempo_processo = 30
        ) sacr_tempo_processo_historico ON ( sacr_tempo_processo_historico.cd_atendimento = atendime.cd_atendimento )
    WHERE
        vdic_recepcao_agenda.cd_it_agenda_pai IS NULL
    GROUP BY
        atendime.cd_atendimento,
        TO_CHAR(dt_atendimento, 'dd/mm/yyyy'),
        TO_CHAR(hr_atendimento, 'hh24:mi'),
        TO_CHAR(hr_enf, 'hh24:mi'),
        paciente.nm_paciente,
        nm_prestador,
        nm_convenio,
        DECODE(tp_agenda, 'A', 'Ambulatorio', 'E', 'Externo'),
        /*
        case
            when ((vdic_recepcao_agenda.tp_agenda in ('A', 'I')) and (cd_item_agendamento in (19, 20, 21, 68, 69, 112, 113, 70, 86))) then 'PO'
            when (vdic_recepcao_agenda.tp_agenda = 'I') then 'EXAME'
            when (vdic_recepcao_agenda.tp_agenda = 'A') then 'AMBULATORIO'
            else 'DESCONHECIDO'
        end,
        */
        tip_situacao.ds_tip_situacao,
        evo_enf.cd_evo_enf,
        trunc(TO_CHAR(SYSDATE - paciente.dt_nascimento) / 365.25),
        TO_CHAR(hr_evo_enf, 'hh24:mi'),
        TO_CHAR(dh_processo, 'hh24:mi'),
        TO_CHAR(hr_alta, 'hh24:mi'),
        CASE
                WHEN evo_enf.cd_evo_enf IS NOT NULL
                     AND hr_alta IS NULL THEN
                    'Liberado Atendimento'
                WHEN hr_enf IS NOT NULL
                     AND evo_enf.cd_evo_enf IS NULL THEN
                    'Em Atendimento Enfermagem'
                WHEN evo_enf.cd_evo_enf IS NOT NULL
                     AND dh_processo IS NOT NULL THEN
                    'Em Atendimento Medico'
                WHEN evo_enf.cd_evo_enf IS NULL
                     AND hr_alta IS NULL THEN
                    'Aguardando Atendimento'
                WHEN evo_enf.cd_evo_enf IS NULL
                     AND hr_alta IS NOT NULL THEN
                    'Liberacao Medica'
                WHEN hr_alta IS NOT NULL THEN
                    'Liberacao Medica'
            END,
        itreg_amb.sn_fechada,
        tp_convenio,
        CASE
                WHEN hr_alta IS NOT NULL THEN
                    mod(trunc((hr_alta - hr_atendimento) * 24), 24)
                    || ' : '
                    || mod(trunc((hr_alta - hr_atendimento) * 1440), 60)
                WHEN hr_alta IS NULL THEN
                    mod(trunc((SYSDATE - hr_atendimento) * 24), 24)
                    || ' : '
                    || mod(trunc((SYSDATE - hr_atendimento) * 1440), 60)
            END,
        dt_atendimento,
        atendime.sn_retorno,
        ds_ori_ate
    ORDER BY
        TO_CHAR(hr_atendimento, 'hh24:mi'),
        cd_atendimento DESC;
