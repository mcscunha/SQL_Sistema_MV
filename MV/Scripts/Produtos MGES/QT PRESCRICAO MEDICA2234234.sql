SELECT A.CD_SOLSAI_PRO,A.CD_PRE_MED,A.TP_SOLSAI_PRO,A.DT_SOLSAI_PRO,B.NM_SETOR
 FROM DBAMV.SOLSAI_PRO A,
 dbamv.setor B

 where  a.dt_solsai_pro between to_date('01/01/2016', 'dd/mm/yyyy') and to_date('02/01/2016', 'dd/mm/yyyy')
 and B.CD_SETOR = A.CD_SETOR
