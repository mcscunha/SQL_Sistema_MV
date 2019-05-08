-- Lista de Pacientes Duplicados
-- Verificacao pelo nome do paciente E data de nascimento

SELECT
    a.cd_paciente,
    a.nm_paciente,
    a.dt_nascimento
FROM
    paciente                                                                                                                     a,
    (
        SELECT
            nm_paciente,
            dt_nascimento,
            COUNT(nm_paciente)
        FROM
            paciente
        GROUP BY
            nm_paciente,
            dt_nascimento
        HAVING
            COUNT(nm_paciente) > 1
    ) b
WHERE
    a.nm_paciente = b.nm_paciente
    AND a.dt_nascimento = b.dt_nascimento;

