PROMPT CREATE OR REPLACE VIEW vdic_auditar_contas
CREATE OR REPLACE VIEW vdic_auditar_contas (
  codigo_da_auditoria,
  usuario_que_auditou,
  codigo_do_atendimento,
  codigo_do_paciente,
  nome_do_paciente,
  data_de_atendimento,
  data_da_alta,
  codigo_do_leito,
  descricao_do_leito,
  codigo_da_conta,
  data_inicial_da_conta,
  data_final_da_conta,
  tipo_da_conta,
  codigo_do_convenio,
  nome_do_convenio,
  numero_da_guia,
  codigo_do_grupo_faturamento,
  descricao_do_grupo_faturamento,
  codigo_do_setor,
  nome_do_setor,
  codigo_do_procedimento,
  descricao_do_procedimento,
  unidade_do_procedimento,
  codigo_grupo_procedimento,
  descricao_grupo_procedimento,
  quantidade_faturada,
  percentual_faturado,
  valor_bruto_faturado,
  quantidade_liberada,
  percentual_liberado,
  valor_bruto_liberado,
  hospital_acordo,
  paciente_paga,
  codigo_motivo_auditoria,
  descricao_motivo_auditoria,
  tipo_do_motivo_da_auditoria,
  origem_do_lancamento,
  valor_glosa,
  data_de_cancelamento,
  usuario_que_cancelou,
  codigo_do_prestador,
  nome_do_prestador,
  codigo_da_atividade_medica,
  descricao_da_atividade_medica,
  forma_de_pagamento,
  cd_atendimento_sus_vinculado,
  cd_multi_empresa,
  data_auditoria
) AS
SELECT auditoria.cd_auditoria_conta codigo_da_auditoria,
          auditoria.cd_usuario_aud usuario_que_auditou,
          atendime.cd_atendimento codigo_do_atendimento,
          atendime.cd_paciente codigo_do_paciente,
          atendime.nm_paciente nome_do_paciente,
          TRUNC (atendime.dt_atendimento) data_de_atendimento,
          TRUNC (atendime.dt_alta) data_da_alta,
          atendime.cd_leito codigo_do_leito,
          atendime.ds_leito descricao_do_leito,
          reg_fat.cd_reg_fat codigo_da_conta,
          TRUNC (reg_fat.dt_inicio) data_inicial_da_conta,
          TRUNC (reg_fat.dt_final) data_final_da_conta,
          'Hospitalar' tipo_da_conta, reg_fat.cd_convenio codigo_do_convenio,
          convenio.nm_convenio nome_do_convenio,
          reg_fat.nr_guia numero_da_guia,
          /* Itens da Auditoria */
          auditoria.cd_gru_fat codigo_do_grupo_faturamento,
          gru_fat.ds_gru_fat descricao_do_grupo_faturamento,
          auditoria.cd_setor codigo_do_setor, setor.nm_setor nome_do_setor,
          itreg_fat.cd_pro_fat codigo_do_procedimento,
          pro_fat.ds_pro_fat descricao_do_procedimento,
          pro_fat.ds_unidade unidade_do_procedimento,
          pro_fat.cd_gru_pro codigo_grupo_procedimento,
          gru_pro.ds_gru_pro descricao_grupo_procedimento,
          itreg_fat_original.qt_lancamento quantidade_faturada,
          itreg_fat_original.vl_percentual_multipla percentual_faturado,
          ROUND
              (  NVL (itreg_fat_original.vl_total_conta, 0)
               - NVL (itreg_fat_original.vl_acrescimo, 0)
               + NVL (itreg_fat_original.vl_desconto, 0),
               2
              ) valor_bruto_faturado,
          itreg_fat.qt_lancamento quantidade_liberada,
          itreg_fat.vl_percentual_multipla percentual_liberado,
          ROUND (  NVL (itreg_fat.vl_total_conta, 0)
                 - NVL (itreg_fat.vl_acrescimo, 0)
                 + NVL (itreg_fat.vl_desconto, 0),
                 2
                ) valor_bruto_liberado,
          auditoria.sn_acordo hospital_acordo,
          auditoria.sn_paciente_paga paciente_paga,
          auditoria.cd_motivo_auditoria codigo_motivo_auditoria,
          motivo.ds_motivo_auditoria descricao_motivo_auditoria,
          DECODE (motivo.tp_motivo_auditoria,
                  'O', 'Operacional',
                  'Auditoria'
                 ) tipo_do_motivo_da_auditoria,
          auditoria.tp_mvto origem_do_lancamento,
          ABS
             (  NVL (ROUND (  NVL (itreg_fat_original.vl_total_conta, 0)
                            - NVL (itreg_fat_original.vl_acrescimo, 0)
                            + NVL (itreg_fat_original.vl_desconto, 0),
                            2
                           ),
                     0
                    )
              - NVL (ROUND (  NVL (itreg_fat.vl_total_conta, 0)
                            - NVL (itreg_fat.vl_acrescimo, 0)
                            + NVL (itreg_fat.vl_desconto, 0),
                            2
                           ),
                     0
                    )
             ) valor_glosa,
          auditoria.dt_cancelou data_de_cancelamento,
          auditoria.cd_usuario_cancelou usuario_que_cancelou,
          /* Dados do Prestador */
          NVL (itreg_fat.cd_prestador,
               itlan_med.cd_prestador
              ) codigo_do_prestador,
          NVL (prestador.nm_prestador,
               itlan_med.nm_prestador
              ) nome_do_prestador,
          NVL (itreg_fat.cd_ati_med,
               itlan_med.cd_ati_med
              ) codigo_da_atividade_medica,
          NVL (ati_med.ds_ati_med,
               itlan_med.ds_ati_med
              ) descricao_da_atividade_medica,
          DECODE (NVL (itreg_fat.tp_pagamento, itlan_med.tp_pagamento),
                  'F', 'Hospital',
                  'C', 'Credenciado',
                  'P', 'Producao',
                  ''
                 ) forma_de_pagamento,
          atendime.CD_ATENDIMENTO_SUS_VINCULADO,
          atendime.cd_multi_empresa,
          auditoria.dt_auditoria
   FROM   dbamv.auditoria_conta auditoria,
          dbamv.motivo_auditoria motivo,
          dbamv.gru_fat,
          dbamv.gru_pro,
          dbamv.setor,
          dbamv.convenio,
          dbamv.pro_fat,
          dbamv.reg_fat,
          dbamv.itreg_fat,
          dbamv.itreg_fat_original,
          dbamv.prestador,
          dbamv.ati_med,
          /* Equipe m¿dica */
          (SELECT itr.cd_reg_fat, itr.cd_lancamento, itl.cd_prestador,
                  itl.cd_ati_med, itl.tp_pagamento, p.nm_prestador,
                  a.ds_ati_med
           FROM   dbamv.itreg_fat itr,
                  dbamv.itlan_med itl,
                  dbamv.prestador p,
                  dbamv.ati_med a
           WHERE  itr.cd_reg_fat = itl.cd_reg_fat
           AND    itr.cd_lancamento = itl.cd_lancamento
           AND    p.cd_prestador = itl.cd_prestador
           AND    a.cd_ati_med = itl.cd_ati_med) itlan_med,
          /* Dados do Atendimento */
          (SELECT a.cd_atendimento, a.cd_paciente, p.nm_paciente,
                  TRUNC (a.dt_atendimento) dt_atendimento,
                  TRUNC (a.dt_alta) dt_alta, a.cd_leito, l.ds_leito,
                  a.cd_multi_empresa, a.CD_ATENDIMENTO_SUS_VINCULADO
           FROM   dbamv.atendime a,
                  dbamv.paciente p,
                  dbamv.leito l
           WHERE  a.cd_paciente = p.cd_paciente
           AND    l.cd_leito(+) = a.cd_leito
           AND    a.cd_multi_empresa =
                         NVL (dbamv.pkg_mv2000.le_empresa, a.cd_multi_empresa)) atendime
   WHERE  motivo.cd_motivo_auditoria = auditoria.cd_motivo_auditoria
   AND    atendime.cd_atendimento = auditoria.cd_atendimento
   AND    reg_fat.cd_reg_fat = auditoria.cd_reg_fat
   AND    itreg_fat.cd_reg_fat = auditoria.cd_reg_fat
   AND    itreg_fat.cd_lancamento = auditoria.cd_lancamento_fat
   AND    itreg_fat_original.cd_reg_fat = auditoria.cd_reg_fat
   AND    itreg_fat_original.cd_lancamento = auditoria.cd_lancamento_fat
   AND    gru_fat.cd_gru_fat(+) = auditoria.cd_gru_fat
   AND    setor.cd_setor(+) = auditoria.cd_setor
   AND    pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat
   AND    gru_pro.cd_gru_pro = pro_fat.cd_gru_pro
   AND    convenio.cd_convenio = reg_fat.cd_convenio
   AND    itlan_med.cd_reg_fat(+) = itreg_fat.cd_reg_fat
   AND    itlan_med.cd_lancamento(+) = itreg_fat.cd_lancamento
   AND    prestador.cd_prestador(+) = itreg_fat.cd_prestador
   AND    ati_med.cd_ati_med(+) = itreg_fat.cd_ati_med
   UNION ALL
   SELECT auditoria.cd_auditoria_conta codigo_da_auditoria,
          auditoria.cd_usuario_aud usuario_que_auditou,
          atendime.cd_atendimento codigo_do_atendimento,
          atendime.cd_paciente codigo_do_paciente,
          atendime.nm_paciente nome_do_paciente,
          TRUNC (atendime.dt_atendimento) data_de_atendimento,
          TRUNC (atendime.dt_alta) data_da_alta,
          atendime.cd_leito codigo_do_leito,
          atendime.ds_leito descricao_do_leito,
          reg_amb.cd_reg_amb codigo_da_conta,
          TRUNC (reg_amb.dt_lancamento) data_inicial_da_conta,
          TRUNC (reg_amb.dt_lancamento_final) data_final_da_conta,
          'Ambulatorial' tipo_da_conta,
          reg_amb.cd_convenio codigo_do_convenio,
          convenio.nm_convenio nome_do_convenio, '' numero_da_guia,
          /* Itens da Auditoria */
          auditoria.cd_gru_fat codigo_do_grupo_faturamento,
          gru_fat.ds_gru_fat descricao_do_grupo_faturamento,
          auditoria.cd_setor codigo_do_setor, setor.nm_setor nome_do_setor,
          itreg_amb.cd_pro_fat codigo_do_procedimento,
          pro_fat.ds_pro_fat descricao_do_procedimento,
          pro_fat.ds_unidade unidade_do_procedimento,
          pro_fat.cd_gru_pro codigo_grupo_procedimento,
          gru_pro.ds_gru_pro descricao_grupo_procedimento,
          itreg_amb_original.qt_lancamento quantidade_faturada,
          itreg_amb_original.vl_percentual_multipla percentual_faturado,
          ROUND
              (  NVL (itreg_amb_original.vl_total_conta, 0)
               - NVL (itreg_amb_original.vl_acrescimo, 0)
               + NVL (itreg_amb_original.vl_desconto, 0),
               2
              ) valor_bruto_faturado,
          itreg_amb.qt_lancamento quantidade_liberada,
          itreg_amb.vl_percentual_multipla percentual_liberado,
          ROUND (  NVL (itreg_amb.vl_total_conta, 0)
                 - NVL (itreg_amb.vl_acrescimo, 0)
                 + NVL (itreg_amb.vl_desconto, 0),
                 2
                ) valor_bruto_liberado,
          auditoria.sn_acordo hospital_acordo,
          auditoria.sn_paciente_paga paciente_paga,
          auditoria.cd_motivo_auditoria codigo_motivo_auditoria,
          motivo.ds_motivo_auditoria descricao_motivo_auditoria,
          DECODE (motivo.tp_motivo_auditoria,
                  'O', 'Operacional',
                  'Auditoria'
                 ) tipo_do_motivo_da_auditoria,
          auditoria.tp_mvto origem_do_lancamento,
          ABS
             (  NVL (ROUND (  NVL (itreg_amb_original.vl_total_conta, 0)
                            - NVL (itreg_amb_original.vl_acrescimo, 0)
                            + NVL (itreg_amb_original.vl_desconto, 0),
                            2
                           ),
                     0
                    )
              - NVL (ROUND (  NVL (itreg_amb.vl_total_conta, 0)
                            - NVL (itreg_amb.vl_acrescimo, 0)
                            + NVL (itreg_amb.vl_desconto, 0),
                            2
                           ),
                     0
                    )
             ) valor_glosa,
          auditoria.dt_cancelou data_de_cancelamento,
          auditoria.cd_usuario_cancelou usuario_que_cancelou,
          /* Dados do Prestador */
          itreg_amb.cd_prestador codigo_do_prestador,
          prestador.nm_prestador nome_do_prestador,
          itreg_amb.cd_ati_med codigo_da_atividade_medica,
          ati_med.ds_ati_med descricao_da_atividade_medica,
          DECODE (itreg_amb.tp_pagamento,
                  'F', 'Hospital',
                  'C', 'Credenciado',
                  'P', 'Producao',
                  ''
                 ) forma_de_pagamento,
          atendime.CD_ATENDIMENTO_SUS_VINCULADO,
          atendime.cd_multi_empresa,
          auditoria.dt_auditoria
   FROM   dbamv.auditoria_conta auditoria,
          dbamv.motivo_auditoria motivo,
          dbamv.gru_fat,
          dbamv.gru_pro,
          dbamv.setor,
          dbamv.convenio,
          dbamv.pro_fat,
          dbamv.reg_amb,
          dbamv.itreg_amb,
          dbamv.itreg_amb_original,
          dbamv.prestador,
          dbamv.ati_med,
          /* Dados do Atendimento */
          (SELECT a.cd_atendimento, a.cd_paciente, p.nm_paciente,
                  TRUNC (a.dt_atendimento) dt_atendimento,
                  TRUNC (a.dt_alta) dt_alta, a.cd_leito, l.ds_leito,
                  a.cd_multi_empresa, a.CD_ATENDIMENTO_SUS_VINCULADO
           FROM   dbamv.atendime a,
                  dbamv.paciente p,
                  dbamv.leito l
           WHERE  a.cd_paciente = p.cd_paciente
           AND    l.cd_leito(+) = a.cd_leito
           AND    a.cd_multi_empresa =
                         NVL (dbamv.pkg_mv2000.le_empresa, a.cd_multi_empresa)) atendime
   WHERE  motivo.cd_motivo_auditoria = auditoria.cd_motivo_auditoria
   AND    atendime.cd_atendimento = auditoria.cd_atendimento
   AND    reg_amb.cd_reg_amb = auditoria.cd_reg_amb
   AND    itreg_amb.cd_reg_amb = auditoria.cd_reg_amb
   AND    itreg_amb.cd_lancamento = auditoria.cd_lancamento_amb
   AND    itreg_amb_original.cd_reg_amb = auditoria.cd_reg_amb
   AND    itreg_amb_original.cd_lancamento = auditoria.cd_lancamento_amb
   AND    gru_fat.cd_gru_fat(+) = auditoria.cd_gru_fat
   AND    setor.cd_setor(+) = auditoria.cd_setor
   AND    pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
   AND    gru_pro.cd_gru_pro = pro_fat.cd_gru_pro
   AND    convenio.cd_convenio = reg_amb.cd_convenio
   AND    prestador.cd_prestador(+) = itreg_amb.cd_prestador
   AND    ati_med.cd_ati_med(+) = itreg_amb.cd_ati_med
/

COMMENT ON TABLE vdic_auditar_contas IS 'Esta view cont¿m todos os dados referentes ¿ auditorias de contas, tanto auditoria operacional como a auditoria
feita pelo sistema FFAG.
-
O tipo da auditoria pode ser verificado atrav¿s da coluna TIPO_DO_MOTIVO_DA_AUDITORIA que estar¿ preenchida com um
destes dois valores : Operacional ou Auditoria.
-
Podem ser utilizados diversos filtros, tais como:
CODIGO_DO_ATENDIMENTO,
CODIGO_DO_PACIENTE,
DATA_DE_ATENDIMENTO,
CODIGO_DA_CONTA,
CODIGO_DO_CONVENIO,
CODIGO_DO_SETOR,
como tamb¿m pelo per¿odo da conta :
   DATA_INICIAL_DA_CONTA e DATA_FINAL_DA_CONTA.
-
Esta view, como as demais, ¿ Anal¿tica, contendo para cada registro de auditoria todos os itens auditados.
Na montagem dos relat¿rios deve-se levar em considera¿¿o o correto agrupamento das informa¿¿es.';

COMMENT ON COLUMN vdic_auditar_contas.codigo_da_auditoria IS 'C¿digo sequencial da auditoria';
COMMENT ON COLUMN vdic_auditar_contas.usuario_que_auditou IS 'Usu¿rio que fez a auditoria';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_atendimento IS 'C¿digo do atendimento';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_paciente IS 'C¿digo do paciente (prontu¿rio)';
COMMENT ON COLUMN vdic_auditar_contas.nome_do_paciente IS 'Nome do paciente';
COMMENT ON COLUMN vdic_auditar_contas.data_de_atendimento IS 'Data do atendimento';
COMMENT ON COLUMN vdic_auditar_contas.data_da_alta IS 'Data de alta';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_leito IS 'C¿digo do leito';
COMMENT ON COLUMN vdic_auditar_contas.descricao_do_leito IS 'Descri¿¿o do leito';
COMMENT ON COLUMN vdic_auditar_contas.codigo_da_conta IS 'C¿digo da conta hospitalar ou lote ambulatorial';
COMMENT ON COLUMN vdic_auditar_contas.data_inicial_da_conta IS 'Periodo inicial da conta';
COMMENT ON COLUMN vdic_auditar_contas.data_final_da_conta IS 'Periodo final da conta';
COMMENT ON COLUMN vdic_auditar_contas.tipo_da_conta IS 'Tipo da conta';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_convenio IS 'C¿digo do conv¿nio';
COMMENT ON COLUMN vdic_auditar_contas.nome_do_convenio IS 'Nome do conv¿nio';
COMMENT ON COLUMN vdic_auditar_contas.numero_da_guia IS 'N¿mero da guia';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_grupo_faturamento IS 'C¿digo do grupo de faturamento';
COMMENT ON COLUMN vdic_auditar_contas.descricao_do_grupo_faturamento IS 'Descri¿¿o do grupo de faturamento';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_setor IS 'C¿digo do setor';
COMMENT ON COLUMN vdic_auditar_contas.nome_do_setor IS 'Nome do setor';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_procedimento IS 'C¿digo do procedimento';
COMMENT ON COLUMN vdic_auditar_contas.descricao_do_procedimento IS 'Descri¿¿o do procedimento';
COMMENT ON COLUMN vdic_auditar_contas.unidade_do_procedimento IS 'Unidade do procedimento';
COMMENT ON COLUMN vdic_auditar_contas.codigo_grupo_procedimento IS 'C¿digo do grupo de procedimento';
COMMENT ON COLUMN vdic_auditar_contas.descricao_grupo_procedimento IS 'Descri¿¿o do grupo de procedimento';
COMMENT ON COLUMN vdic_auditar_contas.quantidade_faturada IS 'Quantidade faturada';
COMMENT ON COLUMN vdic_auditar_contas.percentual_faturado IS 'Percentual faturado';
COMMENT ON COLUMN vdic_auditar_contas.valor_bruto_faturado IS 'Valor bruto faturado';
COMMENT ON COLUMN vdic_auditar_contas.quantidade_liberada IS 'Quantidade liberada';
COMMENT ON COLUMN vdic_auditar_contas.percentual_liberado IS 'Percentual liberado';
COMMENT ON COLUMN vdic_auditar_contas.valor_bruto_liberado IS 'Valor bruto liberado';
COMMENT ON COLUMN vdic_auditar_contas.hospital_acordo IS 'Se o hospital est¿ de acordo';
COMMENT ON COLUMN vdic_auditar_contas.paciente_paga IS 'Se o paciente paga';
COMMENT ON COLUMN vdic_auditar_contas.codigo_motivo_auditoria IS 'C¿digo do motivo de auditoria';
COMMENT ON COLUMN vdic_auditar_contas.descricao_motivo_auditoria IS 'Descri¿¿o do motivo de auditoria';
COMMENT ON COLUMN vdic_auditar_contas.tipo_do_motivo_da_auditoria IS 'Tipo do motivo de auditoria';
COMMENT ON COLUMN vdic_auditar_contas.origem_do_lancamento IS 'Origem do lan¿amento';
COMMENT ON COLUMN vdic_auditar_contas.valor_glosa IS 'Valor da glosa';
COMMENT ON COLUMN vdic_auditar_contas.data_de_cancelamento IS 'Data de cancelamento da auditoria';
COMMENT ON COLUMN vdic_auditar_contas.usuario_que_cancelou IS 'Usu¿rio que cancelou a auditoria';
COMMENT ON COLUMN vdic_auditar_contas.codigo_do_prestador IS 'C¿digo do prestador';
COMMENT ON COLUMN vdic_auditar_contas.nome_do_prestador IS 'Nome do prestador';
COMMENT ON COLUMN vdic_auditar_contas.codigo_da_atividade_medica IS 'C¿digo da atividade m¿dica';
COMMENT ON COLUMN vdic_auditar_contas.descricao_da_atividade_medica IS 'Descri¿¿o da atividade m¿dica';
COMMENT ON COLUMN vdic_auditar_contas.forma_de_pagamento IS 'Forma de pagamento do prestador';
COMMENT ON COLUMN vdic_auditar_contas.cd_atendimento_sus_vinculado IS 'Indica que o atendimento esta associado a uma interna¿¿o SUS';

GRANT DELETE,INSERT,SELECT,UPDATE ON vdic_auditar_contas TO dbaps;
GRANT DELETE,INSERT,SELECT,UPDATE ON vdic_auditar_contas TO dbasgu;
GRANT DELETE,INSERT,SELECT,UPDATE ON vdic_auditar_contas TO mv2000;
GRANT SELECT ON vdic_auditar_contas TO mv2000_leitura;
GRANT DELETE,INSERT,SELECT,UPDATE ON vdic_auditar_contas TO mvintegra;
