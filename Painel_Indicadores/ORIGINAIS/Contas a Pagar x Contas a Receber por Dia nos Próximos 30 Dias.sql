SELECT
  to_number(dia) dia,
  Tipo,
  Round(valor / 100) Valor
FROM
  (
    SELECT
      To_Char(DT_PREVISTA_RECEBIMENTO, 'dd') Dia,
      'A Receber' Tipo,
      Sum(itcon_rec.VL_DUPLICATA) valor
    FROM
      dbamv.con_rec,
      dbamv.itcon_rec,
      dbamv.fornecedor
    WHERE
      con_rec.cd_con_rec = itcon_rec.cd_con_rec
      AND con_rec.cd_fornecedor = fornecedor.cd_fornecedor
      AND con_rec.cd_multi_empresa IN (1)
      AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
      AND DT_PREVISTA_RECEBIMENTO BETWEEN Trunc(SYSDATE)
      AND Trunc(SYSDATE) + 30
      AND itcon_rec.DT_CANCELAMENTO IS NULL
    GROUP BY
      To_Char(DT_PREVISTA_RECEBIMENTO, 'dd')
    UNION ALL
    SELECT
      To_Char(itcon_pag.dt_vencimento, 'dd') dia,
      'A Pagar' Tipo,
      Sum(
        itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0)
      ) vl_a_pagar
    FROM
      dbamv.itcon_pag,
      dbamv.con_pag
    WHERE
      con_pag.cd_con_pag = itcon_pag.cd_con_pag
      AND itcon_pag.tp_quitacao not in ('Q', 'N', 'T', 'L')
      AND con_pag.cd_multi_empresa IN (1)
      AND itcon_pag.cd_con_pag_agrup IS NULL
      AND con_pag.cd_previsao IS NULL
      AND itcon_pag.dt_vencimento BETWEEN trunc(sysdate)
      AND trunc(sysdate) + 30
      AND itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0) > 0
    GROUP BY
      To_Char(itcon_pag.dt_vencimento, 'dd')
  )
ORDER BY
  to_number(dia),
  tipo