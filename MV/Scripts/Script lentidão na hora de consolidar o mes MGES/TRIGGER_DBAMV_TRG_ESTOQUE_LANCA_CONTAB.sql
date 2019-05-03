--<DS_SCRIPT>
-- DESCRIÇÃO..:  PDA 553373 - Correção de lentidão na consolidação.
-- RESPONSAVEL:  Jorge Augusto / João Ferraz
-- DATA.......:  09/11/2012
-- APLICAÇÃO..:  FCCT
--</DS_SCRIPT>
--<USUARIO=DBAMV>

CREATE OR REPLACE TRIGGER DBAMV.TRG_ESTOQUE_LANCA_CONTAB
 BEFORE
 INSERT OR DELETE OR UPDATE
 ON DBAMV.C_CONEST
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
DECLARE

 CURSOR cur_config_financ IS
   SELECT tp_compartilhamento
     FROM dbamv.config_financ
    WHERE cd_multi_empresa = pkg_mv2000.le_empresa;

 CURSOR cur_config_fcct (p_cd_multi_empresa in dbamv.config_fcct.cd_multi_empresa%type ) IS
   SELECT c.sn_lanca_estoque
     FROM dbamv.config_fcct c
	WHERE c.cd_multi_empresa = p_cd_multi_empresa;

 CURSOR cur_mes_ano_fech_cont (p_cd_multi_empresa in dbamv.config_fcct.cd_multi_empresa%type,
                               p_dt_referencia   in dbamv.con_pag.dt_lancamento%type ) IS
	SELECT m.tp_situacao_mes
      FROM dbamv.mes_ano_fech_cont m
	WHERE m.cd_multi_empresa = p_cd_multi_empresa
      AND m.dt_ano          = trunc(p_dt_referencia,'YYYY')
      AND m.dt_mes          = to_number(to_char(p_dt_referencia,'MM'));

  /* Verificar se na competência existe lote importado para contabilidade*/
  -- PDA 247273(Início) - Maurício Rodrigues - 03/09/2008
  /*  Cursor cConest( pCdAno dbamv.c_conest.cd_ano%Type,
                  pCdMes dbamv.c_conest.cd_mes%Type,
                  pCdEstoque dbamv.c_conest.cd_estoque%type ) is
    Select 'X'
      From dbamv.c_conest
     Where cd_ano = pCdAno
       And cd_mes = pCdMes
       And cd_estoque = pCdEstoque
       And cd_exp_contabilidade Is Not Null;*/
  -- PDA 247273(Fim)


  v_cd_multi_empresa       dbamv.config_fcct.cd_multi_empresa%type;
  dData                    date;
  v_tp_compartilhamento    dbamv.config_financ.tp_compartilhamento%type;
  v_sn_lanca_estoque       dbamv.config_fcct.sn_lanca_estoque%type;
  v_tp_situacao_mes        dbamv.mes_ano_fech_cont.tp_situacao_mes%type;

  nCdAno                   dbamv.c_conest.cd_ano%Type;
  nCdMes                   dbamv.c_conest.cd_mes%Type;
  nCdEstoque               dbamv.c_conest.cd_estoque%type;
  vExiste                  varchar2(1);
BEGIN

  v_cd_multi_empresa := dbamv.pkg_mv2000.le_empresa;

  If deleting Then
    -- PDA 247273(Início) - Maurício Rodrigues - 03/09/2008
    --dData  := to_date(:old.cd_mes||'/'||:new.cd_ano, 'mm/yyyy');
    dData  := to_date(:old.cd_mes||'/'||:old.cd_ano, 'mm/yyyy');
    -- PDA 247273(Fim)
    nCdAno := :old.cd_ano;
    nCdMes := :old.cd_mes;
    nCdEstoque := :old.cd_estoque;
  Else
    dData := to_date(:new.cd_mes||'/'||:new.cd_ano, 'mm/yyyy');
    nCdAno := :new.cd_ano;
    nCdMes := :new.cd_mes;
    nCdEstoque := :new.cd_estoque;
  End if;

  -- PDA 247273(início) - Maurício Rodrigues - 03/09/2008
  /*Open cConest(nCdAno, nCdMes, nCdEstoque);
    Fetch cConest into vExiste;
    If cConest%Found Then
    Close cConest;*/

  v_cd_multi_empresa := dbamv.pkg_mv2000.le_empresa;

  -- PDA 247273(Fim)


  OPEN  cur_config_financ;
 	  FETCH cur_config_financ INTO  v_tp_compartilhamento;
  CLOSE cur_config_financ;

  OPEN  cur_config_fcct(v_cd_multi_empresa);
    FETCH cur_config_fcct  INTO  v_sn_lanca_estoque;
  CLOSE cur_config_fcct;

  OPEN  cur_mes_ano_fech_cont(v_cd_multi_empresa, dData);
    FETCH cur_mes_ano_fech_cont INTO v_tp_situacao_mes;
  CLOSE cur_mes_ano_fech_cont;

  if (v_tp_compartilhamento = '2' or v_tp_compartilhamento = '4')  then
    if v_tp_situacao_mes = 'F' then
      if v_sn_lanca_estoque = 'S' then
        if inserting then
          Raise_application_error( -20010, 'Inclusão inválida, mês contábil fechado');
        elsif updating  then
          Raise_application_error( -20010, 'Alteração inválida, mês contábil fechado');
        elsif deleting then
          Raise_application_error( -20010, 'Exclusão inválida, mês contábil fechado');
        end if;
      end if;
    elsif v_tp_situacao_mes = 'A' and :old.cd_exp_contabilidade is not null
      and deleting then
      Raise_application_error( -20010,'Movimentação já importada para contabilidade no lote: ' || :old.cd_exp_contabilidade||chr(10)||
                                      'Para continuar a consolidação, os lotes importados para a contabilidade nesta competência devem ser excluídos.');
    end if;
  end if;

--   Close cConest; -- PDA 247273
END;

END trg_estoque_lanca_contab;
/
