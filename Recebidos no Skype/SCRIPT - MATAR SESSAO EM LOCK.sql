--###################################################################-- 
--###################################################################--
--####                                                              #--
--####        SCRIPT PARA MATAR SESS�O EM LOCK NO BANCO             #--
--####                                                              #--
--#### � NECESS�RIO INFORMAR O USU�RIO NO PAR�METRO ORACLE_USERNAME #--
--####                                                              #--
--####             CRIADO POR - THACIO - 22/05/2018                 #--
--####                                                              #--
--###################################################################-- 
--###################################################################--

declare 

       cursor cMataSessao is
       select distinct *
       from (
       SELECT s.SID SID,
              s.SERIAL# SERIAL,
              s.inst_id
       FROM gv$locked_object v,
            dba_objects      d,
            gv$lock          l,
            gv$session       s
       WHERE v.object_id  = d.object_id
         AND (v.object_id = l.id1)
         and v.session_id = s.sid
         and oracle_username = 'COLOCAR O USU�RIO DO MV AQUI'
       ORDER BY oracle_username, session_id);

       rMataSessao cMataSessao%rowtype;

begin

     Open cMataSessao;

          Loop

              Fetch cMataSessao into rMataSessao;

                    Exit when cMataSessao%notfound;

                    dbms_output.put_line('alter system kill session ''' || rMataSessao.SID || ',' || rMataSessao.SERIAL || ',@' || rMataSessao.inst_id || '''');
                    
                    EXECUTE IMMEDIATE 'alter system kill session ''' || rMataSessao.SID || ',' || rMataSessao.SERIAL || ',@' || rMataSessao.inst_id || '''';

          end loop;


      close cMataSessao;


end;
