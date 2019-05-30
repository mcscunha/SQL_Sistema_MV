--
-- Recuperar as linhas de codigo q compoem este objeto
-- Ajuda a encontrar o comando relacionado a linha de erro informada pelo Oracle
--
select *
from all_source
where name = 'PKG_FSCC_REGISTRA_LOG_AVICIR';

-- Outra forma de fazer a mesma coisa acima
-- (Nao consegui o mesmo resultado - acho q os parametros estao errados)
SELECT dbms_metadata.get_ddl('PACKAGE', 'PKG_MV2000') FROM DUAL;

-- 
-- Lista se a procedure está cadastrada no banco
--
select *
from all_procedures
where owner = 'DBAMV' 
  --object_name = 'packagename'
  AND PROCEDURE_NAME= 'PRC_REGISTRA_EVO_AVICIR';


