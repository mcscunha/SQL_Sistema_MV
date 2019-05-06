create or replace view VDIC_OTIMAR_CONFI_CIR_ as
 SELECT A.CD_AVISO_CIRURGIA,
A.DT_AVISO_CIRURGIA,
A.CD_ATENDIMENTO,
A.CD_PACIENTE,
A.NM_PACIENTE,
A.TP_SITUACAO,
B.CD_ORI_ATE,

C.CD_ESPECIALID,

E.DS_ESPECIALID

FROM DBAMV.AVISO_CIRURGIA A,
DBAMV.ATENDIME B,
 CIRURGIA_AVISO C,
 DBAMV.ESPECIALID E
 

WHERE A.CD_ATENDIMENTO = B.CD_ATENDIMENTO
AND CD_ORI_ATE = '14'
  and A.TP_SITUACAO ='R'
  AND A.CD_AVISO_CIRURGIA = C.CD_AVISO_CIRURGIA
  AND C.CD_ESPECIALID = E.CD_ESPECIALID