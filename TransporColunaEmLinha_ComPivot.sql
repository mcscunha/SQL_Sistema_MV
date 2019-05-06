-- ORACLE

-- USANDO PIVOT
select 
    case when V."1" is not null then 'Cheque | ' end ||
    case when V."2" is not null then 'Cartao | ' end ||
    case when V."3" is not null then 'Dinheiro | ' end ||
    case when V."4" is not null then 'Credito C/C | ' end ||
    case when V."5" is not null then 'Bordero | ' end ||
    case when V."6" is not null then 'Boleto | ' end ||
    case when V."7" is not null then 'DOC | ' end ||
    case when V."8" is not null then 'Duplicata | ' end ||
    case when V."9" is not null then 'Nota promissoria | ' end ||
    case when V."10" is not null then 'TEF' end FORMA
from 
    (
        select *
        from 
            (select distinct 
                cd_itcon_rec ID,
                A.tp_recebimento TP
             from
                DBAMV.reccon_rec A
             where 
                a.cd_itcon_rec in 474
            )
        pivot (
           sum(TP) for TP in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        )
    ) V;



-- SEM USAR PIVOT
select 
    (select distinct tp_recebimento 
    from DBAMV.reccon_rec 
    where cd_itcon_rec in 474 and tp_recebimento = 1
    ) FORMA_1,
    (select tp_recebimento 
    from DBAMV.reccon_rec 
    where cd_itcon_rec in 474 and tp_recebimento = 2
    ) FORMA_2,
    (select tp_recebimento 
    from DBAMV.reccon_rec 
    where cd_itcon_rec in 474 and tp_recebimento = 3
    ) FORMA_3,
    (select tp_recebimento 
    from DBAMV.reccon_rec 
    where cd_itcon_rec in 474 and tp_recebimento = 4
    ) FORMA_4
from dual;
