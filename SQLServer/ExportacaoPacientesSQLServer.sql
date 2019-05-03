SELECT 
	 -- A.prontuário,
	'INSERT INTO PACIENTE (sn_recebe_contato, dt_cadastro, cd_multi_empresa, dt_cadastro_manual, ' +
	'cd_paciente, nm_paciente, tp_situacao, tp_sexo, nr_cpf, dt_nascimento, nr_cep, email) VALUES (' + 
	
	'''N'', ''' + 
	
	case
		WHEN (LEN(A."Dt_Inclusão") = 0 OR A."Dt_Inclusão" IS NULL) THEN 'NULL'
		ELSE REPLACE(CONVERT(NVARCHAR(11), A."Dt_Inclusão", 106), ' ', '/') 
	END +	''', ' +
	
	'1, ' +
 	
	'''' + REPLACE(CONVERT(NVARCHAR(11), GETDATE(), 106), ' ', '/') + ''', ' +
 	
	convert(VARCHAR, A."Prontuário") + ', ' +
 	
	'''' + replace(A.Nome, '''', '') + ' ' +	replace(isnull(A.Sobrenome, ''), '''', '') + ''', ' +
 	
	'''N'', ' +
 	
	'''' + case 
	 		when A.Sexo in ('M', '0') then 'M' 
	 		WHEN A.Sexo IN ('F', '1') THEN 'F'
			ELSE 'G' 
	END + ''', ' +
	
	case
 		WHEN (LEN(A.CPF) = 0 OR A.CPF IS NULL) THEN 'NULL'
 		ELSE '''' + replace(replace(replace(replace(A.CPF, '.', ''), '-', ''), '/', ''), ' ', '') + '''' 
	END + ', ' +
	
	'''' + case 
		WHEN (len(A.Dt_Nasc) = 0 OR A.Dt_Nasc IS NULL) THEN 'NULL' 
		ELSE replace(CONVERT(NVARCHAR(11), A.Dt_Nasc, 106), ' ', '/') 
	END + ''', ' +
	
	'''' + case 
		WHEN (len(A.CEP) = 0 OR A.CEP IS NULL) THEN 'NULL' 
		ELSE A.CEP 
	END + ''', ' +
 	
	CASE 
		WHEN (len(A."E-Mail") = 0 OR A."E-Mail" IS NULL) THEN 'NULL' 
		ELSE '''' + upper(A."E-Mail") + '''' 
	END + ');'

FROM Clientes A

 WHERE prontuário > 106518
 			-- between 71012 and 71014
			-- IN (1311, 1317, 1318, 1319, 106246, 106222, 105736, 105737)

ORDER BY 
	A."Prontuário"

	
	
	
	
/*
RODAR NO ORACLE PARA ALIMENTAR O SAME - Nara

INSERT INTO DBAMV.same 
  (CD_CAD_SAME, NR_MATRICULA_SAME, CD_PACIENTE, CD_ARMARIO_SAME, SN_NO_LOCAL, DT_CADASTRO, NR_VOLUME, NR_MATRICULA_VOLUME)
  (SELECT 
      1,                                                         -- Código de SAME
      cd_paciente,                                               -- NR_MATRICULA_SAME
      cd_paciente,                                               -- Código Paciente
      43,                                                        -- Armário
      'S',                                                       -- SN Local
      TO_DATE(SYSDATE),                                          -- ALTERAR DATA PARA DATA DE CADASTRO 
      1,                                                         -- ALTERAR VOLUME CONFORME NECESSIDADE
      cd_paciente || '.' ||1                                     -- ALTERAR VOLUME CONFORME NECESSIDADE (1)
   FROM dbamv.paciente
   WHERE cd_paciente > 106518
         -- between 262 and 20300                       -- DEFINIR O INTERVALO DE MATRÍCULAS
  )

*/	
	
	
-- ---------------------------------------
-- OCORRENCIAS DE ERROS 				--
-- ---------------------------------------
-- CPF repetidos
SELECT cpf, COUNT(cpf) 
FROM clientes 
WHERE cpf IS NOT NULL AND LEN(cpf) > 0
GROUP BY cpf
HAVING COUNT(cpf) > 1
ORDER BY 2 DESC;

-- CPF com tamanhos acima do permitido, mesmo apos aplicar os filtros
SELECT LEN(	case
 		WHEN (LEN(CPF) = 0 OR CPF IS NULL) THEN 'NULL, '
 		ELSE replace(replace(replace(replace(CPF, '.', ''), '-', ''), '/', ''), ' ', '')  
	END  
), COUNT(cpf) 
FROM clientes 
WHERE LEN(	case
 		WHEN (LEN(CPF) = 0 OR CPF IS NULL) THEN 'NULL, '
 		ELSE replace(replace(replace(replace(CPF, '.', ''), '-', ''), '/', ''), ' ', '')  
	END  
) > 11
GROUP BY len(	case
 		WHEN (LEN(CPF) = 0 OR CPF IS NULL) THEN 'NULL, '
 		ELSE replace(replace(replace(replace(CPF, '.', ''), '-', ''), '/', ''), ' ', '')  
	END  
);

-- Registros com data de inclusao nulas
SELECT prontuário , COUNT(isnull(Dt_Inclusão, 1))
FROM clientes 
WHERE Dt_Inclusão IS NULL
GROUP BY prontuário;



-- ---------------------------------------------------------------------------
-- CONSERTAR CPF DUPLICADO 													--
-- PEGANDO SOMENTE OS CPF QUE FORAM CADASTRADOS APOS A PRIMEIRA OCORRENCIA 	--
-- (ALTERAR SOMENTE OS CPF MAIS NOVOS) 										--
-- ---------------------------------------------------------------------------
SELECT prontuário, cpf
FROM clientes 
WHERE cpf IS NOT NULL AND LEN(cpf) > 0
	and prontuário NOT IN 
	(
		SELECT MIN(prontuário) 
		FROM clientes 
		WHERE cpf IS NOT NULL AND LEN(cpf) > 0 
			and cpf IN 
			(
				SELECT cpf 
				FROM clientes 
				WHERE cpf IS NOT NULL AND LEN(cpf) > 0 
				GROUP BY cpf
				HAVING COUNT(cpf) > 1 
			)
		GROUP BY cpf
	) 
	AND cpf IN (
				SELECT cpf 
				FROM clientes 
				WHERE cpf IS NOT NULL AND LEN(cpf) > 0 
				GROUP BY cpf
				HAVING COUNT(cpf) > 1 
			)
ORDER BY 2 DESC;