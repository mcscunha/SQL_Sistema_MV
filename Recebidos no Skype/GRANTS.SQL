SET HEADING OFF
set linesize 300

SPOOL c:\GRANT_A.SQL

select 'GRANT REFERENCES ON ' ||
       uob.OBJECT_NAME ||
       ' TO ' || u.username || ';' comando
from   user_objects uob  , all_users u
where uob.object_type = 'TABLE'
        and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
        and u.username <> user
        and uob.object_name not like '%BIN$%'
Union all
select 'GRANT SELECT ON ' ||
       OBJECT_NAME ||
       ' TO MV2000 ; ' comando
from   user_objects
where  object_type = 'SEQUENCE'
        and object_name not like '%BIN$%'
union all -- Dá permissao aos outros usuários do mv2000
select 'GRANT SELECT ON ' ||
       OBJECT_NAME ||
       ' TO '  || u.username  || ';' comando
from   user_objects , all_users u
where  object_type = 'SEQUENCE'
        and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
        and u.username <> user
        and object_name not like '%BIN$%'
union all
select 'GRANT SELECT,insert,update,delete ON ' ||
       OBJECT_NAME ||
       ' TO MV2000 ;' comando
from   user_objects
where object_type = 'VIEW'
        and object_name not like '%BIN$%'
union all -- Dá permissao aos outros usuários
select 'GRANT SELECT,insert,update,delete ON ' ||
       OBJECT_NAME ||
       ' TO '  || u.username || ';' comando
from   user_objects , all_users u
where object_type = 'VIEW'
        and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
        and u.username <> user
        and object_name not like '%BIN$%'
union all
select 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' ||
       OBJECT_NAME ||
       ' TO MV2000 ;' comando
from   user_objects
where object_type = 'TABLE'
        and object_name not like '%BIN$%'
union all -- Dá permissao para outros usuários
select 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' ||
       OBJECT_NAME ||
       ' TO ' || u.username || ';' comando
from   user_objects , all_users u 
where object_type = 'TABLE'
        and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
        and u.username <> user
        and object_name not like '%BIN$%'
union all
select 'GRANT EXECUTE ON ' ||
       OBJECT_NAME ||
       ' TO MV2000 ;' comando
from user_objects
where object_type = 'FUNCTION'
        and object_name not like '%BIN$%'
union all -- Dá permissao para outros usuários
select 'GRANT EXECUTE ON ' ||
       OBJECT_NAME ||
       ' TO ' || u.username || ';' comando
from user_objects , all_users u
where object_type = 'FUNCTION'
        and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
        and u.username <> user
        and object_name not like '%BIN$%'
union all
select 'CREATE PUBLIC SYNONYM ' ||
       OBJECT_NAME ||
       ' FOR ' ||
       OBJECT_NAME || ';'  comando
From user_objects
where object_type = 'FUNCTION'
        and object_name not like '%BIN$%'
union all
select 'CREATE PUBLIC SYNONYM ' ||
       OBJECT_NAME ||
       ' FOR ' ||
       OBJECT_NAME || ';'  comando
From user_objects
where object_type = 'PROCEDURE'
        and object_name not like '%BIN$%'
union all
select 'GRANT EXECUTE ON ' ||
       OBJECT_NAME ||
       ' TO MV2000; ' comando
from   user_objects
where object_type = 'PROCEDURE'
        and object_name not like '%BIN$%'
union all -- Dá permissao aos outros usuário do MV2000
select 'GRANT EXECUTE ON ' ||
       OBJECT_NAME ||
       ' TO ' || u.username || ';' comando
from   user_objects, all_users u
where object_type = 'PROCEDURE'
  and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
  and u.username <> user
        and object_name not like '%BIN$%'
union all
select 'CREATE PUBLIC SYNONYM ' ||
       OBJECT_NAME ||
       ' FOR ' ||
       OBJECT_NAME || ';' comando
From user_objects
where object_type = 'SEQUENCE'
        and object_name not like '%BIN$%'
union all
select 'CREATE PUBLIC SYNONYM ' ||
       OBJECT_NAME ||
       ' FOR ' ||
       OBJECT_NAME || ';' comando
From user_objects
where object_type = 'PACKAGE'
        and object_name not like '%BIN$%'
union all
select 'GRANT EXECUTE ON ' ||
        OBJECT_NAME ||
       ' TO MV2000 ;' comando
from user_objects
where object_type = 'PACKAGE'
        and object_name not like '%BIN$%'
union all -- Dá permissao aos outros usuários
select 'GRANT EXECUTE ON ' ||
        OBJECT_NAME ||
       ' TO ' || u.username || ';' comando
from user_objects , all_users u
where object_type = 'PACKAGE'
  and  u.username  in ( 'DBAMV' , 'DBASGU' , 'DBAPS' , 'MVINTEGRA', 'DBADW')
  and u.username <> user
        and object_name not like '%BIN$%'
UNION ALL -- Para evitar o problema com as views a partir do 10GR2
SELECT 'GRANT MERGE ANY VIEW TO MV2000;'
FROM dual;


spool off
@c:\grant_a;
