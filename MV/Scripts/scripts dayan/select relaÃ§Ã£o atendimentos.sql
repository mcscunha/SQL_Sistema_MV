
select  dbamv.laudo_aih.cd_espec_sus,
        NM_PACIENTE AS PACIENTE,
        DBAMV.ATENDIME.CD_PACIENTE AS PRONTU�RIO, 
        DT_ATENDIMENTO AS INTERNA��O,
        DT_NASCIMENTO AS NASCIMENTO, 
        NM_CIDADE AS MUNIC�PIO, 
        dbamv.laudo_aih.cd_procedimento as PROCEDIMENTO
   
FROM DBAMV.ATENDIME, 
     DBAMV.PACIENTE,
     DBAMV.CIDADE,
     dbamv.laudo_aih
         
WHERE 
     (DBAMV.ATENDIME.CD_PACIENTE = DBAMV.PACIENTE.CD_PACIENTE
  AND DBAMV.PACIENTE.CD_CIDADE   = DBAMV.CIDADE.CD_CIDADE
  AND DBAMV.ATENDIME.CD_ATENDIMENTO  = DBAMV.LAUDO_AIH.CD_ATENDIMENTO
      ) 
  AND DBAMV.ATENDIME.DT_ATENDIMENTO 
      BETWEEN '01/04/2012' --Data In�cio
      AND '17/06/2012' --Data Fim
  and dbamv.laudo_aih.cd_espec_sus is null
  
--ORDER BY NM_CIDADE, 
--      DT_ATENDIMENTO
union

select  DS_ESPEC_SUS as ESPECIALIDADE,
        NM_PACIENTE AS PACIENTE,
        DBAMV.ATENDIME.CD_PACIENTE AS PRONTU�RIO, 
        DT_ATENDIMENTO AS INTERNA��O,
        DT_NASCIMENTO AS NASCIMENTO, 
        NM_CIDADE AS MUNIC�PIO, 
        dbamv.laudo_aih.cd_procedimento as PROCEDIMENTO
   
FROM DBAMV.ATENDIME, 
     DBAMV.PACIENTE,
     DBAMV.CIDADE,
     dbamv.laudo_aih,
     DBAMV.espec_sus     
WHERE 
     (DBAMV.ATENDIME.CD_PACIENTE = DBAMV.PACIENTE.CD_PACIENTE
  AND DBAMV.PACIENTE.CD_CIDADE   = DBAMV.CIDADE.CD_CIDADE
  AND DBAMV.ATENDIME.CD_ATENDIMENTO  = DBAMV.LAUDO_AIH.CD_ATENDIMENTO
  AND dbamv.laudo_aih.cd_espec_sus   = DBAMV.espec_sus.CD_ESPEC_SUS
        ) 
  AND DBAMV.ATENDIME.DT_ATENDIMENTO 
      BETWEEN '01/04/2012' --Data in�cio
      AND '17/06/2012'--Data Fim 

--ORDER BY NM_CIDADE, 
--      DT_ATENDIMENTO,
--      DS_ESPEC_SUS 

