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
            DT_ATENDIMENTO AS DATA,
            ATENDIME.CD_ATENDIMENTO,
            MIN(TO_CHAR(VDIC_RECEPCAO_AGENDA.HR_AGENDA, 'hh24:mi')) AS HR_AGENDA,
            TO_CHAR(HR_ATENDIMENTO,'hh24:mi') HR_ATEND,
            TO_CHAR(HR_ENF, 'hh24:mi') HR_ATO_ENF,
            TO_CHAR(HR_EVO_ENF, 'hh24:mi') HR_EVOLUCAO,
            MOD( TRUNC((MAX(HR_EVO_ENF - HR_ENF)) * 24), 24)
            || ' : '
            || MOD(TRUNC((MAX(HR_EVO_ENF - HR_ENF)) * 1440), 60 ) AS TP_ATO_ENF,
            TO_CHAR(DH_PROCESSO, 'hh24:mi') HR_ATO_MED,
            MOD(TRUNC((MAX(DH_PROCESSO - HR_EVO_ENF)) * 24), 24)
            || ' : '
            || MOD(TRUNC((MAX(DH_PROCESSO - HR_EVO_ENF)) * 1440), 60) AS TP_ENF_MED,
            TO_CHAR(HR_ALTA, 'hh24:mi') HR_ALTA,
            MOD(TRUNC((MAX(HR_ALTA - DH_PROCESSO)) * 24 ), 24)
            || ' : '
            || MOD(TRUNC((MAX(HR_ALTA - DH_PROCESSO)) * 1440), 60) AS TP_PACIENTE_SALA,
            CASE
                WHEN HR_ALTA IS NOT NULL THEN
                    MOD(TRUNC((HR_ALTA - HR_ATENDIMENTO) * 24), 24)
                    || ' : '
                    || MOD(TRUNC((HR_ALTA - HR_ATENDIMENTO) * 1440), 60)
                WHEN HR_ALTA IS NULL THEN
                    MOD(TRUNC((SYSDATE - HR_ATENDIMENTO) * 24), 24)
                    || ' : '
                    || MOD(TRUNC((SYSDATE - HR_ATENDIMENTO) * 1440), 60)
            END TP_TOTAL,
            PACIENTE.NM_PACIENTE,
            TRUNC(TO_CHAR(SYSDATE - PACIENTE.DT_NASCIMENTO) / 365.25) AS IDADE,
            NM_PRESTADOR,
            NM_CONVENIO,
            TP_CONVENIO,
            /* 15/05/2019 - MURILOCUNHA
                   ACRESCENTADO TIPO "PO". COMO "PO" É UM ITEM DE AGENDAMENTO, 
                   NAO DAVA PARA UTILIZAR SOMENTE A COLUNA TP_AGENDA, ENTAO,
                   ADICIONOU-SE OUTRA COLUNA PARA COMPARACAO DE TIPO DE AGENDA
                   
                   DECODE(TP_AGENDA, 'A', 'Ambulatorio', 'E', 'Externo') AS TIPO,
            */
            CASE
                WHEN (
                       (VDIC_RECEPCAO_AGENDA.TP_AGENDA IN ('A', 'I')) AND 
                       (VDIC_RECEPCAO_AGENDA.CD_ITEM_AGENDAMENTO IN (19, 20, 21, 68, 69, 112, 113, 70, 86)) AND
                       (VDIC_RECEPCAO_AGENDA.HR_AGENDA IS NOT NULL)
                     ) THEN 'PO'
                WHEN (VDIC_RECEPCAO_AGENDA.TP_AGENDA = 'I') THEN 'EXAME'
                WHEN (VDIC_RECEPCAO_AGENDA.TP_AGENDA = 'A') THEN 'AMBULATORIO'
            END AS TIPO,
            -- FIM - 15/05/2019 - MURILOCUNHA
            CASE
                WHEN EVO_ENF.CD_EVO_ENF IS NOT NULL
                     AND HR_ALTA IS NULL THEN
                    'Liberado Atendimento'
                WHEN HR_ENF IS NOT NULL
                     AND EVO_ENF.CD_EVO_ENF IS NULL THEN
                    'Em Atendimento Enfermagem'
                WHEN EVO_ENF.CD_EVO_ENF IS NOT NULL
                     AND DH_PROCESSO IS NOT NULL THEN
                    'Em Atendimento Medico'
                WHEN EVO_ENF.CD_EVO_ENF IS NULL
                     AND HR_ALTA IS NULL THEN
                    'Aguardando Atendimento'
                WHEN EVO_ENF.CD_EVO_ENF IS NULL
                     AND HR_ALTA IS NOT NULL THEN
                    'Liberacao Medica'
                WHEN HR_ALTA IS NOT NULL THEN
                    'Liberacao Medica'
            END SITUACAO,
            SN_FECHADA,
            ATENDIME.SN_RETORNO,
            DS_ORI_ATE
        FROM
            DBAMV.ATENDIME
            JOIN DBAMV.PACIENTE ON ( ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE )
            JOIN DBAMV.PRESTADOR ON ( ATENDIME.CD_PRESTADOR = PRESTADOR.CD_PRESTADOR )
            JOIN DBAMV.CONVENIO ON ( ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO )
            JOIN TIP_SITUACAO ON ( TIP_SITUACAO.CD_TIP_SITUACAO = ATENDIME.CD_TIP_SITUACAO )
            LEFT JOIN EVO_ENF ON ( EVO_ENF.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
            LEFT JOIN VDIC_RECEPCAO_AGENDA ON ( VDIC_RECEPCAO_AGENDA.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
            LEFT JOIN ITEM_AGENDAMENTO ON ( ITEM_AGENDAMENTO.CD_ITEM_AGENDAMENTO = VDIC_RECEPCAO_AGENDA.CD_ITEM_AGENDAMENTO )
            LEFT JOIN LOG_CID ON ( LOG_CID.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
            LEFT JOIN ITREG_AMB ON ( ITREG_AMB.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
            LEFT JOIN ORI_ATE ON ( ORI_ATE.CD_ORI_ATE = ATENDIME.CD_ORI_ATE )
            LEFT JOIN (
                SELECT
                    ATENDIME.CD_ATENDIMENTO,
                    ATENDIME.CD_PACIENTE,
                    SACR_TEMPO_PROCESSO.DH_PROCESSO
                FROM
                    ATENDIME
                    JOIN SACR_TEMPO_PROCESSO ON ( SACR_TEMPO_PROCESSO.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
                WHERE
                    CD_TIPO_TEMPO_PROCESSO = 31
            ) SACR_TEMPO_PROCESSO ON ( SACR_TEMPO_PROCESSO.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
            LEFT JOIN (
                SELECT
                    ATENDIME.CD_ATENDIMENTO,
                    ATENDIME.CD_PACIENTE,
                    SACR_TEMPO_PROCESSO.DH_PROCESSO AS HR_ENF
                FROM
                    ATENDIME
                    JOIN SACR_TEMPO_PROCESSO ON ( SACR_TEMPO_PROCESSO.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
                WHERE
                    CD_TIPO_TEMPO_PROCESSO = 30
            ) SACR_TEMPO_PROCESSO_HISTORICO ON ( SACR_TEMPO_PROCESSO_HISTORICO.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO )
        WHERE
            VDIC_RECEPCAO_AGENDA.CD_IT_AGENDA_PAI IS NULL

            --DESCOMENTAR APENAS PARA TESTES DE ALTERACAO NESTE SCRIPT
            --AND DT_ATENDIMENTO = '16/may/2019'
            --AND ATENDIME.CD_ATENDIMENTO = 15364

        GROUP BY
            TO_CHAR(DT_ATENDIMENTO, 'dd/mm/yyyy'),
            ATENDIME.CD_ATENDIMENTO,
            TO_CHAR(HR_ATENDIMENTO, 'hh24:mi'),
            TO_CHAR(HR_ENF, 'hh24:mi'),
            PACIENTE.NM_PACIENTE,
            NM_PRESTADOR,
            NM_CONVENIO,
            --DECODE(TP_AGENDA, 'A', 'Ambulatorio', 'E', 'Externo'),
            CASE
                WHEN (
                       (VDIC_RECEPCAO_AGENDA.TP_AGENDA IN ('A', 'I')) AND 
                       (VDIC_RECEPCAO_AGENDA.CD_ITEM_AGENDAMENTO IN (19, 20, 21, 68, 69, 112, 113, 70, 86)) AND
                       (VDIC_RECEPCAO_AGENDA.HR_AGENDA IS NOT NULL)
                     ) THEN 'PO'
                WHEN (VDIC_RECEPCAO_AGENDA.TP_AGENDA = 'I') THEN 'EXAME'
                WHEN (VDIC_RECEPCAO_AGENDA.TP_AGENDA = 'A') THEN 'AMBULATORIO'
            END,
            TIP_SITUACAO.DS_TIP_SITUACAO,
            EVO_ENF.CD_EVO_ENF,
            TRUNC(TO_CHAR(SYSDATE - PACIENTE.DT_NASCIMENTO) / 365.25),
            TO_CHAR(HR_EVO_ENF, 'hh24:mi'),
            TO_CHAR(DH_PROCESSO, 'hh24:mi'),
            TO_CHAR(HR_ALTA, 'hh24:mi'),
            CASE
                    WHEN EVO_ENF.CD_EVO_ENF IS NOT NULL
                         AND HR_ALTA IS NULL THEN
                        'Liberado Atendimento'
                    WHEN HR_ENF IS NOT NULL
                         AND EVO_ENF.CD_EVO_ENF IS NULL THEN
                        'Em Atendimento Enfermagem'
                    WHEN EVO_ENF.CD_EVO_ENF IS NOT NULL
                         AND DH_PROCESSO IS NOT NULL THEN
                        'Em Atendimento Medico'
                    WHEN EVO_ENF.CD_EVO_ENF IS NULL
                         AND HR_ALTA IS NULL THEN
                        'Aguardando Atendimento'
                    WHEN EVO_ENF.CD_EVO_ENF IS NULL
                         AND HR_ALTA IS NOT NULL THEN
                        'Liberacao Medica'
                    WHEN HR_ALTA IS NOT NULL THEN
                        'Liberacao Medica'
                END,
            ITREG_AMB.SN_FECHADA,
            TP_CONVENIO,
            CASE
                    WHEN HR_ALTA IS NOT NULL THEN
                        MOD(TRUNC((HR_ALTA - HR_ATENDIMENTO) * 24), 24)
                        || ' : '
                        || MOD(TRUNC((HR_ALTA - HR_ATENDIMENTO) * 1440), 60)
                    WHEN HR_ALTA IS NULL THEN
                        MOD(TRUNC((SYSDATE - HR_ATENDIMENTO) * 24), 24)
                        || ' : '
                        || MOD(TRUNC((SYSDATE - HR_ATENDIMENTO) * 1440), 60)
                END,
            DT_ATENDIMENTO,
            ATENDIME.SN_RETORNO,
            DS_ORI_ATE
        ORDER BY
            TO_CHAR(HR_ATENDIMENTO, 'hh24:mi'),
            ATENDIME.CD_ATENDIMENTO DESC;

