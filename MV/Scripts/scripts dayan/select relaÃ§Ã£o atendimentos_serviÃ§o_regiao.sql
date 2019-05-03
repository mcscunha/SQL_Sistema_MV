select  --DS_ESPEC_SUS as ESPECIALIDADE,
        --DBAMV.ATENDIME.CD_ATENDIMENTO,
        --NM_PACIENTE AS PACIENTE,
        --DBAMV.ATENDIME.CD_PACIENTE AS PRONTU�RIO, 
        --DT_ATENDIMENTO AS INTERNA��O,
        --DT_NASCIMENTO AS NASCIMENTO, 
        DBAMV.CIDADE.NM_CIDADE AS MUNIC�PIO
        , count (dbamv.Paciente.cd_cidade) as qtde 
        --dbamv.atendime.cd_servico,
       -- DBAMV.Servico.DS_SERVICO,
       -- TO_CHAR ( dbamv.atendime.dt_atendimento, 'MM/YYYY') MES_ANO,
        --count (dbamv.atendime.cd_servico) as qtde
        --dbamv.laudo_aih.cd_procedimento as PROCEDIMENTO
   
FROM DBAMV.ATENDIME
     --DBAMV.Servico, 
     ,DBAMV.PACIENTE
     ,DBAMV.CIDADE
     --DBAMV.CIDADE,
     --dbamv.laudo_aih,
     --DBAMV.espec_sus     
WHERE 
     (DBAMV.ATENDIME.CD_PACIENTE = DBAMV.PACIENTE.CD_PACIENTE 
   -- AND DBAMV.ATENDIME.CD_SERVICO = DBAMV.Servico.CD_SERVICO
      AND DBAMV.PACIENTE.CD_CIDADE   = DBAMV.CIDADE.CD_CIDADE
 -- AND DBAMV.ATENDIME.CD_ATENDIMENTO  = DBAMV.LAUDO_AIH.CD_ATENDIMENTO
  --AND dbamv.laudo_aih.cd_espec_sus   = DBAMV.espec_sus.CD_ESPEC_SUS
        ) 
  AND DBAMV.ATENDIME.DT_ATENDIMENTO 
      BETWEEN '01/11/2011' --Data in�cio
      AND '31/01/2012'--Data Fim 
      AND dbamv.atendime.cd_servico = 37 --ORTOPEDIA
       
group by  DBAMV.CIDADE.NM_CIDADE
          ,dbamv.Paciente.cd_cidade
          --dbamv.atendime.cd_servico,
          --DBAMV.Servico.DS_SERVICO--,
          --dbamv.atendime.dt_atendimento

ORDER BY 2 DESC


