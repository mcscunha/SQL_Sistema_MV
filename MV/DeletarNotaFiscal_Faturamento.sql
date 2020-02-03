-- Este é o numero da NF passada pelo usuario
select a.sn_rps_gerada, a.* from DBAMV.nota_fiscal a 
where nr_id_nota_fiscal in (420);

--
-- CUIDADO: Nao sao os mesmos codigos usados no SELECT acima
--          Deve-se descobrir estes numeros com o SELECT acima
select * from NOTA_FISCAL_TRIBUTO where cd_nota_fiscal in (444);
select * from ITFAT_NOTA_FISCAL where cd_nota_fiscal in (444);


--
-- DELETAR registros filhos
--
delete ITFAT_NOTA_FISCAL where cd_nota_fiscal in (444);
delete from NOTA_FISCAL_TRIBUTO where cd_nota_fiscal in (444);

--
-- CUIDADO: Nao repetir os codigos usados acima
--          Deletar registro pai
delete from DBAMV.nota_fiscal where nr_id_nota_fiscal in (420);
