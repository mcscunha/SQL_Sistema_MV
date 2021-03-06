SELECT DISTINCT 
	cd_paciente,
	nm_paciente,
	max(convert(date, isnull(dt_ultima_visita, '01/01/2000'), 103)) dt_ultvisita
	-- , CASE WHEN Falecido = 0 THEN 'Nao' ELSE 'Sim' END falecido
FROM 
	(
		SELECT
			'Agenda por Médico' tabela,
			REPLACE(códcliente, 'P', '') cd_paciente,
			nomecliente nm_paciente,
			max(horáriochegada) dt_ultima_visita,
			B.FlagFalecido Falecido
		FROM 
			Agenda.dbo."Agenda por Médico" A
		JOIN "Clientes"."dbo"."Clientes" B 
			ON replace(B."Prontuário", 'P', '') = A.códcliente
		-- WHERE B.FlagFalecido = 0
		WHERE códcliente = '70926'
		GROUP BY 
			REPLACE(códcliente, 'P', ''),
			nomecliente,
			B.FlagFalecido
		
		UNION
		
		SELECT
			'Agenda por Médico B' tabela,
			REPLACE(códcliente, 'P', '') cd_paciente,
			nomecliente nm_paciente,
			max(horáriochegada) dt_ultima_visita,
			D.FlagFalecido Falecido
		FROM 
			Agenda.dbo."Agenda por Médico B" C
		JOIN "Clientes"."dbo"."Clientes" D
			ON replace(D."Prontuário", 'P', '') = C.códcliente
		-- WHERE D.FlagFalecido = 0
		WHERE códcliente = '70926'
		GROUP BY 
			REPLACE(códcliente, 'P', ''),
			nomecliente,
			D.FlagFalecido

	) AS V
WHERE 
	cd_paciente = '70926'
GROUP BY 
	cd_paciente,
	nm_paciente
	-- , falecido
HAVING
	MAX(isnull(dt_ultima_visita, '01/01/2000')) < DATEADD(YEAR, -5, '12/31/2019')  -- CUIDADO COM A DATA
ORDER BY
	cd_paciente DESC;
