select -- *
--/*
      DBAMV.SOLIC_SANGUE.CD_SOLIC_SANGUE,
      DBAMV.SOLIC_SANGUE.DT_SOLIC_SANGUE,
      DBAMV.SOLIC_SANGUE.HR_SOLIC_SANGUE,
      DBAMV.SOLIC_SANGUE.NM_USUARIO AS MEDICO_SOLICIT,
      DBAMV.SOLIC_SANGUE.CD_ATENDIMENTO,
      DBAMV.SETOR.NM_SETOR,
      dbamv.it_solic_sangue.sn_realizado,
      dbamv.sangue_derivados.ds_sangue_derivados,
      dbamv.it_solic_sangue.qt_solicitada,
      dbamv.it_solic_sangue.qt_realizado,
      dbamv.it_solic_sangue.dt_realizado,
      dbamv.it_solic_sangue.hr_realizado,
      dbamv.it_solic_sangue.nm_usuario AS USUARIO
 -- */        
FROM DBAMV.SOLIC_SANGUE, dbamv.it_solic_sangue, dbamv.sangue_derivados, dbamv.setor
where 
    DBAMV.SOLIC_SANGUE.CD_SOLIC_SANGUE = dbamv.it_solic_sangue.cd_solic_sangue
    and DBAMV.SOLIC_SANGUE.CD_SETOR = dbamv.setor.cd_setor
    and DBAMV.it_solic_sangue.CD_SANGUE_DERIVADOS = dbamv.sangue_derivados.cd_sangue_derivados
    and dt_solic_sangue between '01/12/2011' and '31/12/2011'  
    and DBAMV.it_solic_sangue.cd_sangue_derivados in (1,2,3,10 )

order by 1,2, 3


