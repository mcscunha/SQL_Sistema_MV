-- Corrigir erro: "... Seus dados foram alterados por outro usuario."
DECLARE
  --*** ALTERAR ***--
  vCdPaciente NUMBER := 1090264;
   --*** FIM ***--
   
   vHorasAdd     NUMBER := ((1/24)*1);
BEGIN
  dbamv.pkg_mv2000.atribui_empresa(1);

  update dbamv.paciente
    set dt_cadastro        = trunc(dt_cadastro)         + vHorasAdd,
        dt_cadastro_manual = trunc(dt_cadastro_manual)  + vHorasAdd,
        dt_nascimento      = trunc(dt_nascimento)       + vHorasAdd
  where cd_paciente = vCdPaciente;

  COMMIT;

END;
/refresh