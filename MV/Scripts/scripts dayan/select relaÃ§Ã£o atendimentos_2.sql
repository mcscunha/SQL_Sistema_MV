select  count(*)--, cd_atendimento
        /*DS_ESPEC_SUS as ESPECIALIDADE,
        NM_PACIENTE AS PACIENTE,
        DBAMV.ATENDIME.CD_PACIENTE AS PRONTUÁRIO, 
        DT_ATENDIMENTO AS INTERNAÇÃO,
        DT_NASCIMENTO AS NASCIMENTO, 
        NM_CIDADE AS MUNICÍPIO, 
        dbamv.laudo_aih.cd_procedimento as PROCEDIMENTO
        */
   
FROM DBAMV.ATENDIME, 
     DBAMV.PACIENTE,
     DBAMV.CIDADE,
     DBAMV.SERVICO
     --dbamv.laudo_aih,
    -- DBAMV.espec_sus     
WHERE 
     (DBAMV.ATENDIME.CD_PACIENTE = DBAMV.PACIENTE.CD_PACIENTE
  AND DBAMV.PACIENTE.CD_CIDADE   = DBAMV.CIDADE.CD_CIDADE
  AND DBAMV.ATENDIME.CD_SERVICO  = DBAMV.SERVICO.CD_SERVICO
  --AND DBAMV.ATENDIME.CD_ATENDIMENTO  = DBAMV.LAUDO_AIH.CD_ATENDIMENTO
  --AND dbamv.laudo_aih.cd_espec_sus   = DBAMV.espec_sus.CD_ESPEC_SUS
        ) 
  AND DBAMV.ATENDIME.DT_ATENDIMENTO 
      BETWEEN '01/07/2011' --Data início
      AND     '31/07/2011' --Data Fim
      --and DBAMV.ATENDIME.CD_SERVICO = 37 --ortopedia
      --AND DBAMV.ATENDIME.CD_TIP_MAR <> 2 --1=primeira consulta 2=retorno
      AND DBAMV.ATENDIME.CD_CONVENIO = 1 --1=internacao 2=ambulat
      --AND DBAMV.ATENDIME.CD_TIPO_INTERNACAO = 1
      
  --AND DBAMV.espec_sus.DS_ESPEC_SUS = 
--  group by cd_atendimento

--ORDER BY 3
      --NM_CIDADE, 
      --DT_ATENDIMENTO,
      --DS_ESPEC_SUS 

