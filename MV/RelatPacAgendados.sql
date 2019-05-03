SELECT ROW_NUMBER() OVER(ORDER BY NM_PACIENTE, I.DS_ITEM_AGENDAMENTO) LINHA,
       -- COUNT(*) OVER(PARTITION BY NM_PACIENTE ORDER BY NM_PACIENTE) || ' ----- ' || SUBSTR(NM_PACIENTE, 1, INSTR(NM_PACIENTE, ' ') - 1) NUM_PROCED,
       COUNT(*) OVER(PARTITION BY NM_PACIENTE ORDER BY NM_PACIENTE) NUM_PROCED,
       A.CD_AGENDA_CENTRAL,
       TRUNC(B.HR_AGENDA) HINICIO,
       TRUNC(B.HR_FIM) HFIM,
       D.NM_PRESTADOR,
       B.CD_PACIENTE,
       B.NM_PACIENTE,
       NVL(FLOOR(MONTHS_BETWEEN(SYSDATE, B.DT_NASCIMENTO) / 12), 0) IDADE,
       I.DS_ITEM_AGENDAMENTO,
       C.NM_CONVENIO,
       DECODE(INSTR(B.CD_USUARIO, '.'),
              0,
              B.CD_USUARIO,
              SUBSTR(B.CD_USUARIO, 1, INSTR(B.CD_USUARIO, '.') - 1)) AS USUARIO,
       --       SUBSTR(B.Cd_Usuario, 1, decode(pos(B.Cd_Usuario, '.')INSTR(B.Cd_Usuario, '.')-1) USUARIO,
       B.DS_OBSERVACAO,
       B.DS_OBSERVACAO_GERAL
  FROM AGENDA_CENTRAL A
 INNER JOIN IT_AGENDA_CENTRAL B
    ON A.CD_AGENDA_CENTRAL = B.CD_AGENDA_CENTRAL
 INNER JOIN ITEM_AGENDAMENTO I
    ON I.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
 INNER JOIN CONVENIO C
    ON C.CD_CONVENIO = B.CD_CONVENIO
 INNER JOIN PRESTADOR D
    ON D.CD_PRESTADOR = A.CD_PRESTADOR
 WHERE B.CD_IT_AGENDA_PAI IS NULL
   AND B.CD_PACIENTE IS NOT NULL
   AND TRUNC(A.DT_AGENDA) = '08/aug/2018'
 ORDER BY NM_PACIENTE, I.DS_ITEM_AGENDAMENTO



















SELECT 
       ROW_NUMBER() OVER(ORDER BY nm_paciente) Linha,
--       ROW_NUMBER() OVER(PARTITION BY nm_paciente ORDER BY nm_paciente) ordem,
--       ROW COUNT() OVER(PARTITION BY nm_paciente ORDER BY nm_paciente) total,
--       RANK() OVER(PARTITION BY nm_paciente ORDER BY nm_paciente) ranking, 
--       ntile(2) over (PARTITION BY nm_paciente order by B.Nm_Paciente desc) Grupo,
       COUNT(*) OVER (PARTITION BY nm_paciente ORDER BY nm_paciente) || ' ----- ' || SUBSTR(nm_paciente, 1, INSTR(nm_paciente, ' ')-1) NUM_PROCED,
--       last_value(ORDEM) over (partition by ordem order by nm_paciente range
--                         between unbounded preceding and unbounded following) rank,

       A.CD_AGENDA_CENTRAL,
       B.Hr_Agenda,
       B.HR_FIM,
       B.CD_PACIENTE,
       B.NM_PACIENTE,
       NVL(FLOOR(MONTHS_BETWEEN(SYSDATE, B.DT_NASCIMENTO) / 12), 0) IDADE,
       I.DS_ITEM_AGENDAMENTO,
       -- B.CD_CONVENIO,
       C.Nm_Convenio,
       B.Cd_Usuario,
       B.DS_OBSERVACAO,
       B.DS_OBSERVACAO_GERAL
       -- B.CD_IT_AGENDA_CENTRAL,
       -- B.NM_PACIENTE,
       -- I.CD_ITEM_AGENDAMENTO,
       -- A.DT_AGENDA
  FROM AGENDA_CENTRAL A
  JOIN IT_AGENDA_CENTRAL B
    ON A.CD_AGENDA_CENTRAL = B.CD_AGENDA_CENTRAL
  JOIN ITEM_AGENDAMENTO I
    ON I.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
  LEFT JOIN convenio C 
    ON C.CD_CONVENIO = B.Cd_Convenio
     
 WHERE A.DT_AGENDA = '08/aug/2018'
   AND B.CD_IT_AGENDA_PAI IS NULL
   AND B.CD_PACIENTE IS NOT NULL
 ORDER BY DT_AGENDA, NM_PACIENTE;






















SELECT * FROM agenda_central WHERE cd_agenda_central = 2640;
-- cd_prestador IS NOT NULL AND dt_agenda = '03/aug/2018' 

SELECT * FROM prestador WHERE cd_prestador = 24;

SELECT * FROM SETOR WHERE cd_setor = 79;

SELECT * FROM unidade_atendimento WHERE cd_unidade_atendimento = 2;

SELECT DECODE (tp_agenda, 'A', 'Ambulatorial', 'I', 'Diagnostico por Imagem', 'L', 'Laboriatorial') Tipo
FROM agenda_central WHERE cd_agenda_central = 2640;


SELECT A.*, B.DS_TIP_MAR
FROM agenda_central_ser_tipo A 
JOIN tip_mar B ON
     A.CD_TIP_MAR = B.CD_TIP_MAR
WHERE cd_agenda_central = 2640;


SELECT * FROM agenda_central_item_agenda WHERE cd_agenda_central = 2640;

SELECT * FROM item_agendamento ;


-- //////////////////////////////////////////////////////


SELECT * FROM agenda_central_ser_tipo WHERE cd_agenda_central = 2640;
SELECT * FROM tip_mar;


-- //////////////////////////////////////////////////////


SELECT B.NM_PACIENTE, I.DS_ITEM_AGENDAMENTO, A.DT_AGENDA
  FROM AGENDA_CENTRAL A, IT_AGENDA_CENTRAL B, ITEM_AGENDAMENTO I
 WHERE A.CD_AGENDA_CENTRAL = B.CD_AGENDA_CENTRAL
   AND I.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
 ORDER BY DT_AGENDA, NM_PACIENTE




-- ///////////////////////////////////////////////////////
-- 08/08/2018

SELECT A.Cd_Agenda_Central, B.Cd_It_Agenda_Central, B.NM_PACIENTE, I.Cd_Item_Agendamento, I.DS_ITEM_AGENDAMENTO, A.DT_AGENDA
  FROM AGENDA_CENTRAL A, IT_AGENDA_CENTRAL B, ITEM_AGENDAMENTO I
 WHERE A.CD_AGENDA_CENTRAL = B.CD_AGENDA_CENTRAL
   AND I.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
--   AND A.cd_agenda_central = 2637
   AND A.Dt_Agenda = '08/aug/2018'
   AND B.cd_it_agenda_pai IS NULL
   AND B.cd_paciente IS NOT NULL
 ORDER BY DT_AGENDA, NM_PACIENTE;



SELECT * FROM agenda_central WHERE cd_agenda_central = 2635;

SELECT DISTINCT * FROM it_agenda_central WHERE 
       cd_agenda_central = 2632 
       AND cd_paciente IS NOT NULL;
--       AND cd_it_agenda_pai IS NULL
;

SELECT * FROM item_agendamento WHERE cd_item_agendamento IN (SELECT cd_item_agendamento FROM it_agenda_central WHERE cd_agenda_central = 2635
       AND cd_paciente IS NOT NULL);

SELECT * FROM escala_central WHERE cd_escala_central IN (SELECT cd_item_agendamento FROM it_agenda_central WHERE cd_agenda_central = 2635
       AND cd_paciente IS NOT NULL);


