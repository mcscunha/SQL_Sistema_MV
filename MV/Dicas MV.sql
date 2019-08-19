###############################################
Tabela para o documento de entrega de exames
###############################################

-- Ver se existe algum objeto com o mesmo nome
SELECT * FROM all_objects WHERE owner = 'TI1'

-- Criar o objeto
CREATE TABLE dbamv.lista_exames (
       cd_id INTEGER NOT NULL,
       nm_exame VARCHAR2(200),
       sn_ativo NUMBER(1),
       PRIMARY KEY (cd_ID)
)

-- DROP TABLE dbamv.lista_exames;

-- Limpar a tabela, se necessario
DELETE FROM dbamv.lista_exames;

-- Preencher os dados
INSERT INTO dbamv.lista_exames VALUES (1, 'Galilei', 1);
INSERT INTO dbamv.lista_exames VALUES (2, 'Microscopia Especular (ME)', 1);
INSERT INTO dbamv.lista_exames VALUES (3, 'Paquimetria', 1);
INSERT INTO dbamv.lista_exames VALUES (4, 'Orbscan - Mapeamento Corneano Tridimensional', 1);
INSERT INTO dbamv.lista_exames VALUES (5, 'Campo Visual', 1);
INSERT INTO dbamv.lista_exames VALUES (6, 'Retinografia Fluorescente (Angiofluoresceinografia)', 1);
INSERT INTO dbamv.lista_exames VALUES (7, 'Retinografia Simples', 1);
INSERT INTO dbamv.lista_exames VALUES (8, 'Constraste de Sensibilidade', 1);
INSERT INTO dbamv.lista_exames VALUES (9, 'Biometria Ultrassonica', 1);
INSERT INTO dbamv.lista_exames VALUES (10, 'OCT - Tomografia de Coerencia Optica', 1);
INSERT INTO dbamv.lista_exames VALUES (11, 'Ultrassom', 1);
INSERT INTO dbamv.lista_exames VALUES (12, 'DVD (Contendo gravacao do procedimento cirurgico que fui submetido(a))', 1);
INSERT INTO dbamv.lista_exames VALUES (13, 'Relatorio Medico', 1);
INSERT INTO dbamv.lista_exames VALUES (14, 'Copia Integral do Prontuario', 1);
INSERT INTO dbamv.lista_exames VALUES (15, 'Copia de Documento de Prontuario', 1);
INSERT INTO dbamv.lista_exames VALUES (16, 'Informacoes Sobre Lente Intra Ocular (LIO)', 1);

-- Dar permissao aos usuarios
GRANT SELECT ON dbamv.lista_exames TO REMWEB, DBAMV, ACESSOPRD, ACESSOSML, ACESSOTRN, "MURILO.CUNHA";

-- Visualizar os dados
SELECT CD_ID, NM_EXAME
  FROM DBAMV.LISTA_EXAMES
 WHERE SN_ATIVO = 1
 ORDER BY CD_ID


###############################################
IP e Porta do banco de dados
###############################################

SELECT * FROM V$INSTANCE;

SELECT UTL_INADDR.GET_HOST_ADDRESS(HOST_NAME),
       UTL_INADDR.GET_HOST_NAME('192.168.0.10'),
       HOST_NAME
  FROM V$INSTANCE;

--Com esta outra querie, voc� identifica o endere�o IP de uma sess�o SQL*Plus cliente:
SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') FROM DUAL;
--Esta querie acima ir� retornar NULL, caso a sess�o n�o esteja usando TCP/IP na conex�o.

--Voc� tamb�m pode ter uma vis�o geral de todas as sess�es de banco existentes:
SELECT SID, OSUSER, TERMINAL FROM V$SESSION;


###############################################
(---- SQLSERVER  ----)
Saber IP e PORTA do banco conectado
(---- SQLSERVER  ----)
###############################################

-- Saber qual IP e Porta que a base est� conectada
SELECT @@SERVERNAME,
 CONNECTIONPROPERTY('net_transport') AS net_transport,
 CONNECTIONPROPERTY('protocol_type') AS protocol_type,
 CONNECTIONPROPERTY('auth_scheme') AS auth_scheme,
 CONNECTIONPROPERTY('local_net_address') AS local_net_address,
 CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
 CONNECTIONPROPERTY('client_net_address') AS client_net_address;


 -- Mesma forma, mas melhor explicada!
 SELECT 
   -- HTTP, Named pipe, Session, Shared memory, SSL, TCP, VIA
   CONNECTIONPROPERTY('net_transport') AS net_transport,
   -- SQL, SOAP
   CONNECTIONPROPERTY('protocol_type') AS protocol_type, 
   -- SQL, NTLM, KERBEROS, DIGEST, BASIC, NEGOTIATE
   CONNECTIONPROPERTY('auth_scheme') AS auth_scheme, 
   -- IP do servidor
   CONNECTIONPROPERTY('local_net_address') AS local_net_address,
   -- Porta
   CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
   -- IP do utilizado
   CONNECTIONPROPERTY('client_net_address') AS client_net_address;


###############################################
Corrigir erro de: Os dados foram alterados por outro usuario
(inserir a HORA junto com as datas)
###############################################

SELECT CD_PACIENTE,
       DT_CADASTRO,
       DT_CADASTRO_MANUAL,
       DT_EMISSAO_CERTIDAO,
       DT_EMISSAO_CTPS,
       DT_EMISSAO_IDENTIDADE,
       DT_ENTRADA_BRASIL,
       DT_ENTRADA_ESTRANGEIRO,
       DT_INATIVO,
       DT_INTEGRA,
       DT_NASCIMENTO,
       DT_NASCIMENTO_TUTOR,
       DT_NATURALIZACAO,
       DT_ULTIMA_ATUALIZACAO,
       DT_VALIDADE
  FROM PACIENTE
 WHERE CD_PACIENTE IN (83411, 107102, 91945, 102107, 106719)


###############################################
Verificar quais registros NAO EXISTEM em uma tabela
###############################################

-- Usando NOT IN
SELECT P.*
FROM paciente P
WHERE cd_paciente NOT IN (
SELECT cd_paciente FROM same)

-- Usando NOT EXISTS
SELECT P.*
FROM paciente P
WHERE NOT EXISTS (
SELECT cd_paciente, nr_matricula_same FROM same S 
WHERE S.Cd_Paciente = P.Cd_Paciente)


###############################################
INSERT com SUBSELECT
###############################################

INSERT INTO SAME
    (CD_PACIENTE, NR_VOLUME, SN_NO_LOCAL, NR_MATRICULA_SAME, CD_CAD_SAME, nr_matricula_volume, dt_cadastro)
    (SELECT CD_PACIENTE, 1, 'S', CD_PACIENTE, 1, cd_paciente||'.1', TRUNC(SYSDATE)
       FROM PACIENTE P
      WHERE NOT EXISTS (SELECT CD_PACIENTE, NR_MATRICULA_SAME
               FROM SAME S
              WHERE S.CD_PACIENTE = P.CD_PACIENTE))


###############################################
INFORMACOES DOS DOCUMENTOS DO EDITOR
###############################################

-- ORDEM DO DOCUMENTO AT� A RESPOSTA
SELECT *
FROM DBAMV.EDITOR_DOCUMENTO
WHERE Cd_DOCUMENTO = 449;


-- Informar a versao do documento
-- Quando importar, verificar qual a ultima versao do documento
-- e acertar no campo VL_VERSAO
SELECT *
FROM DBAMV.EDITOR_VERSAO_DOCUMENTO
WHERE CD_DOCUMENTO = 449
    and cd_versao_documento = 2021;


-- Se quiser guardar o documento ja feito para depois inserir novamente,
-- o conteudo do campo LO_CONTEUDO deve ser substituido
SELECT *
FROM DBAMV.EDITOR_LAYOUT
WHERE CD_VERSAO_DOCUMENTO IN (
    SELECT CD_VERSAO_DOCUMENTO
    FROM DBAMV.EDITOR_VERSAO_DOCUMENTO
    WHERE CD_DOCUMENTO = 449
        and cd_layout in (3709, 3720)
        -- 1=Tela  |  2=Relatorio
        --  AND Cd_TIPO_LAYOUT = 1  
    );
  

-- Guarda as varias vezes que foi salvo um documento para teste
-- Quando se usa a area de teste para ver como será a impressao
select *
from dbamv.editor_registro
where cd_layout IN (
    SELECT CD_LAYOUT
    FROM DBAMV.EDITOR_LAYOUT
    WHERE CD_VERSAO_DOCUMENTO IN (
        SELECT CD_VERSAO_DOCUMENTO
        FROM DBAMV.EDITOR_VERSAO_DOCUMENTO
        WHERE CD_DOCUMENTO = 449
            and cd_layout = 3709
    )
);


-- Conteudo de cada campo em cada gravacao para impressao
SELECT A.CD_CAMPO
      ,B.DS_CAMPO
      ,TO_CHAR(A.LO_VALOR)
FROM DBAMV.EDITOR_REGISTRO_CAMPO A
INNER JOIN DBAMV.EDITOR_CAMPO    B ON B.CD_CAMPO = A.CD_CAMPO
WHERE A.CD_REGISTRO = 38747;


###############################################
Remover caracteres especiais
###############################################

function fun_remove_char_esp(texto in varchar2) return varchar2 is
begin
  return translate(
         texto,
         '������������������������������������������������.-!"''`#$%().:[/]{}�+?;����&�*<>',
         'NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc'
         );
end;


###############################################
Criar usuario ADMINISTRADOR
###############################################

CREATE USER nome IDENTIFIED BY senha;
GRANT DBA TO nome;


###############################################
WHILE LOOP
###############################################

DECLARE
  done  BOOLEAN := FALSE;
BEGIN
  WHILE done LOOP
    DBMS_OUTPUT.PUT_LINE ('This line does not print.');
    done := TRUE;  -- This assignment is not made.
  END LOOP;

  WHILE NOT done LOOP
    DBMS_OUTPUT.PUT_LINE ('Hello, world!');
    done := TRUE;
  END LOOP;
END;
/

###############################################
GOTO statement
###############################################

DECLARE
  p  VARCHAR2(30);
  n  PLS_INTEGER := 37;
BEGIN
  FOR j in 2..ROUND(SQRT(n)) LOOP
    IF n MOD j = 0 THEN
      p := ' is not a prime number';
      GOTO print_now;
    END IF;
  END LOOP;

  p := ' is a prime number';
 
  <<print_now>>
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(n) || p);
END;
/


###############################################
EXIT outer LOOP
###############################################

DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
      EXIT outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/



###############################################
CONTINUE outer LOOP
###############################################

DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
      CONTINUE outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/


###############################################
NESTED LOOP
###############################################

DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
      EXIT outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/


###############################################
Trabalhando com variaveis do mesmo tipo do campo da tabela
###############################################

-- available online in file 'examp3'
DECLARE
   salary         emp.sal%TYPE := 0;
   mgr_num        emp.mgr%TYPE;
   last_name      emp.ename%TYPE;
   starting_empno emp.empno%TYPE := 7499;
BEGIN
   SELECT mgr INTO mgr_num FROM emp 
      WHERE empno = starting_empno;
   WHILE salary <= 2500 LOOP
      SELECT sal, mgr, ename INTO salary, mgr_num, last_name
         FROM emp WHERE empno = mgr_num;
   END LOOP;
   INSERT INTO temp VALUES (NULL, salary, last_name);
   COMMIT;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      INSERT INTO temp VALUES (NULL, NULL, 'Not found');
      COMMIT;
END;


###############################################
Trabalhando com LOOP
###############################################

CREATE TABLE pressao_olho (
       ID NUMBER(5),
       pressao VARCHAR2(50),
       selecao CHAR(1),
       PRIMARY KEY (ID)
);

DECLARE
    -- x dbms_utility.number_array;
  begin
    -- Abre um cursor loop na tabela de origem
    FOR r IN 0..70 LOOP
        -- Processa os dados e guarda o resultado na tabela
        insert into pressao_olho values(r, r, 'N');
    end loop;
    -- forall ...
  end;
/

-- SELECT * FROM pressao_olho

###############################################
Modelo de UPDATE com JOIN
###############################################

UPDATE IT_SAME A
   SET A.NR_MATRICULA_SAME =
       (SELECT B.CD_PACIENTE
          FROM SAME B
         WHERE A.CD_CAD_SAME = B.CD_CAD_SAME
           AND A.NR_MATRICULA_SAME = B.NR_MATRICULA_SAME
           AND A.NR_VOLUME = B.NR_VOLUME
           AND B.CD_PACIENTE <> B.NR_MATRICULA_SAME)
 WHERE EXISTS (SELECT B.CD_PACIENTE
          FROM SAME B
         WHERE A.CD_CAD_SAME = B.CD_CAD_SAME
           AND A.NR_MATRICULA_SAME = B.NR_MATRICULA_SAME
           AND A.NR_VOLUME = B.NR_VOLUME
           AND B.CD_PACIENTE <> B.NR_MATRICULA_SAME)


###############################################
Corrigir NR_MATRICULA_SAME da tabela SAME e IT_SAME
###############################################

-- Dropando tabelas caso crie erroneamente
-- DROP TABLE it_same_20181204;
-- DROP TABLE same_20181204;

-- Criando as tabelas de backup dos dados
CREATE TABLE it_same_20181204 AS SELECT * FROM dbamv.it_same;
CREATE TABLE same_20181204 AS SELECT * FROM dbamv.same;

-- Desabilitar a constraint para realizar o update
-- Passo necessario pq se alterar aqui, reclama de inexistencia do
--    registro pai na tabela SAME, se alterar a SAME, diz que ha 
--    vinculo de filho com IT_SAME (cachorro correndo atras do rabo)
ALTER TABLE dbamv.it_same DISABLE CONSTRAINT cnt_it_same_same_1_fk;

-- Alterar o NR_MATRICULA_SAME, em IT_SAME, para o mesmo numero do
--    CD_PACIENTE da tabela ATENDIME
UPDATE (SELECT A.Nr_Matricula_Same, B.Cd_Paciente
          FROM dbamv.it_same A
          JOIN dbamv.atendime B
            ON A.Cd_Atendimento = B.Cd_Atendimento
          WHERE A.Nr_Matricula_Same <> B.Cd_Paciente
         ) T
   SET T.NR_MATRICULA_SAME = T.CD_PACIENTE;

-- Alterar o NR_MATRICULA_SAME, em SAME, para o mesmo numero
--    CD_PACIENTE da mesma tabela 
UPDATE SAME
   SET NR_MATRICULA_SAME = CD_PACIENTE
 WHERE NR_MATRICULA_SAME <> CD_PACIENTE;

-- Ativar a constraint para nao haver duplicacao de registros
ALTER TABLE dbamv.it_same ENABLE CONSTRAINT cnt_it_same_same_1_fk;

-- Confirmando os dados --->> NR_MATRICULA_SAME = CD_PACIENTE
SELECT * FROM dbamv.atendime WHERE cd_paciente = 106820; -- cd_atendimento = 187;
SELECT * FROM dbamv.it_same WHERE cd_atendimento IN (187, 299);
SELECT * FROM dbamv.same WHERE cd_paciente = 106697; 
SELECT * FROM dbamv.paciente WHERE cd_paciente IN (106687, 106686);

-- Listar quais registros serao alterados
SELECT A.NR_MATRICULA_SAME, B.CD_PACIENTE, A.Dt_Entrada
  FROM dbamv.IT_SAME A
  JOIN dbamv.ATENDIME B
    ON A.CD_ATENDIMENTO = B.CD_ATENDIMENTO
 WHERE A.NR_MATRICULA_SAME <> B.CD_PACIENTE

COMMIT;

###############################################
Dar permissao de SELECT a uma tabela nova no BD
###############################################

GRANT SELECT ON dbamv.grau_com_barra TO REMWEB, DBAMV, "MURILO.CUNHA"
GRANT SELECT ON dbamv.grau_com_barra TO ACESSOPRD, ACESSOSML, ACESSOTRN;
COMMIT


select  DISTINCT parsing_schema_name
FROM v$sql
--where PARSING_SCHEMA_NAME = 'DBAMV'
--ORDER BY LAST_ACTIVE_TIME DESC  --where parsing_schema_name  = 'gesti_leitura'


###############################################
Apagar um ATENDIMENTO no banco
###############################################

SELECT * FROM atendime WHERE cd_atendimento IN (648, 664, 654)

SELECT * FROM casos_atd WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM evo_casos WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM diagnostico_atendime WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM evo_enf WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM IT_AGENDA_CENTRAL WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM itreg_amb WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM mov_hosp WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM itped_rx WHERE cd_ped_rx IN (SELECT cd_ped_rx FROM ped_rx WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM ped_rx WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM pre_med WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM itpre_med WHERE cd_pre_med = (SELECT cd_pre_med FROM pre_med WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM DIAGNOSTICO_ATENDIME WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM mov_hosp WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM pre_med WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM SACR_TEMPO_PROCESSO WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM PW_EDITOR_CLINICO WHERE cd_documento_clinico IN (SELECT cd_documento_clinico FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM PW_REGISTRO_ALTA WHERE cd_documento_clinico IN (SELECT cd_documento_clinico FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM age_cir_equipto WHERE cd_age_cir IN (SELECT cd_age_cir FROM age_cir WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654)));
SELECT * FROM age_cir WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM aviso_equipamentos WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM cirurgia_aviso WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM res_lei WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
SELECT * FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654);
SELECT * FROM guia WHERE cd_atendimento IN (648, 664, 654);


DELETE FROM evo_casos WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM casos_atd WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM diagnostico_atendime WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM evo_enf WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM IT_AGENDA_CENTRAL WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM mov_hosp WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM itreg_amb WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM itped_rx WHERE cd_ped_rx = (SELECT cd_ped_rx FROM ped_rx WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM ped_rx WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM itpre_med WHERE cd_pre_med = (SELECT cd_pre_med FROM pre_med WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM pre_med WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM DIAGNOSTICO_ATENDIME WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM mov_hosp WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM SACR_TEMPO_PROCESSO WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM PW_EDITOR_CLINICO WHERE cd_documento_clinico IN (SELECT cd_documento_clinico FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM PW_REGISTRO_ALTA WHERE cd_documento_clinico IN (SELECT cd_documento_clinico FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM PW_DOCUMENTO_CLINICO WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM age_cir_equipto WHERE cd_age_cir IN (SELECT cd_age_cir FROM age_cir WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654)));
DELETE FROM aviso_equipamentos WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM age_cir WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM cirurgia_aviso WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM res_lei WHERE cd_aviso_cirurgia IN (SELECT cd_aviso_cirurgia FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654));
DELETE FROM aviso_cirurgia WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM guia WHERE cd_atendimento IN (648, 664, 654);
DELETE FROM atendime WHERE cd_atendimento IN (648, 664, 654);



-- Nome da tabela a FK est� ligada
select * from all_constraints where constraint_name like '%CNT_PW_REG_ALTA_DOC%'



###############################################
Backup de uma tabela especifica no Oracle
###############################################

create table cod_pro_20180903 as select * from cod_pro

###############################################
EDITOR - Encontrar qual documento estah 
	associado ao cabecalho
###############################################

SELECT *
  FROM EDITOR_LAYOUT
 WHERE CD_VERSAO_DOCUMENTO IN
       (SELECT CD_VERSAO_DOCUMENTO
          FROM EDITOR_VERSAO_DOCUMENTO
         WHERE CD_DOCUMENTO = 499)
    OR CD_LAYOUT_CABECALHO IN
       (SELECT CD_LAYOUT
          FROM EDITOR_LAYOUT
         WHERE CD_VERSAO_DOCUMENTO IN
               (SELECT CD_VERSAO_DOCUMENTO
                  FROM EDITOR_VERSAO_DOCUMENTO
                 WHERE CD_DOCUMENTO = 499))



###############################################
EDITOR - Manipulacao dos dados direto no banco
###############################################

-- Listar o dados do documento escolhido
SELECT * FROM editor_documento WHERE cd_documento = 468;
-- Exibir a qual grupo PAI pertence
SELECT * FROM editor_grupo WHERE cd_grupo = 1838;
-- Se tiver o numero do registro salvo, encontra-se o layout
SELECT * FROM editor_registro WHERE cd_registro = 3491;
-- Com o numero do documento, encontra-se a versao do documento
SELECT * FROM editor_versao_documento WHERE cd_documento = 468;
-- Com a versao do documento, encontra-se o layout
SELECT * FROM editor_layout WHERE cd_versao_documento = 1898 AND ds_layout = 'Tela';
-- Com o layout, encontra-se a tabela com os: Valores padrao para cada campo E conteudo salvo de cada campo
SELECT * FROM editor_layout_campo WHERE cd_layout = 3401;
       -- Valores padrao para cada campo
       SELECT * FROM editor_campo_valor WHERE cd_campo IN (SELECT cd_campo FROM editor_layout_campo WHERE cd_layout = 3401);
       -- Conteudo salvo de cada campo
       SELECT * FROM editor_registro_campo WHERE cd_campo IN (SELECT cd_campo FROM editor_layout_campo WHERE cd_layout = 3401);

-- Listar o dados do documento escolhido
SELECT *
       -- DISTINCT E.Cd_Registro
       -- COUNT(*)
  FROM EDITOR_DOCUMENTO A
  JOIN EDITOR_VERSAO_DOCUMENTO B
    ON A.CD_DOCUMENTO = B. CD_DOCUMENTO
  JOIN EDITOR_LAYOUT C
    ON B.CD_VERSAO_DOCUMENTO = C.CD_VERSAO_DOCUMENTO
  JOIN EDITOR_LAYOUT_CAMPO D
    ON C.CD_LAYOUT = D.CD_LAYOUT
  JOIN EDITOR_REGISTRO F
    ON C.CD_LAYOUT = F.CD_LAYOUT
   AND D.CD_LAYOUT = F.CD_LAYOUT
  JOIN EDITOR_REGISTRO_CAMPO E
    ON E.CD_REGISTRO = F.CD_REGISTRO
   AND D.CD_CAMPO = E.CD_CAMPO
 WHERE B.CD_VERSAO_DOCUMENTO IN (SELECT Z.CD_VERSAO_DOCUMENTO
                                   FROM EDITOR_VERSAO_DOCUMENTO Z
                                  WHERE Z.CD_DOCUMENTO = 468
                                 --           AND Z.SN_FOI_PUBLICADO = 'N'
                                 --           AND Z.SN_ATIVO = 'S'
                                 )
   AND C.DS_LAYOUT = 'Tela'


###############################################
INSERT com SELECT para cadastro de TAXAS EQUIPAMENTOS
	da tela de CIRURGIA
###############################################

INSERT INTO APARELHO_CIRURGIA
  (CD_CIRURGIA, CD_APARELHO_EQUIPAMENTO, QT_NECESSARIO)
  SELECT A.CD_CIRURGIA, B.CD_APARELHO_EQUIPAMENTO, 1
    FROM CIRURGIA A, APARELHOS_EQUIPTO B
   WHERE B.CD_APARELHO_EQUIPAMENTO IN (54,
                                       189,
                                       22,
                                       47,
                                       56,
                                       170,
                                       171,
                                       216,
                                       217,
                                       172,
                                       164,
                                       15,
                                       218,
                                       219,
                                       220)
     AND A.SN_ATIVO = 'S'
   ORDER BY CD_CIRURGIA, CD_APARELHO_EQUIPAMENTO


###############################################
Encontrar os relacionamentos de FK, PK e outros
###############################################

-- 
SELECT * FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%TEXTO%'

-- Encontrar que tabela tem este nome
select * from all_all_tables where table_name like '%_PLANO_%'

-- Encontrar em que tabela a restricao estah apontando
select * from all_constraints where constraint_name like '%CFG_CAIXA_PLANO_%'
select * from all_cons_columns where constraint_name  = 'ORI_ATE_SETOR_FK'

-- Encontrar uma coluna com um certo nome em todo o banco
SELECT * FROM all_tab_columns WHERE upper(column_name) LIKE '%CD_REDUZIDO%'

-- Melhor consulta para exibir os relacionamentos entre as tabelas (FKs)
SELECT
  UC.CONSTRAINT_NAME CONSTRAINT_NAME,
        UC.TABLE_NAME CHILD_TABLE,
        UCC.COLUMN_NAME CHILD_COLUMN,
        UCR.TABLE_NAME PARENT_TABLE,
        UCCR.COLUMN_NAME PARENT_COLUMN
FROM USER_CONSTRAINTS UC
INNER JOIN USER_CONSTRAINTS UCR
  ON UCR.CONSTRAINT_NAME = UC.R_CONSTRAINT_NAME
INNER JOIN USER_CONS_COLUMNS UCC
  ON UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
     AND UC.TABLE_NAME = UCC.TABLE_NAME
INNER JOIN USER_CONS_COLUMNS UCCR
  ON UCCR.CONSTRAINT_NAME = UCR.CONSTRAINT_NAME
     AND UCR.TABLE_NAME = UCCR.TABLE_NAME
     AND UCCR.POSITION = UCC.POSITION
WHERE UCR.TABLE_NAME IN ('SETOR') --COLOCAR A TABELA PARA SER ANALISADA
     AND UCR.CONSTRAINT_TYPE IN( 'P','U')
ORDER BY CHILD_TABLE, CONSTRAINT_NAME, CHILD_COLUMN

-- R" de "Referential", ou seja, � uma CONSTRAINT do tipo FK !
-- Para os valores, pelo o que sei pode receber valores abaixo:
--	C = Check
--	P = Primary Key
--	R = Foreign Key
--	U = Unique Key
--	O = READ ONLY em uma VIEW
--	V = Check em uma VIEW

###############################################
Apagar registro do plano de contas
###############################################

-- Para selecionar com base em uma comparacao
select * from config_caixa where 
    (
	',' || 
	CD_REDUZIDO_DESPESA || ',' || 
	CD_REDUZIDO_RECEITA || ',' || 
	CD_REDUZIDO_CAUCAO_PASSIVO || ',' || 
	CD_REDUZIDO_CUSTODIADO || ',' || 
	CD_REDUZIDO_PROTESTADO || ',' || 
	CD_REDUZIDO_CAUCAO_ATIVO || ',' || 
	CD_REDUZIDO_SEM_FUNDO || ',' || 
	CD_REDUZIDO_REEMB_CAUCAO || ',' 
    ) like '%, 200, %'

-- Para selecionar comparando com uma lista 
-- (deve-se ativar ou desativar os campos desejados, um de cada vez)
delete from estoque_pl_contas where 
    	-- CD_RED_EMP_CONCEDIDO
    	-- CD_RED_EMP_RECEBIDO
    	-- CD_RED_PAG_EMP_CONCEDIDO
    	-- CD_RED_PAG_EMP_RECEBIDO
    	-- CD_REDUZIDO_DEBITO_BAIXA
    	-- CD_RED_MANIPULACAO_DEBITO
    	-- CD_RED_MANIPULACAO_CREDITO
    	-- CD_RED_AJUSTE_DEBITO
    	-- CD_RED_AJUSTE_CREDITO
    	-- CD_REDUZIDO_RECEITA
        CD_REDUZIDO_DESPESA
    	-- CD_REDUZIDO
    in ()

delete from fincar_pl_contas where cd_reduzido in ( );

delete from forn_conta where cd_reduzido in ( )

delete from config_caixa

delete from PLANO_USUARIO_MULTI_EMPRESA where cd_reduzido in ( );

delete from DESC_ACRES_CONTA where cd_reduzido in ( );

delete from plano_contas where cd_reduzido in ( );

###############################################
Para criar seu proprio banco
###############################################

-- CRIANDO A TABLESPACE
CREATE TABLESPACE TS_KOKIZO DATAFILE '/home/oracle/df_kokizo.dbf' SIZE 10M;
ALTER DATABASE DATAFILE '/home/oracle/df_kokizo.dbf' AUTOEXTEND ON;
-- CREATE TABLESPACE TBS_KOKIZO DATAFILE '/home/oracle/tbs_perm_02.dat' SIZE 10M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 200M;

-- CRIANDO O USUARIO PARA ESTA TABLESPACE
CREATE USER USRKOKIZO IDENTIFIED BY PASSKOKIZO DEFAULT TABLESPACE TS_KOKIZO;
ALTER USER USRKOKIZO QUOTA UNLIMITED ON TS_KOKIZO;
GRANT CONNECT, CREATE SESSION, IMP_FULL_DATABASE TO USRKOKIZO WITH ADMIN OPTION;
SELECT * FROM DBA_USERS;

-- CRIANDO O OBJETO "directory", DO ORACLE, PARA MOSTRAR EM QUE DIRETORIO SE ENCOTRA O DUMP
SELECT * FROM DBA_DIRECTORIES
CREATE OR REPLACE DIRECTORY DIR_DUMP_KOKIZO AS '/home/oracle/';
GRANT READ, WRITE ON DIRECTORY DIR_DUMP_KOKIZO TO USRKOKIZO;
SELECT * FROM USER_TAB_PRIVS WHERE TABLE_NAME = 'DIR_DUMP_KOKIZO';

-- DESFAZENDO AS COISAS
-- DROP TABLESPACE TS_KOKIZO
-- DROP USER USRKOKIZO
-- DROP DIRECTORY DIR_DUMP_KOKIZO;

-- ESTANDO LOGADO NO SQL (LINHA DE COMANDO),
--         NA INSTANCIA (TNS), ONDE CRIOU OS DADOS ACIMA, EXECUTE:


-- PARA CONFIRMAR Q ESTAH NA INSTANCIA CERTA. DEVE-SE VER O "directory" CRIADO ACIMA
-- Conecte-se no sqlcmd e execute:
SELECT * FROM DBA_DIRECTORIES;
-- PARA CONFIRMAR SE O USUARIO EXISTE NA INSTANCIA
SELECT * FROM DBA_USERS;
-- CONFIRMANDO, EXECUTE:
IMPDP DBAMV/DBAMV REMAP_SCHEMA=DADADOS_ABERTOS:USRKOKIZO REMAP_TABLESPACE=TD_DADOSABERTOS:TS_KOKIZO DIRECTORY=DIR_DUMP_KOKIZO DUMPFILE=TA_PRODUTO_SAUDE_MODELO.DMP LOGFILE=DIR_DUMP_KOKIZO:IMP.LOG FULL=Y

###############################################
Cadastro dos PLANOS dos CONVENIOS
###############################################

-- Insercao de CONVENIO_PLANO
insert into con_pla (ds_con_pla, cd_tip_acom_padrao, ds_codigo_plano, cd_con_pla, cd_convenio, cd_indice, cd_regra) values ('312 - EXECUTIVO - IND',12,'31203',	 seq_con_pla.nextval, 3, 50, 41);

-- Grid da tela CONVENIO, guia PLANO
insert into EMPRESA_CON_PLA (CD_CON_PLA, CD_CONVENIO, CD_MULTI_EMPRESA, SN_ATIVO, CD_REGRA, CD_INDICE, SN_PERMITE_AMBULATORIO, SN_PERMITE_INTERNACAO,  SN_PERMITE_HOCA, SN_PERMITE_URGENCIA, SN_PERMITE_EXTERNO, SN_OBRIGA_SENHA, SN_VALIDA_NR_GUIA, SN_OBRIGA_GUIA_NA_DIARIA, HR_VENCIMENTO, NR_TEMPO_TOLERANCIA, HR_LIMITE, CD_GRU_FAT, CD_PRO_FAT, QT_PRO_FAT, TP_PERCENT_ACOMOD_ITEM, SN_JUSTIFICA_PRORROGACAO, DS_OBSERVACAO, SN_AGRUPA_TAXA_MANUSEIO) values 	  (seq_con_pla.currval, 3,  1, 'S', 41, 50, 'S', 'S', 'S', 'S', 'S', 'N', 'N', 'S', null, null, null, null, null, null, 'N', 'N', '<Long>', 'S');


###############################################
Para saber qual modulo pertence uma dada tela
###############################################

SELECT * FROM dbasgu.modulos WHERE cd_modulo = 'C_CONSULTA_CEP_ECT'

-- Lista os modulos com suas respectivas telas
SELECT * FROM dbasgu.mod_sis


###############################################
Data Completa no MVEditor
###############################################

-- Acessando pelo banco
SELECT ('RIBEIR�O PRETO, ' ||
       TO_CHAR(TO_DATE(SYSDATE),
                'DD " DE " FMMONTH " DE " YYYY',
                'NLS_DATE_LANGUAGE = PORTUGUESE')) DATA
FROM DUAL



-- Data Atual Completa - Versao 1 - Switch
{
	"Ribeir�o Preto, " +
	Day(Today)+ " de "+
	Switch( 
		Month(Today)==1 , "Janeiro",
		Month(Today)==2 , "Fevereiro",
		Month(Today)==3 , "Mar�o",
		Month(Today)==4 , "Abril",
		Month(Today)==5 , "Maio",
		Month(Today)==6 , "Junho",
		Month(Today)==7 , "Julho",
		Month(Today)==8 , "Agosto",
		Month(Today)==9 , "Setembro",
		Month(Today)==10, "Outubro",
		Month(Today)==11, "Novembro",
		Month(Today)==12, "Dezembro" 
	)+
	" de " + Year(Today)
}


-- Data Atual Completa - Versao 2 - IIF
{
	"Ribeir�o Preto, " +
	Day(Today)+ " de "+
	IIF(Month(Today)==1 , "Janeiro",
		IIF(Month(Today)==2 , "Fevereiro",
			IIF(Month(Today)==3 , "Mar�o",
				IIF(Month(Today)==4 , "Abril",
					IIF(Month(Today)==5 , "Maio",
						IIF(Month(Today)==6 , "Junho",
							IIF(Month(Today)==7 , "Julho",
								IIF(Month(Today)==8 , "Agosto",
									IIF(Month(Today)==9 , "Setembro",
										IIF(Month(Today)==10, "Outubro", 
											IIF(Month(Today)==11, "Novembro", "Dezembro"
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)+
	" de " + Year(Today)
}


###############################################
Data no REPORT
###############################################

{"Data: " + 
	IIF((Day(V_DATAPROCED)>=1) && (Day(V_DATAPROCED)<=9), 
		"0" + Day(V_DATAPROCED), 
		Day(V_DATAPROCED)
	) + "/" + 
	IIF((Month(V_DATAPROCED)>=1) && (Month(V_DATAPROCED)<=9), 
		"0" + Month(V_DATAPROCED), 
		Month(V_DATAPROCED)
	) + "/" + 
	Year(V_DATAPROCED) 
}

###############################################
Data no REPORT
###############################################

{
"Ribeir�o Preto, " +
Day(V_DATAPROCED)+ " de "+
	Switch( 
		Month(V_DATAPROCED)==1 , "Janeiro",
		Month(V_DATAPROCED)==2 , "Fevereiro",
		Month(V_DATAPROCED)==3 , "Mar�o",
		Month(V_DATAPROCED)==4 , "Abril",
		Month(V_DATAPROCED)==5 , "Maio",
		Month(V_DATAPROCED)==6 , "Junho",
		Month(V_DATAPROCED)==7 , "Julho",
		Month(V_DATAPROCED)==8 , "Agosto",
		Month(V_DATAPROCED)==9 , "Setembro",
		Month(V_DATAPROCED)==10, "Outubro",
		Month(V_DATAPROCED)==11, "Novembro",
		Month(V_DATAPROCED)==12, "Dezembro" 
	)+
" de " + Year(V_DATAPROCED)
}


###############################################
Composicao de Data
###############################################
{DateSerial(2018, 2, 13)}


###############################################
Operador AND no MVEditor
###############################################
{2==2 & 5==5}

###############################################
Operador OR no MVEditor
###############################################
{2==6 || 3==5}

###############################################
Numero do dia no ano, no MVEditor
###############################################
{DayOfYear(Today)}



##############################
pda
jefferson.oliveira
1iorr@17
##############################

-- ##################################################################
-- TABELAS DO SISTEMA MV
-- ##################################################################
--
-- Usuario DBAMV
--
-- VAL_PRO 		- Valor dos procedimentos - Area de Faturamento de convenios e parceiros
-- TAB_FAT 		- Tabela de faturamento. Cria os varios tipos de faturamento (convenios, parceiros...)
-- PRO_FAT 		- Procedimentos utilizados na clinica e que podem ser valorados (relacao com as duas acima)
-- CIRURGIA 		- Lista de todas as cirurgias realizadas na clinica
--
--
-- Usuario DBASGU
--
-- USUARIOS 		- Lista de usuarios
-- PAPEL 		- Lista de papeis
-- PAPEL_USUARIOS 	- Usuarios associados ao seu papel (relacao das duas tabelas acima)
-- PAPEL_MOD 		- Lista de modulos e botoes que cada papel pode ou nao acessar


##################################################################
-- Usuarios com seus PAPEIS/MODULOS/TELAS associados
SELECT P.*, U.*, PU.*, PM.*
FROM dbasgu.usuarios U
JOIN dbasgu.papel_usuarios PU ON
     U.Cd_Usuario = PU.CD_USUARIO
JOIN dbasgu.papel P ON
     P.CD_PAPEL = PU.CD_PAPEL
JOIN dbasgu.papel_mod PM ON
     PM.CD_PAPEL = PU.CD_PAPEL
WHERE PU.Cd_Papel = 141


##################################################################
AMAP 	- Gerenciamento de SAME.lnk
AMDC 	- Diretoria Clinica.lnk
FCCT 	- Controle Contabil.lnk
FFAS 	- Faturamento Ambulatorial.lnk
FFCH 	- Gerenciamento de Custos.lnk
FFCV 	- Faturamento de Convenios.lnk
FFIS 	- Faturamento AIH.lnk
FNCT 	- Tesouraria.lnk
FNFI 	- Contas a Pagar e a Receber.lnk
FNRM 	- Repasse Medico.lnk
FSCC 	- Centro Cirurgico e Obstetrico.lnk
GLOBAL 	- Gerenciamento de Tabelas.lnk
HOCA 	- Internacoes Home Care.lnk
MGCO 	- Controle de Compras.lnk
MGES 	- Controle de Estoque.lnk
PAEU 	- Urgencia-Emergencia.lnk
PAGU 	- Gerenciamento de Unidade.lnk
PARA 	- Gerenciamento Ambulatorial.lnk
PARI 	- Gerenciamento de Internacao.lnk
PSDI 	- Diagnostico por Imagem.lnk
PSND 	- Nutricao.lnk
PSSD 	- Controle de SADT.lnk
SGU 	- Gerenciamento de Usuarios.lnk



PRODUTOS
SMA-PEP - Novo Prontuario Eletronico do Paciente Web
PEP - Prontuario Eletronico do Paciente
PAGU - GERENCIAMENTO DE UNIDADE
DIAGN-LAB - LAUDOS DE LABORATORIO NA WEB
SMA-CID - PRONTUARIO ELETRONICO CIDAD�O
APOIO - SISTEMAS DE APOIO
CONTR-ORC - CONTROLADORIA-ORCAMENTO
GLOBAL - Global
FWATX - FRAMEWORK UTILZADO NO SOULMV
FWMV - FRAMEWORK DOS PRODUTOS MV
FWPEP - FRAMEWORK DO PEP 1.0
SUPRI-COMP - SUPRIMENTOS-COMPRASWEB
FATUR-CONV - FATURAMENTO-CONVENIO
FATUR-SUS - FATURAMENTO-SUS
LIBERTY - SOUL MV LIBERTY
SMA-PAGU - CONFIGURA��ES DO PEP (PAGU SOULMV)
GECOTA - GECOTA
CLASRISCO - CLASSIFICACAO DE RISCO
INTER - Internacao
DIAGN - Diagnostico


************************************************

SELECT *
-- DELETE 
FROM dbasgu.pesquisa_menu_imagem 
WHERE  cd_pesq_menu_modulo IN (SELECT cd_pesq_menu_modulo 
                               FROM   dbasgu.pesquisa_menu_modulo 
                               WHERE 
       cd_pesquisa_menu IN (SELECT cd_pesquisa_menu 
                            FROM   dbasgu.pesquisa_menu 
                            WHERE 
       cd_menu IN (SELECT cd_menu 
                   FROM   dbasgu.menu 
                   WHERE  cd_menu_pai IS NULL 
                          AND cd_modulo IS NOT NULL 
                  ))) 

/ 
DELETE dbasgu.pesquisa_menu_palavra_chave 
WHERE  cd_pesq_menu_modulo IN (SELECT cd_pesq_menu_modulo 
                               FROM   dbasgu.pesquisa_menu_modulo 
                               WHERE 
       cd_pesquisa_menu IN (SELECT cd_pesquisa_menu 
                            FROM   dbasgu.pesquisa_menu 
                            WHERE 
       cd_menu IN (SELECT cd_menu 
                   FROM   dbasgu.menu 
                   WHERE  cd_menu_pai IS NULL 
                          AND cd_modulo IS NOT NULL 
                  ))) 

/ 
DELETE FROM dbasgu.pesquisa_menu_modulo 
WHERE  cd_pesquisa_menu IN (SELECT cd_pesquisa_menu 
                            FROM   dbasgu.pesquisa_menu 
                            WHERE  cd_menu IN (SELECT cd_menu 
                                               FROM   dbasgu.menu 
                                               WHERE  cd_menu_pai IS NULL 
                                                      AND cd_modulo IS NOT NULL) 
                           ) 

/ 
DELETE dbasgu.pesquisa_menu 
WHERE  cd_menu IN (SELECT cd_menu 
                   FROM   dbasgu.menu 
                   WHERE  cd_menu_pai IS NULL 
                          AND cd_modulo IS NOT NULL) 

/ 

DELETE FROM dbasgu.menu 
WHERE  cd_menu_pai IS NULL 
       AND cd_modulo IS NOT NULL 

/
 
DELETE FROM dbasgu.menu B 
WHERE  cd_menu_pai IS NULL 
       AND cd_modulo IS NULL 
       AND NOT EXISTS (SELECT 1 
                       FROM   dbasgu.menu A 
                       WHERE  A.cd_menu_pai = B.cd_menu) 

/ 

