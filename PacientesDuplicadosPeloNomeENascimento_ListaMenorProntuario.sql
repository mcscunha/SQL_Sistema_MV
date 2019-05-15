-- Oracle - MV - Sistemas Medicos
-- Monta instrucoes SQL DELETE para cada prontuario duplicado
-- A procura de duplicados é feita pelo NOME e DATA NASCIMENTO
--
select 
	'delete from paciente where cd_paciente = ' || min(cd_paciente) || ';' instrucao_sql,
	nm_paciente,
	dt_nascimento 
from paciente 
where (nm_paciente, dt_nascimento) in (
    select nm_paciente, dt_nascimento 
    from paciente 
    group by nm_paciente, dt_nascimento 
    having count(cd_paciente) > 1)
group by nm_paciente, dt_nascimento
order by nm_paciente;