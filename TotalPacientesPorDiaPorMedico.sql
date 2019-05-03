SELECT 
	c.data, 
	-- c.códmédico, 
	a.Nome, 
	count(compromisso) -- códcliente, nomecliente
FROM "Agenda por Médico" c
join "Médicos" a on
	a."CódMédico" = c.códmédico
WHERE horáriosaída IS NOT NULL -- c.datahoramarcação between '2018-05-10 00:00:00' and '2018-05-10 23:00:00' amd
	AND DATA between '2018-03-01' and '2018-05-10'
	--/*
	AND c.códmédico NOT IN (
		SELECT códmédico
		FROM "Médicos" a
		WHERE LOWER(nome) LIKE '% cirurgia%' or LOWER(nome) LIKE '% P.O.%'
	) -- cirurgias E P.O.
	--*/
group by a.Nome, c.data
ORDER BY DATA

