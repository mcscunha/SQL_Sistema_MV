SELECT 
  to_number(To_Char(DT_PREVISTA_RECEBIMENTO,'dd')) Dia
  , 'A Receber' Tipo
  , Sum(itcon_rec.VL_DUPLICATA) valor
FROM dbamv.con_rec
  , dbamv.itcon_rec
  , dbamv.fornecedor
WHERE con_rec.cd_con_rec = itcon_rec.cd_con_rec
  AND con_rec.cd_fornecedor = fornecedor.cd_fornecedor
  AND con_rec.cd_multi_empresa IN (1) 
  AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
  AND DT_PREVISTA_RECEBIMENTO BETWEEN Trunc(SYSDATE) AND Trunc(SYSDATE) + 30
  AND itcon_rec.DT_CANCELAMENTO IS NULL
GROUP BY To_Char(DT_PREVISTA_RECEBIMENTO,'dd')

UNION ALL

SELECT
  --To_char(to_date('01/' || to_char(sysdate, 'mm/yyyy'))-1) Dia, -- Pegar o primeiro dia do mes corrente
  --'1 - Vencidos' CLASSE,
  0 Dia, 
  'A Pagar',  
  sum(
    CASE
      WHEN trunc((trunc(trunc(SYSDATE)) - trunc(i.dt_vencimento))) > 0 THEN (
        nvl(i.vl_duplicata, 0) + dbamv.pack_calc_detalhamento.fnc_fncp_calc_imposto_parcela(
          i.cd_itcon_pag,
          trunc(SYSDATE),
          c.cd_multi_empresa
        ) - nvl(p.vl_soma_pago, 0)
      )
      ELSE 0
    END
  ) ACUMULADO
FROM
  (
    SELECT
      pagamento.cd_itcon_pag cd_itcon_pag,
      SUM(nvl(pagamento.vl_pago, 0)) vl_soma_pago
    FROM
      (
        SELECT
          pagcon_pag.cd_itcon_pag,
          (
            nvl(pagcon_pag.vl_pago, 0) + nvl(pagcon_pag.vl_desconto, 0) - nvl(pagcon_pag.vl_acrescimo, 0) + nvl(pagcon_pag.vl_imposto, 0) + nvl(imp_vcto.vl_imposto_vcto, 0)
          ) vl_pago
        FROM
          dbamv.pagcon_pag,
          (
            -- IMPOSTO PREVISTO
            SELECT
              it.cd_itcon_pag,
              SUM(c_filho.vl_bruto_conta) vl_imposto_vcto
            FROM
              dbamv.con_pag c_filho,
              dbamv.con_pag c_pai,
              dbamv.itcon_pag it,
              dbamv.tip_detcon_pag td,
              dbamv.tip_detalhe t,
              dbamv.processo p
            WHERE
              c_filho.dt_lancamento <= trunc(SYSDATE)
              AND c_pai.cd_con_pag = it.cd_con_pag
              AND c_filho.cd_con_pag = td.cd_con_pag_filho
              AND td.cd_con_pag_pai = c_pai.cd_con_pag
              AND t.cd_detalhamento = td.cd_detalhamento
              AND t.tp_data = 'V'
              AND c_filho.cd_processo = p.cd_processo
              AND p.cd_estrutural = '1.1.1.1.3'
            GROUP BY
              it.cd_itcon_pag
          ) imp_vcto
        WHERE
          pagcon_pag.cd_itcon_pag = imp_vcto.cd_itcon_pag (+)
          AND trunc(pagcon_pag.dt_pagamento) <= trunc(SYSDATE)
          AND (
            pagcon_pag.dt_estorno IS NULL
            OR (
              pagcon_pag.dt_estorno IS NOT NULL
              AND trunc(pagcon_pag.dt_estorno) > trunc(SYSDATE)
            )
          )
      ) pagamento
    GROUP BY
      pagamento.cd_itcon_pag
  ) p,
  dbamv.con_pag c,
  dbamv.itcon_pag i,
  dbamv.fornecedor f,
  (
    SELECT
      cp.cd_con_pag,
      cp.dt_lancamento
    FROM
      dbamv.con_pag cp
    WHERE
      cp.cd_processo IN (
        SELECT
          cd_processo
        FROM
          dbamv.processo
        WHERE
          cd_multi_empresa IN (1)
          AND cd_estrutural IN ('1.2.1.1.5')
      )
      AND trunc(cp.dt_lancamento) <= trunc(trunc(SYSDATE))
  ) agrupamento,
  (
    SELECT
      tip.cd_con_pag_pai cd_con_pag,
      SUM(nvl(tip.vl_detalhamento, 0)) vl_detalhamento
    FROM
      dbamv.tip_detcon_pag tip
    WHERE
      tip.cd_pagcon_pag IS NULL
      AND EXISTS (
        SELECT
          'X'
        FROM
          dbamv.tip_detalhe td
        WHERE
          td.tp_data = 'V'
          AND td.cd_detalhamento = tip.cd_detalhamento
      )
    GROUP BY
      tip.cd_con_pag_pai
  ) imp_v
WHERE
  c.cd_con_pag = i.cd_con_pag
  AND c.cd_fornecedor = f.cd_fornecedor
  AND c.cd_con_pag = imp_v.cd_con_pag (+)
  AND p.cd_itcon_pag (+) = i.cd_itcon_pag
  AND c.cd_multi_empresa IN (1)
  AND i.cd_con_pag_agrup = agrupamento.cd_con_pag (+)
  AND c.vl_bruto_conta > 0
  AND trunc(c.dt_lancamento) <= trunc(SYSDATE)
  AND c.cd_processo NOT IN (
    SELECT
      cd_processo
    FROM
      dbamv.processo
    WHERE
      cd_multi_empresa = c.cd_multi_empresa
      AND cd_estrutural IN ('1.2.1.1.5', '2.1.1.1.3')
  ) --AND c.cd_fornecedor = 76
--group by
--  To_char(to_date('01/' || to_char(sysdate, 'mm/yyyy'))-1)

UNION

SELECT
  to_number(to_char(i.dt_vencimento, 'dd')) Dia,
  'A Pagar',  --  '2 - Ate o fim deste mes' CLASSE,
  sum(
    CASE
      WHEN abs(trunc(trunc(SYSDATE)) - trunc(i.dt_vencimento)) BETWEEN 0 AND Trunc(last_day(SYSDATE) - sysdate) THEN (
        nvl(i.vl_duplicata, 0) + dbamv.pack_calc_detalhamento.fnc_fncp_calc_imposto_parcela(
          i.cd_itcon_pag,
          trunc(SYSDATE),
          c.cd_multi_empresa
        ) - nvl(p.vl_soma_pago, 0)
      )
      ELSE 0
    END
  ) ACUMULADO
FROM
  (
    SELECT
      pagamento.cd_itcon_pag cd_itcon_pag,
      SUM(nvl(pagamento.vl_pago, 0)) vl_soma_pago
    FROM
      (
        SELECT
          pagcon_pag.cd_itcon_pag,
          (
            nvl(pagcon_pag.vl_pago, 0) + nvl(pagcon_pag.vl_desconto, 0) - nvl(pagcon_pag.vl_acrescimo, 0) + nvl(pagcon_pag.vl_imposto, 0) + nvl(imp_vcto.vl_imposto_vcto, 0)
          ) vl_pago
        FROM
          dbamv.pagcon_pag,
          (
            -- IMPOSTO PREVISTO
            SELECT
              it.cd_itcon_pag,
              SUM(c_filho.vl_bruto_conta) vl_imposto_vcto
            FROM
              dbamv.con_pag c_filho,
              dbamv.con_pag c_pai,
              dbamv.itcon_pag it,
              dbamv.tip_detcon_pag td,
              dbamv.tip_detalhe t,
              dbamv.processo p
            WHERE
              c_filho.dt_lancamento <= trunc(SYSDATE)
              AND c_pai.cd_con_pag = it.cd_con_pag
              AND c_filho.cd_con_pag = td.cd_con_pag_filho
              AND td.cd_con_pag_pai = c_pai.cd_con_pag
              AND t.cd_detalhamento = td.cd_detalhamento
              AND t.tp_data = 'V'
              AND c_filho.cd_processo = p.cd_processo
              AND p.cd_estrutural = '1.1.1.1.3'
            GROUP BY
              it.cd_itcon_pag
          ) imp_vcto
        WHERE
          pagcon_pag.cd_itcon_pag = imp_vcto.cd_itcon_pag (+)
          AND trunc(pagcon_pag.dt_pagamento) <= trunc(SYSDATE)
          AND (
            pagcon_pag.dt_estorno IS NULL
            OR (
              pagcon_pag.dt_estorno IS NOT NULL
              AND trunc(pagcon_pag.dt_estorno) > trunc(SYSDATE)
            )
          )
      ) pagamento
    GROUP BY
      pagamento.cd_itcon_pag
  ) p,
  dbamv.con_pag c,
  dbamv.itcon_pag i,
  dbamv.fornecedor f,
  (
    SELECT
      cp.cd_con_pag,
      cp.dt_lancamento
    FROM
      dbamv.con_pag cp
    WHERE
      cp.cd_processo IN (
        SELECT
          cd_processo
        FROM
          dbamv.processo
        WHERE
          cd_multi_empresa IN (1)
          AND cd_estrutural IN ('1.2.1.1.5')
      )
      AND trunc(cp.dt_lancamento) <= trunc(trunc(SYSDATE))
  ) agrupamento,
  (
    SELECT
      tip.cd_con_pag_pai cd_con_pag,
      SUM(nvl(tip.vl_detalhamento, 0)) vl_detalhamento
    FROM
      dbamv.tip_detcon_pag tip
    WHERE
      tip.cd_pagcon_pag IS NULL
      AND EXISTS (
        SELECT
          'X'
        FROM
          dbamv.tip_detalhe td
        WHERE
          td.tp_data = 'V'
          AND td.cd_detalhamento = tip.cd_detalhamento
      )
    GROUP BY
      tip.cd_con_pag_pai
  ) imp_v
WHERE
  c.cd_con_pag = i.cd_con_pag
  AND c.cd_fornecedor = f.cd_fornecedor
  AND c.cd_con_pag = imp_v.cd_con_pag (+)
  AND p.cd_itcon_pag (+) = i.cd_itcon_pag
  AND c.cd_multi_empresa IN (1)
  AND i.cd_con_pag_agrup = agrupamento.cd_con_pag (+)
  AND c.vl_bruto_conta > 0
  AND trunc(c.dt_lancamento) <= trunc(SYSDATE)
  AND c.cd_processo NOT IN (
    SELECT
      cd_processo
    FROM
      dbamv.processo
    WHERE
      cd_multi_empresa = c.cd_multi_empresa
      AND cd_estrutural IN ('1.2.1.1.5', '2.1.1.1.3')
  ) --AND c.cd_fornecedor = 76
group by
  to_char(i.dt_vencimento, 'dd')
;