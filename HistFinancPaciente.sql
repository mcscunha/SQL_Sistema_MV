SELECT 
    c.cd_itcon_rec,
    b.cd_con_rec,
    B.CD_ATENDIMENTO,
    E.CD_PRO_FAT,
    A.DT_ALTA,
    F.DS_PRO_FAT,
    A.CD_PACIENTE,
    D.NM_PACIENTE,
    E.DT_FECHAMENTO DT_PAGAMENTO,
    E.QT_LANCAMENTO,
    E.VL_UNITARIO,
    B.VL_PREVISTO TOTAL_PAGO,
    NVL(B.VL_DESCONTO, 0) DESCONTO,
    E.CD_PRESTADOR,
    E.CD_CONVENIO,
    CASE
        WHEN E.TP_PAGAMENTO = 'P' THEN 'Particular'
        WHEN E.TP_PAGAMENTO = 'F' THEN 'Fornecedor'
        WHEN E.TP_PAGAMENTO = 'C' THEN 'Convenio'
        ELSE 'Não Identificado = ''' || E.TP_PAGAMENTO || ''''
    END TIPO_PAGAMENTO,
    case 
        when c.tp_quitacao = 'V' then 'Previsto'
        when c.tp_quitacao = 'C' then 'Comprometido'
        when c.tp_quitacao = 'P' then 'Parcialmente quitado'
        when c.tp_quitacao = 'Q' then 'Quitado'
        when c.tp_quitacao = 'L' then 'Cancelado'
        when c.tp_quitacao = 'R' then 'Protestado'
        when c.tp_quitacao = 'G' then 'Quitado com glosa'
        else 'NAO IDENTIFICADO: ' || c.tp_quitacao
    end Quitacao,
    case
        when B.tp_con_rec = 'C' then 'Convenio'
        when B.tp_con_rec = 'P' then 'Paciente'
        when B.tp_con_rec = 'F' then 'Funcionario'
        when B.tp_con_rec = 'A' then 'Cartao de Credito'
        when B.tp_con_rec = 'D' then 'Diversos'
        when B.tp_con_rec = 'M' then 'Mensalidade'
        when B.tp_con_rec = 'R' then 'Farmacia'
        else 'NAO IDENTIFICADO: ' || B.TP_CON_REC
    end TIPO_CONTA_RECEBER,
    (select '| ' ||
        case when V."1" is not null then 'Cheque | ' end ||
        case when V."2" is not null then 'Cartao | ' end ||
        case when V."3" is not null then 'Dinheiro | ' end ||
        case when V."4" is not null then 'Credito C/C | ' end ||
        case when V."5" is not null then 'Bordero | ' end ||
        case when V."6" is not null then 'Boleto | ' end ||
        case when V."7" is not null then 'DOC | ' end ||
        case when V."8" is not null then 'Duplicata | ' end ||
        case when V."9" is not null then 'Nota promissoria | ' end ||
        case when V."10" is not null then 'TEF' end 
    from 
        (
            select *
            from 
                (select distinct 
                    cd_itcon_rec ID,
                    A.tp_recebimento TP
                 from
                    DBAMV.reccon_rec A
                 where 
                    a.cd_itcon_rec = C.CD_ITCON_REC
                )
            pivot (
               sum(TP) for TP in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
            )
        ) V
    ) FORMA_PAGAMENTO,
    (select count(ds_reccon_rec)
    from DBAMV.reccon_rec 
    where cd_itcon_rec = C.CD_ITCON_REC) NUM_PARCELAS,
    
    (select min(nvl(dt_cheque, dt_recebimento))
    from DBAMV.reccon_rec 
    where cd_itcon_rec = C.CD_ITCON_REC) PRIMEIRO_PAGAMENTO,
    
    (select max(nvl(dt_cheque, dt_recebimento))
    from DBAMV.reccon_rec 
    where cd_itcon_rec = C.CD_ITCON_REC) ULTIMO_PAGAMENTO

FROM ATENDIME A
JOIN CON_REC B 
     ON B.CD_ATENDIMENTO = A.CD_ATENDIMENTO
JOIN ITCON_REC C 
     ON C.CD_CON_REC = B.CD_CON_REC
JOIN PACIENTE D
     ON D.CD_PACIENTE = A.CD_PACIENTE
JOIN ITREG_AMB E
     ON E.CD_ATENDIMENTO = A.CD_ATENDIMENTO
JOIN PRO_FAT F
     ON F.CD_PRO_FAT = E.CD_PRO_FAT
/*
EXCLUIDO POR NAO ENCONTRAR RELACAO ENTRE AS TABELAS ENVOLVIDAS
LEFT JOIN RECCON_REC G
     ON G.CD_ITCON_REC = C.CD_ITCON_REC
     AND G.CD_CON_REC_LOTE = B.CD_CON_REC
*/
WHERE A.CD_PACIENTE = 107172
      AND E.Sn_Pertence_Pacote = 'N'
ORDER BY
      A.CD_ATENDIMENTO
      , F.CD_PRO_FAT
;