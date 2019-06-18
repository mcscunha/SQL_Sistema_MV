select 
    case
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (08, 09) then '08:00 as 10:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (10, 11) then '10:00 as 12:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (12, 13) then '12:00 as 14:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (14, 15) then '14:00 as 16:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (16, 17) then '16:00 as 18:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (18, 00) then '18:00 as 20:00'
        else 'EMERGENCIA'
    end classe,
    count(
        case
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (08, 09) then '08:00 as 10:00'
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (10, 11) then '10:00 as 12:00'
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (12, 13) then '12:00 as 14:00'
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (14, 15) then '14:00 as 16:00'
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (16, 17) then '16:00 as 18:00'
            when mod(to_char(b.hr_agenda, 'HH24'), 19) in (18, 00) then '18:00 as 20:00'
            else 'EMERGENCIA'
        end
    ) Contagem,
    round(
        (
            count(
                case
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (08, 09) then '08:00 as 10:00'
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (10, 11) then '10:00 as 12:00'
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (12, 13) then '12:00 as 14:00'
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (14, 15) then '14:00 as 16:00'
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (16, 17) then '16:00 as 18:00'
                    when mod(to_char(b.hr_agenda, 'HH24'), 19) in (18, 00) then '18:00 as 20:00'
                    else 'EMERGENCIA'
                end
            ) / (
                (select count(x.cd_paciente) 
                from DBAMV.agenda_central z
                join DBAMV.it_agenda_central x on 
                    x.cd_agenda_central = z.cd_agenda_central
                where 
                    x.cd_it_agenda_pai is null
                    and x.cd_paciente is not null
                    and z.dt_agenda = a.dt_agenda)
            ) * 100
        ), 2
    ) percentual
from DBAMV.agenda_central a
join DBAMV.it_agenda_central b on
    a.cd_agenda_central = b.cd_agenda_central
where 
    b.cd_it_agenda_pai is null
    and b.cd_paciente is not null
    and a.dt_agenda = '18/06/2019'
group by
    a.dt_agenda,
    case
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (08, 09) then '08:00 as 10:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (10, 11) then '10:00 as 12:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (12, 13) then '12:00 as 14:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (14, 15) then '14:00 as 16:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (16, 17) then '16:00 as 18:00'
        when mod(to_char(b.hr_agenda, 'HH24'), 19) in (18, 00) then '18:00 as 20:00'
        else 'EMERGENCIA'
    end
order by
    classe
;