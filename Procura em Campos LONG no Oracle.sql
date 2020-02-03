create global temporary table tex_evo_temp (
    cd_tex_evo number,
    ds_tex_evo clob,
    ds_texto varchar2(100)
);

insert into tex_evo_temp 
    select cd_tex_evo, to_lob(ds_tex_evo), ds_texto from tex_evo;
    
    
select * from tex_evo_temp where upper(ds_tex_evo) like '%OPTIVE%';

MERGE
INTO    tex_evo tab_orig
USING   (
        SELECT  tex_evo_temp.cd_tex_evo, tex_evo_temp.ds_texto
        FROM    tex_evo
        JOIN    tex_evo_temp
        ON      tex_evo_temp.cd_tex_evo = tex_evo.cd_tex_evo
        WHERE   tex_evo_temp.cd_tex_evo = 74
        ) tab_alt
ON      (tab_orig.cd_tex_evo = tab_alt.cd_tex_evo)
WHEN MATCHED THEN UPDATE
    SET tab_orig.ds_texto = upper(tab_alt.ds_texto);


MERGE into table1
USING table2
ON (table1.id = table2.id)
WHEN MATCHED THEN UPDATE SET table1.startdate = table2.start_date
WHERE table1.startdate > table2.start_date;


select * from tex_evo where cd_tex_evo = 74;
select * from tex_evo_temp where cd_tex_evo = 74;
ROLLBACK;

FOR R IN (SELECT calculo_leituras_ucb.iduc
          from calculo_leituras_ucb 
          inner join calculo_dados on  calculo_leituras_ucb.iduc = calculo_dados.iduc 
          where calculo_leituras_ucb.ano_mes = ('01/07/2014')
          and CALCULO_DADOS.IDROTA in (35,45,48,53,60,68,70,79)
          and CALCULO_LEITURAS_UCB.IDNAOLEITURA = 24)
LOOP
  update CALCULO_LEITURAS_UCB
  set CALCULO_LEITURAS_UCB.IDNAOLEITURA = 0
  WHERE iduc = R.iduc;
end LOOP;
... 



create or replace function F(B BLOB)
return clob is
  c clob;
  n number;
begin
  if (b is null) then
    return null;
  end if;
  if (length(b)=0) then
    return empty_clob();
  end if;
  dbms_lob.createtemporary(c,true);
  n:=1;
  while (n+32767<=length(b)) loop
    dbms_lob.writeappend(c,32767,utl_raw.cast_to_varchar2(dbms_lob.substr(b,32767,n)));
    n:=n+32767;
  end loop;
  dbms_lob.writeappend(c,length(b)-n+1,utl_raw.cast_to_varchar2(dbms_lob.substr(b,length(b)-n+1,n)));
  return c;
end;
/