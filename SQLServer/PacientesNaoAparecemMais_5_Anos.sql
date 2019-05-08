--
-- SQLServer
-- Rodar no sistema da Projesi, consulta de pacientes que nao aparecem na clinica ha mais de 5 anos
--
SELECT
	REPLACE(códcliente, 'P', '') cd_paciente,
	nomecliente nm_paciente,
	FORMAT(MAX(horáriochegada), 'dd/MM/yyyy') dt_ultima_visita
FROM 
	"Agenda por Médico"
WHERE 
	horáriochegada IS NOT NULL -- AND códcliente = '70099'
GROUP BY 
	códcliente,
	nomecliente
-- PROCURA COM DATAS, SEMPRE NO FORMATO MM/DD/YYYY
HAVING 
	MAX(horáriochegada) < DATEADD(YEAR, -5, '05/01/2019')  -- CUIDADO COM A DATA
ORDER BY
	MAX(horáriochegada) DESC;


-- Deve-se exportar este resultado em um arquivo CSV ou gravar em uma tabela
-- para depois excluir os pacientes que retornaram a clinica pelo outro sistema