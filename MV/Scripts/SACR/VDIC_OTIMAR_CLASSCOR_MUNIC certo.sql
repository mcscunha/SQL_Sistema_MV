create or replace view VDIC_OTIMAR_CLASSCOR_MUNIC as

SELECT A.CD_TRIAGEM_ATENDIMENTO,
A.DH_PRE_ATENDIMENTO,
A.NM_PACIENTE,
A.CD_COR_REFERENCIA
,A.CD_CLASSIFICACAO,
A.CD_CIDADE_PACIENTE,
TP_CLASSIFICACAO,
DH_REMOVIDO,
DH_PRE_ATENDIMENTO_FIM, 
DH_CHAMADA_CLASSIFICACAO,
B.DS_TIPO_RISCO,
C.NM_CIDADE

FROM TRIAGEM_ATENDIMENTO A ,
DBAMV.SACR_CLASSIFICACAO B,
DBAMV.CIDADE C


WHERE  B.CD_CLASSIFICACAO = A.CD_CLASSIFICACAO
AND C.CD_CIDADE = A.CD_CIDADE_PACIENTE 

