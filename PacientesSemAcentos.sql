SELECT 
	'UPDATE PACIENTE SET NM_PACIENTE = ''' +
	dbo.fnTiraAcento(REPLACE(A.Nome, '''', '')) + ' ' +
	dbo.fnTiraAcento(REPLACE(ISNULL(A.Sobrenome, ''), '''', '')) + ''' WHERE CD_PACIENTE = ' + 
	CONVERT(VARCHAR, A."Prontuário") + ';'
FROM Clientes A
WHERE prontuário IN 
(
700,
725,
826,
927,
949,
1074
)
ORDER BY 
	A."Prontuário"

/*
drop function fnTiraAcento;
Create Function fnTiraAcento (@cExpressao varchar(300))
Returns varchar(300)
as
Begin
   Declare @cRetorno varchar(100)
   Set @cRetorno = @cExpressao collate sql_latin1_general_cp1251_cs_as
   Return @cRetorno
End	
*/
