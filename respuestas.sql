--TAREA

--Profe, lo hice en SQLite porque es el motor que viene en Codespaces, por eso usé RAISE(ABORT) en los triggers en lugar de SIGNAL de MySQL.
--También el punto 3 lo resolví con un SELECT porque SQLite no maneja stored procedures.

--punto1
DROP TRIGGER IF EXISTS unLabelPorAnio;

CREATE TRIGGER unLabelPorAnio
BEFORE INSERT ON CDTitles
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'No se puede jeje diferente disquera en el mismo año')
    WHERE EXISTS (
        SELECT *
        FROM CDTitles
        WHERE groupCode = NEW.groupCode
          AND year = NEW.year
          AND labelId <> NEW.labelId
    );
END;

--punto2
DROP TRIGGER IF EXISTS unGrupoALaVez;

CREATE TRIGGER unGrupoALaVez
BEFORE INSERT ON Member
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Error: artista ya pertenece a otro grupo en ese periodo')
    WHERE EXISTS (
        SELECT 1
        FROM Member
        WHERE artistId = NEW.artistId
        AND ( NEW.from_date <= to_date AND NEW.to_date >= from_date ));
END;

--punto3
-- Dado un groupCode
SELECT SUM(numberSold) AS total_vendido
FROM CDTitles
WHERE groupCode = 1;

--punto4
DROP TRIGGER IF EXISTS notificarVentasAltas;
CREATE TRIGGER notificarVentasAltas
AFTER UPDATE ON CDTitles
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'CD con más de 5M ventas y no está en el Top 10')
    WHERE NEW.numberSold > 5000000
    AND NOT EXISTS (
        SELECT 1
        FROM TopCDs
        WHERE cdCode = NEW.cdCode
          AND year = NEW.year
    );
END;