--consulta por paciente
select 
       Sum((Dbamv.Prod_Atend.Qt_Saida-Dbamv.Prod_Atend.Qt_Devolvida)*DBAMV.PRODUTO.VL_CUSTO_MEDIO)as custo_mat_med

from Dbamv.Prod_Atend, DBAMV.PRODUTO

where 
     Dbamv.Prod_Atend.Cd_Produto = DBAMV.PRODUTO.cd_produto
     and Dbamv.Prod_Atend.Cd_Atendimento = 133573 --codigo atendimento
     
/*
--consulta por unidade de internação

from Dbamv.Prod_Atend 
     ,DBAMV.PRODUTO
     ,DBAMV.UNID_INT

where 
     Dbamv.Prod_Atend.Cd_Produto = DBAMV.PRODUTO.cd_produto
     and Dbamv.Prod_Atend.Cd_Unid_Int = DBAMV.UNID_INT.CD_UNID_INT
group by 
      DBAMV.UNID_INT.DS_UNID_INT
order by custo_mat_med desc
*/   



