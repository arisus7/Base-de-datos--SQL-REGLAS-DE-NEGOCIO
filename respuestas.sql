--TAREA
--punto1
CREATE TRIGGER unLabelPorAnio
BEFORE INSERT ON CDTitles
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'No se puede: diferente disquera en el mismo año')
    WHERE EXISTS (
        SELECT *
        FROM CDTitles
        WHERE groupCode = NEW.groupCode
          AND year = NEW.year
          AND labelId <> NEW.labelId
    );
END;