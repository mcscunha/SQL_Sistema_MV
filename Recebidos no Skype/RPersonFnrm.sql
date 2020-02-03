--<DS_SCRIPT>
-- DESCRICAO...: OP 6017 - Incluindo menu para o O_IMPORTA_CEP_ECT
-- RESPONSAVEL.: EDINEI FIORESE
-- DATA........: 22/10/2014
-- APLICACAO...: GLOBAL
--</DS_SCRIPT>
--<USUARIO=DBAMV>
CREATE OR REPLACE PROCEDURE DBAMV.prc_menu_fnrm IS

  -- Criado por: André Gueiros
  -- Em: 07/01/2014


  -- Esta procedure tem como objetivo de montar e manter os menus do produto ATENDIMENTO
  -- Nele existe a rotina chamada PrcControlaModulo, que será
  -- responsável por inserir e atualizar os modulos do sistema.
  -- A rotina PrcInsereMenu será responsavel pelos inserts dos Menus.
  -- OBS.: Numca deve ser deletada uma linha da procedure, pois esta procedure não será incremental,
  -- deve conter sempre todos os novos menus criados a partir da build 270.


  -- *** Início da declaração de Constantes *** --
  TIPO_TRANSACAO_INSERT constant varchar2(1) := 'I';
  TIPO_TRANSACAO_UPDATE constant varchar2(1) := 'U';
  TIPO_TRANSACAO_DELETE constant varchar2(1) := 'D';

  pSequence      NUMBER := 0;

  -- *** Table of Records responsavel pela carga dos menus *** --
  Type TypRec_Menu Is Record (
     cd_menu      dbasgu.menu.cd_menu%type
    ,nm_menu      dbasgu.menu.nm_menu%type
    ,cd_menu_pai  dbasgu.menu.cd_menu_pai%type
    ,cd_modulo    dbasgu.menu.cd_modulo%type
    ,nr_ordem     dbasgu.menu.nr_ordem%type
    ,tp_menu      dbasgu.menu.tp_menu%type
    ,cd_texto     dbasgu.menu.cd_texto%type
    ,nm_link      dbasgu.menu.nm_link%type
    ,sn_migrado   dbasgu.menu.sn_migrado%type
    ,nm_icon      dbasgu.menu.nm_icon%type
    ,tp_crud      dbasgu.menu.tp_crud%type
    ,sn_alterado  dbasgu.menu.sn_alterado%type
    );
  Type TypTab_Menu Is Table of TypRec_Menu Index By Binary_Integer;
  tMenu TypTab_Menu;


  -- ************************************************* --
  -- *** Realiza o insert em todos os menus armazenados
  -- *** em memoria.
  -- *** ESTA PROCEDURE NÃO DEVE SER ALTERADA
  -- ************************************************* --
  Procedure Pr_Salvar_Menu Is
    vCount NUMBER := 0;
  Begin
    --
    For i in 1..Nvl(tMenu.Last,0) Loop
      --
      Begin
        --
        INSERT INTO dbasgu.menu ( cd_menu, nm_menu, cd_menu_pai, cd_modulo, nr_ordem, tp_menu, cd_texto, nm_link, sn_migrado, nm_icon, tp_crud, sn_alterado )
          VALUES ( tMenu( i ).cd_menu
                  ,tMenu( i ).nm_menu
                  ,tMenu( i ).cd_menu_pai
                  ,tMenu( i ).cd_modulo
                  ,tMenu( i ).nr_ordem
                  ,tMenu( i ).tp_menu
                  ,tMenu( i ).cd_texto
                  ,tMenu( i ).nm_link
                  ,tMenu( i ).sn_migrado
                  ,tMenu( i ).nm_icon
                  ,tMenu( i ).tp_crud
                  ,tMenu( i ).sn_alterado );

        vCount := vCount + 1;
        if vCount >= 1000 then
          commit;
        end if;

      Exception When Dup_Val_On_Index Then
        --
        Dbms_Output.Put_Line( 'Atenção: Menu (' || tMenu( i ).cd_menu || ') "' || tMenu( i ).nm_menu || '", o seu código já esta cadastrado' );
        --
      When Others Then
        --
        Raise_Application_Error( -20001, 'Não foi possível inserir o menu: (' || tMenu( i ).cd_menu || ') ' || tMenu( i ).nm_menu
                    || '. ' || SQLERRM  );
        --
      End;
      --
    End Loop;
    --
  End Pr_Salvar_Menu;
  --
  -- ************************************************* --
  -- *** Procedure responsabel pelo armazenamento em
  -- *** memória dos registros de menu.
  -- *** ESTA PROCEDURE NÃO DEVE SER ALTERADA
  -- ************************************************* --
  Procedure Pr_Carga_Menu( pcd_menu      dbasgu.menu.cd_menu%type
                          ,pnm_menu      dbasgu.menu.nm_menu%type
                          ,pcd_menu_pai  dbasgu.menu.cd_menu_pai%type
                          ,pcd_modulo    dbasgu.menu.cd_modulo%type
                          ,pnr_ordem     dbasgu.menu.nr_ordem%type
                          ,ptp_menu      dbasgu.menu.tp_menu%type
                          ,pcd_texto     dbasgu.menu.cd_texto%type
                          ,pnm_link      dbasgu.menu.nm_link%type
                          ,psn_migrado   dbasgu.menu.sn_migrado%type
                          ,pnm_icon      dbasgu.menu.nm_icon%type
                          ,ptp_crud      dbasgu.menu.tp_crud%type
                          ,psn_alterado  dbasgu.menu.sn_alterado%type ) is
    --
    rMenu TypRec_Menu;
	--
  Begin
	--
    rMenu.cd_menu      := pcd_menu    ;
    rMenu.nm_menu      := pnm_menu    ;
    rMenu.cd_menu_pai  := pcd_menu_pai;
    rMenu.cd_modulo    := pcd_modulo  ;
    rMenu.nr_ordem     := pnr_ordem   ;
    rMenu.tp_menu      := ptp_menu    ;
    rMenu.cd_texto     := pcd_texto   ;
    rMenu.nm_link      := pnm_link    ;
    rMenu.sn_migrado   := psn_migrado ;
    rMenu.nm_icon      := pnm_icon    ;
    rMenu.tp_crud      := ptp_crud    ;
    rMenu.sn_alterado  := psn_alterado;
    --
    tMenu( Nvl( tMenu.Last, 0 )+1 ) := rMenu;
    --
  End Pr_Carga_Menu;

  -- ************************************************* --
  -- *** Procedure (PrcControlaModulo) responsavel pelo controle dos modulos
  -- *** pModulo               - Codigo do modulo
  -- *** pNmModulo             - Descrição do modulo
  -- *** pTpModulo             - Tipo do modulo (T - Tela, M - Menu)
  -- *** pSistemaDono          - Sistema dono do Modulo - (PARI, MGES, FFVC)
  -- *** pTransacao            - Tipo de transação que será realizado para o modulo (UTILIZAR AS CONSTANTES)
  -- *** pDtCriacao            - Data de criação do modulo, DEFAULT SYSDATE
  -- *** pSnRelEspecifico      - DEFAULT 'S'
  -- *** pSnArmazenaParamentro - DEFAULT 'N'
  -- *** pSnCfAcesso           - DEFAULT 'N'
  -- ************************************************* --
  Procedure PrcControlaModulo (pModulo               VARCHAR2,
                               pNmModulo             VARCHAR2,
                               pTpModulo             VARCHAR2,
                               pSistemaDono          VARCHAR2,
                               pTransacao            VARCHAR2 DEFAULT 'I',
                               pDtCriacao            DATE     DEFAULT SYSDATE,
                               pSnRelEspecifico      VARCHAR2 DEFAULT 'S',
                               pSnArmazenaParamentro VARCHAR2 DEFAULT 'N',
                               pSnCfAcesso           VARCHAR2 DEFAULT 'N') is

    Cursor cModulo (vModulo Varchar2) is
     Select Cd_Modulo
       from Dbasgu.Modulos
      where Cd_Modulo = Upper(vModulo);

    vModulo VARCHAR2(500);

  Begin
     open cModulo(pModulo) ;
    fetch cModulo into vModulo;
    close cModulo;

    If vModulo is null Then
       begin
        Insert Into dbasgu.modulos (cd_modulo, nm_modulo, tp_modulo, dt_criacao, cd_sistema_dono, sn_ativo_rel_especifico, sn_armazena_parametro, sn_cf_acesso)
            Values (Upper(pModulo), pNmModulo, pTpModulo, SYSDATE, pSistemaDono, pSnRelEspecifico, pSnArmazenaParamentro, pSnCfAcesso);
       --exception when others then
        --null;
       end;
   End If;

     -- Alteração e exclusão do MODULO
    IF pTransacao = TIPO_TRANSACAO_UPDATE then
      Update dbasgu.modulos
         Set nm_modulo               = pNmModulo
            ,tp_modulo               = pTpModulo
            ,cd_sistema_dono         = pSistemaDono
            ,sn_ativo_rel_especifico = pSnRelEspecifico
            ,sn_armazena_parametro   = pSnArmazenaParamentro
            ,sn_cf_acesso            = pSnCfAcesso
       Where cd_modulo               = Upper(pModulo);

    Elsif pTransacao = TIPO_TRANSACAO_DELETE then
      Delete dbasgu.modulos
       Where cd_modulo = Upper(pModulo);
    End If;

  End PrcControlaModulo;


  -- ************************************************* --
  -- *** Procedure (PrcInsereMenu) responsavel pelo Insert dos menus
  -- *** pnm_menu      - Descrição do menu
  -- *** pcd_modulo    - Modulo que será aberto, passar nulo para Sub-Menu
  -- *** ptp_menu      - Tipo do Menu ( T - Tela, M - Menu)
  -- *** pCaminhoMenu  - Caminho completo do menu do PAI
  -- *** ATENTAR PARA O PARAMENTRO DO CAMINHO JÁ QUE É ELE QUE IRÁ
  -- *** DETERMINAR QUEM É O MENU PAI E ONDE SERÁ INCLUÍDO O MENU.
  -- *** 0 CAMINHO DEVE SER SEMPRE O CAMINHO COMPLETO DESTE O PRODUTO
  -- *** SEPARADO ' > '
  -- *** EXEMPLO.: 'Atendimento > Central de Agendamento > Consultas'
  -- *** TODOS OS MENUS INSERIDOS COM ESTE CAMINHO SERÃO APRESENTADOS ABAIXO DO MENU CONSULTAS.
  -- ************************************************* --
  Procedure PrcInsereMenu( pnm_menu      dbasgu.menu.nm_menu%type
                          ,pcd_modulo    dbasgu.menu.cd_modulo%type
                          ,ptp_menu      dbasgu.menu.tp_menu%type
                          ,pCaminhoMenu  VARCHAR2 -- Caminho completo do menu do PAI
                          ) IS

    Cursor cMenuPai is
      Select cd_menu
        from dbasgu.menu
       where Upper(rtrim(dbamv.FNC_OBTEM_MENU(CD_MENU), '> ')) = Upper(pCaminhoMenu);

    Cursor cOrdem (vMenuPai number)is
      Select max(nr_ordem) + 1 qt
        from dbasgu.menu
       where cd_menu_pai = vMenuPai;

  	vMenuPai number;
    vOrdem   number;
	--
  Begin

     Open cMenuPai;
    Fetch cMenuPai Into vMenuPai;
    Close cMenuPai;

     Open cOrdem (vMenuPai);
    Fetch cOrdem Into vOrdem;
    Close cOrdem;

    pSequence := pSequence + 1;

    Pr_Carga_Menu( pSequence, pnm_menu, vMenuPai, pcd_modulo, vOrdem, ptp_menu, NUll, NULL, 'S', NULL, NULL, 'S');
  End PrcInsereMenu;


BEGIN

  for rReg in ( select max(cd_menu) val from dbasgu.menu )	loop
	  pSequence := rReg.val + 1;
	end loop;

  --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  --##### Espaço para inserir, atualizar e deletar os MODULOS
  --PrcInsereModulo (pcd_modulo, pNmModulo, pTpModulo, pSistemaDono, pTpTransacao);

  -- OP 18267 (INICIO) - TMS - 08/04/2014
  --PrcControlaModulo ('R_PERSON_FNRM', 'Relatórios Personalizados FNRM', 'T', 'FNRM', TIPO_TRANSACAO_INSERT);
  -- OP 18267 (FIM)

  --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	--####### Espaço para APENAS para inserir todos os novos MENUS
  --PrcInsereMenu( pnm_menu, pcd_menu_pai, pcd_modulo, ptp_menu );
  --PrcInsereMenu( 'Menu de TESTE', NULL, 'M', 'Atendimento > Central de Agendamento > Consultas');
  -- OP 18267 (INCIO) - TMS - 08/04/2014
  PrcInsereMenu( 'Personalizados', 'R_PERSON_FNRM', 'T', 'Controladoria > Repasse Médico > Relatórios');
  -- OP 18267 (FIM)
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  -- *** Processa todos os registros para inserir os que ainda não o foram salvos ***
  -- *** NÃO ALTERAR DAQUI PARA BAIXO *** --
  Pr_Salvar_Menu;
  COMMIT;
END;
/
GRANT EXECUTE ON DBAMV.prc_menu_fnrm TO dbasgu
/
GRANT EXECUTE ON DBAMV.prc_menu_fnrm TO mv2000
/
GRANT EXECUTE ON DBAMV.prc_menu_fnrm TO mvintegra
/

begin
  dbamv.prc_menu_fnrm;
end;
/