select
    to_char(a.dt_agenda, 'DD/MM/YYYY') data,
    nvl(nm_cidade, '- - NAO INFORMADO -') || ' - ' || nvl(d.cd_uf, '') cidade,
    (
        select count(distinct x.nm_paciente) 
        from DBAMV.agenda_central z
        join DBAMV.it_agenda_central x on 
            x.cd_agenda_central = z.cd_agenda_central
        where 
            x.cd_it_agenda_pai is null
            and x.nm_paciente is not null
            and nvl(x.tp_situacao, 'A') <> 'C'
            and z.dt_agenda = '18/06/2019'
    ) Total_Pacientes,
    count(distinct b.nm_paciente) num_pacientes,
    --
    -- NAO ACRESCENTAR CAMPOS ACIMA DESTE PONTO OU 
    -- TERA QUE ACERTAR O ORDER BY DOS AGRUPAMENTOS
    --
    sum(count(distinct b.nm_paciente)) OVER (ORDER BY 4 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) num_pac_acum,
    round(
        (
            (
                count(distinct b.nm_paciente) /
                (select count(distinct x.nm_paciente) 
                 from DBAMV.agenda_central z
                 join DBAMV.it_agenda_central x on 
                    x.cd_agenda_central = z.cd_agenda_central
                 where 
                    x.cd_it_agenda_pai is null
                    and x.nm_paciente is not null
                    and nvl(x.tp_situacao, 'A') <> 'C'
                    and z.dt_agenda = a.dt_agenda
                ) 
            ) * 100 
        ), 2
    ) percentual
    , sum(
        round(
            (
                (
                    count(distinct b.nm_paciente) /
                    (select count(distinct x.nm_paciente) 
                     from DBAMV.agenda_central z
                     join DBAMV.it_agenda_central x on 
                        x.cd_agenda_central = z.cd_agenda_central
                     where 
                        x.cd_it_agenda_pai is null
                        and x.nm_paciente is not null
                        and nvl(x.tp_situacao, 'A') <> 'C'
                        and z.dt_agenda = a.dt_agenda
                    ) 
                ) * 100 
            ), 2
        ) 
    ) OVER (ORDER BY 4 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) perc_acum
from DBAMV.agenda_central a
join DBAMV.it_agenda_central b on
    b.cd_agenda_central = a.cd_agenda_central
left join DBAMV.paciente c on
    c.cd_paciente = b.cd_paciente
left join DBAMV.cidade d on
    d.cd_cidade = c.cd_cidade
where 
    b.cd_it_agenda_pai is null
    and b.nm_paciente is not null
    and nvl(b.tp_situacao, 'A') <> 'C'
    and a.dt_agenda = '18/06/2019'
group by 
    --to_char(a.dt_agenda, 'HH24:MI:SS'),
    a.dt_agenda,
    nvl(nm_cidade, '- - NAO INFORMADO -') || ' - ' || nvl(d.cd_uf, '')
order by 
    num_pacientes desc
;
