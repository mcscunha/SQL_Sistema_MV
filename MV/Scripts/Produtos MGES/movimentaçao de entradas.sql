select 
ent_pro.dt_entrada,especie.ds_especie,fornecedor.nm_fornecedor,produto.cd_produto cd_produto, produto.ds_produto ds_produto,sum(itent_pro.qt_entrada) qt_entrada,round(itent_pro.vl_custo_real,2) vl_real,
 round(sum(itent_pro.vl_total),2) vl_total,up.ds_unidade, ent_pro.nr_documento as nota_fiscal, especie.ds_especie, fornecedor.nm_fornecedor
from itent_pro
inner join produto on produto.cd_produto = itent_pro.cd_produto
inner join ent_pro on itent_pro.cd_ent_pro = ent_pro.cd_ent_pro
inner join estoque on estoque.cd_estoque = ent_pro.cd_estoque
inner join uni_pro up on up.cd_uni_pro = itent_pro.cd_uni_pro
inner join fornecedor on fornecedor.cd_fornecedor = ent_pro.cd_fornecedor
inner join especie on especie.cd_especie = produto.cd_especie

where ent_pro.cd_tip_doc = 1
and trunc(ent_pro.dt_entrada) 
between (&< NAME = "Data Inicial" REQUIRED = "YES" TYPE = "DATE"
        DEFAULT = "SELECT TRUNC(SYSDATE) FROM DUAL" >) AND
       (&< NAME = "Data Final" REQUIRED = "YES" TYPE = "DATE"
        DEFAULT = "SELECT TRUNC(SYSDATE) FROM DUAL" >)
--and produto.cd_produto = 6708
group by produto.cd_produto, produto.ds_produto, itent_pro.vl_custo_real,up.ds_unidade,fornecedor.nm_fornecedor,especie.ds_especie,ent_pro.nr_documento,ent_pro.dt_entrada
order by vl_total desc
