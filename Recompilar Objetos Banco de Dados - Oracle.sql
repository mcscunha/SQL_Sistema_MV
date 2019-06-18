-- -----------------------------------
-- PRIMEIRA Forma
-- -----------------------------------

select 'alter '||object_type||' '||owner||'.'||object_name||' compile '||object_type||';'
from dba_objects where status = 'INVALID' and object_type = 'PACKAGE';

select 'alter '||object_type||' '||owner||'.'||object_name||' compile BODY;'
from dba_objects where status = 'INVALID' and object_type in ('PACKAGE BODY','TYPE','TYPE BODY','');

select 'alter '||object_type||' '||owner||'.'||object_name||' compile;'
from dba_objects where status = 'INVALID' and object_type in ('VIEW','SYNONYM','TRIGGER','PROCEDURE','FUNCTION','INDEXTYPE','INDEX','OPERATOR');


-- -----------------------------------
-- SEGUNDA Forma
-- -----------------------------------
SELECT 
    'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME ||
	CASE
	   WHEN OBJECT_TYPE = 'PACKAGE BODY' THEN ' COMPILE BODY;'
	   ELSE ' COMPILE;'
	END
FROM DBA_OBJECTS U
WHERE STATUS <> 'VALID'
  AND OWNER <> 'SYS'
  AND U.OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE BODY','PACKAGE');


-- -----------------------------------
-- TERCEIRA Forma
-- -----------------------------------
/*
Compilação por script SQL
O Oracle possui um script em seu diretório $ORACLE_HOME que realiza a 
compilação de todos os objetos inválidos presentes no Banco de Dados.
O script fornece um relatório detalhado das operações executadas pelo
processo de compilação.
*/
-- Ambiente Linux
SQL>@$ORACLE_HOME/rdbms/admin/UTLRP.SQL

-- Ambiente Windows
SQL>@%ORACLE_HOME%/rdbms/admin/UTLRP.SQL
