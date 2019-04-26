SELECT DISTINCT
    a.cd_reg_amb,
    a.cd_lancamento,
    b.cd_atendimento,
    a.cd_pro_fat,
    g.dt_alta,
    i.ds_pro_fat,
    g.cd_paciente,
    h.nm_paciente,
    f.dt_recebimento,
    a.qt_lancamento,
    a.vl_unitario,
    b.vl_previsto     total_pago,
    nvl(b.vl_desconto, 0) desconto,
    a.cd_prestador,
    a.cd_convenio,
    a.tp_pagamento,
    CASE
        WHEN a.tp_pagamento = 'P' THEN
            'Particular'
        WHEN A.tp_pagamento = 'F' THEN
            'Fornecedor'
        WHEN a.tp_pagamento = 'C' THEN
            'Convenio'
        ELSE
            'Não Identificado = '''
            || a.tp_pagamento || ''''
    END tipo_pagamento,
    f.ds_reccon_rec   forma_pagamento,
    f.nm_responsavel,
    e.nr_parcela      num_parcelas
FROM
    reccon_rec   f
    JOIN itcon_rec    e ON e.cd_itcon_rec = f.cd_itcon_rec
    JOIN con_rec      b ON b.cd_con_rec = e.cd_con_rec
    JOIN atendime     g ON g.cd_atendimento = b.cd_atendimento
    JOIN paciente     h ON h.cd_paciente = g.cd_paciente
    JOIN itreg_amb    a ON a.cd_atendimento = g.cd_atendimento
                        AND a.cd_reg_amb = b.cd_reg_amb
                        AND a.cd_prestador = g.cd_prestador
    JOIN pro_fat      i ON i.cd_pro_fat = a.cd_pro_fat
WHERE
    g.cd_paciente = 107172;

