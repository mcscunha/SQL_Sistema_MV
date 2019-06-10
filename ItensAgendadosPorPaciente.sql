SELECT
    trunc(ac.dt_agenda) data_agenda,
    ac.cd_prestador,
    p.nm_prestador,
    (
        (select 
            sum(acz.qt_atendimento) - sum(acz.qt_encaixes)
        from
            DBAMV.agenda_central acz 
        where 
            acz.sn_ativo = 'S' 
            and acz.dt_agenda = ac.dt_agenda
            and acz.cd_prestador = ac.cd_prestador)
    ) max_atend,
    (   
        select 
            count(distinct it1.nm_paciente)
        from 
            DBAMV.it_agenda_central it1
        join
            DBAMV.agenda_central ac1 
                on ac1.cd_agenda_central = it1.cd_agenda_central
        where
            it1.cd_it_agenda_pai is null
            and it1.cd_item_agendamento is not null
            and ac1.sn_ativo = 'S'
            and it1.cd_it_agenda_pai is null
            and ac1.dt_agenda = ac.dt_agenda
            and ac1.cd_prestador = ac.cd_prestador
    ) qt_marcados,
    (
        (select 
            sum(acy.qt_encaixes)
        from
            DBAMV.agenda_central acy 
        where 
            acy.sn_ativo = 'S' 
            and acy.dt_agenda = ac.dt_agenda
            and acy.cd_prestador = ac.cd_prestador)
    ) max_encaixes,
    nvl(ac.qt_encaixes_marcados, 0) num_ecaixes_marcados,
    rpad(ia.ds_item_agendamento, 80, '.') Item,
    count(iac.cd_item_agendamento) num_itens
FROM
    dbamv.agenda_central      ac
    JOIN dbamv.it_agenda_central   iac ON iac.cd_agenda_central = ac.cd_agenda_central
    JOIN dbamv.prestador           p ON p.cd_prestador = ac.cd_prestador
    JOIN dbamv.item_agendamento    ia ON ia.cd_item_agendamento = iac.cd_item_agendamento
WHERE
    ac.sn_ativo = 'S'
    and iac.cd_it_agenda_pai is null
    and p.tp_situacao = 'A'
    and ac.dt_agenda = '11/06/2019'
GROUP BY
    ac.dt_agenda,
    ac.cd_prestador,
    p.nm_prestador,
    ac.qt_encaixes_marcados,
    rpad(ia.ds_item_agendamento, 80, '.')
ORDER BY
    nm_prestador,
    rpad(ia.ds_item_agendamento, 80, '.')
