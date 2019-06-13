-- ------------------------------------
-- MELHOR FORMA!!
-- ------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS myProc$$
CREATE PROCEDURE myProc()
BEGIN
DECLARE i INT default 1;
WHILE i<=100 DO
    INSERT INTO tbCliente(nome,numero) values ('Nomes',i);
    SET i=i+1;
END WHILE;
END$$

DELIMITER ;
call myProc();


-- ------------------------------------
-- FORMA MAIS SIMPLES
-- ------------------------------------
insert into DBAMV.REGRA_SUBSTITUICAO_PROCED 
    (
        CD_CONVENIO,
        CD_REGRA_SUBSTITUICAO_PROCED,
        CD_CON_PLA,
        CD_MULTI_EMPRESA,
        CD_PRO_FAT,
        CD_PRO_FAT_SUBSTITUTO,
        CD_REGRA,
        CD_SETOR,
        DS_UNIDADE_XML,
        DT_VIGENCIA,
        TP_ATENDIMENTO,
        TP_FATOR,
        VL_FATOR_DIVISAO,
        VL_FATOR_MULTIPLICACAO
    ) 
        (select 
            73,
            (select max(CD_REGRA_SUBSTITUICAO_PROCED) from DBAMV.REGRA_SUBSTITUICAO_PROCED) + ROWNUM,
            CD_CON_PLA,
            CD_MULTI_EMPRESA,
            CD_PRO_FAT,
            CD_PRO_FAT_SUBSTITUTO,
            CD_REGRA,
            CD_SETOR,
            DS_UNIDADE_XML,
            DT_VIGENCIA,
            TP_ATENDIMENTO,
            TP_FATOR,
            VL_FATOR_DIVISAO,
            VL_FATOR_MULTIPLICACAO
        from DBAMV.REGRA_SUBSTITUICAO_PROCED
        where cd_convenio = 40)
;    

commit;


-- ------------------------------------
-- Outra Forma
-- ------------------------------------

-- Forma de criar a sequencia
create sequence seq_decrescente_5
    start with 5        -- Primeiro valor a ser usado
    increment by -1     -- Incremento
    maxvalue 5          -- Valor maximo
    minvalue 0          -- Valor minimo
    nocache             -- Guardar a sequencia na coluna LAST_NUMBER do dicionario (user_sequences)
    cycle;              -- Ciclar os numeros, quando chegar em ZERO, recomecar

-- Criar uma sequencia, iniciando do 1
create sequence seq_emp_id nocache;
-- Ver qual o numero posicionado para ser usado
select seq_emp_id.currval from dual;
-- Usar o numero da sequencia
select seq_emp_id.nextval from dual;

