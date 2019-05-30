DECLARE
   --
   --
   CURSOR c_0 IS
   SELECT cd_paciente, To_Char(paciente.dt_cadastro, 'dd/mm/yyyy hh24:mi:ss')
   FROM dbamv.paciente
   WHERE To_Char(dt_cadastro, 'HH24') = '00';

   CURSOR c_2(p_paciente NUMBER) IS
      SELECT dt_cadastro,
             dt_cadastro_manual,
             dt_nascimento
        FROM dbamv.paciente
       WHERE cd_paciente = p_paciente FOR UPDATE NOWAIT;

   CURSOR c_3 IS
      SELECT 1
        FROM all_objects
       WHERE object_name = 'TRG_PACIENTE_DT_HORARIO_VERAO';

   v_2 c_2%ROWTYPE;
   vHorasAdd NUMBER := (2/24);
   v_count NUMBER := 0;
   v_existe NUMBER;
   v_lock EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_lock, -54);
BEGIN
   --
   dbamv.pkg_mv2000.Atribui_Empresa(1);
   --
   OPEN c_3;
   FETCH c_3 INTO v_existe;
   CLOSE c_3;
   --
   IF v_existe > 0 THEN
      EXECUTE IMMEDIATE 'alter trigger dbamv.TRG_PACIENTE_DT_HORARIO_VERAO disable';
   END IF;
   --
   EXECUTE IMMEDIATE 'alter table dbamv.paciente disable all triggers';
   --
   FOR r_1 IN c_0 LOOP
       --
       BEGIN

            OPEN c_2(r_1.cd_paciente);
            FETCH c_2 INTO v_2;
            CLOSE c_2;

            UPDATE dbamv.paciente
               SET dt_cadastro = trunc(dt_cadastro) + vHorasAdd,
                   dt_nascimento = trunc(dt_nascimento) + vHorasAdd,
                   hr_cadastro = hr_cadastro + 7
             WHERE cd_paciente = r_1.cd_paciente;

             v_count := 1;

             IF MOD(v_count, 1000) = 0 THEN
                COMMIT;
                v_count := 0;
             END IF;
       EXCEPTION
             WHEN v_lock THEN
                NULL;
       END;
       --
   END LOOP;
   --
   COMMIT;
   --
   IF v_existe > 0 THEN
      EXECUTE IMMEDIATE 'alter trigger dbamv.TRG_PACIENTE_DT_HORARIO_VERAO enable';
   END IF;
   --
   EXECUTE IMMEDIATE 'alter table dbamv.paciente enable all triggers';
   --
exception
   when others then
      IF v_existe > 0 THEN
         EXECUTE IMMEDIATE 'alter trigger dbamv.TRG_PACIENTE_DT_HORARIO_VERAO enable';
   end if;
   --
    EXECUTE IMMEDIATE 'alter table dbamv.paciente enable all triggers';
    --
   Raise_Application_Error (-20000, 'Houve um erro durante a execução do script. Erro: '||sqlerrm);
END;
/