
SELECT
A.CD_MOV_CARDAPIO,
A.DT_MOV_CARDAPIO,
A.TP_CARDAPIO,
A.CD_TIPO_REFEICAO,
A.CD_FUNC,

B.NM_FUNC,

C.DS_TIPO_REFEICAO,
C.VL_REFEICAO
      
FROM   
DBAMV.MOV_CARDAPIO A,
DBAMV.FUNCIONARIO B,
DBAMV.TIPO_REFEICAO C

WHERE  A.DT_MOV_CARDAPIO between  to_date('01/08/2016', 'dd/mm/yyyy') and to_date('02/08/2016', 'dd/mm/yyyy')
AND TP_CARDAPIO = 'F'
AND A.CD_FUNC = B.CD_FUNC
AND A.CD_TIPO_REFEICAO = C.CD_TIPO_REFEICAO


 

