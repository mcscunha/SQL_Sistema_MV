-- ORACLE
-- Criar a tabela no oracle para receber os dados da consulta feita no SQLServer
create table DBAMV.ti_pac_mais_5_anos (
    cd_paciente integer,
    nm_paciente varchar2(100),
    dt_ultima_visita date
);

-- Apagar a tabela se precisar
-- drop table ti_pac_mais_5_anos;

-- Confirmar se um paciente qualquer se encontra na tabela criada
select * from DBAMV.ti_pac_mais_5_anos where cd_paciente = 70099;

--
-- Executar a comparacao e ver quais pacientes nao aparecem na clinica a mais de 5 anos
-- CUIDADO com a data no WHERE, deve ser o PROXIMO DIA da consulta usada no SQLServer
--
SELECT distinct 
    cd_paciente,
    max(dt_ultima_visita) dt_ultvisita
FROM
    dbamv.ti_pac_mais_5_anos
WHERE
    cd_paciente NOT IN (
        SELECT DISTINCT
            cd_paciente
        FROM
            dbamv.atendime
        WHERE
            dt_atendimento >= '01/01/2015'
    )
    --and cd_paciente in (70812, 70856, 70940, 70713, 69649, 69724, 69747, 69898, 69950) -- Deve aparecer todos na listagem
    --and cd_paciente in (69864)  -- Nao deve aparecer na listagem
group by
    cd_paciente
ORDER BY
    cd_paciente;
    

