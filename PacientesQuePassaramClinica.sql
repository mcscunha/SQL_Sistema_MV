SELECT *
FROM "Agenda por Médico" c
WHERE horáriosaída IS NOT NULL -- c.datahoramarcação between '2018-05-10 00:00:00' and '2018-05-10 23:00:00' amd
	AND DATA between '2018-03-01' and '2018-05-10'
	--/*
	AND códmédico NOT IN (
		SELECT códmédico
		FROM "Médicos" a
		WHERE LOWER(nome) LIKE '% cirurgia%' or LOWER(nome) LIKE '% P.O.%'
	) -- cirurgias E P.O.
	--*/
ORDER BY confirmado, DATA DESC

