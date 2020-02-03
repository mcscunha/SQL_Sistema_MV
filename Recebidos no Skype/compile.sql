set pagesize 0

spool compile_all.sql

select 'alter '||decode( object_type , 'PACKAGE BODY' ,'PACKAGE' , OBJECT_TYPE) ||' '||object_name
||decode( object_type , 'PACKAGE BODY' ,' compile body;' , ' compile;')
from USER_objects
where status='INVALID' --and owner in ( select user from dual)
order by object_type;

spool off

@compile_all
