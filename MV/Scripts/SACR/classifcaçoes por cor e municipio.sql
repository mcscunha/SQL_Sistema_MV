
             


SELECT CD_TRIAGEM_ATENDIMENTO,DH_PRE_ATENDIMENTO,
NM_PACIENTE,CD_COR_REFERENCIA,CD_CLASSIFICACAO,
CD_CIDADE_PACIENTE,TP_CLASSIFICACAO,DH_REMOVIDO,DH_PRE_ATENDIMENTO_FIM, DH_CHAMADA_CLASSIFICACAO

FROM TRIAGEM_ATENDIMENTO 

WHERE DH_PRE_ATENDIMENTO between  to_date('01/04/2016', 'dd/mm/yyyy') and to_date('01/05/2016', 'dd/mm/yyyy')
 
