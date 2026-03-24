-- ============================================================
--  EJERCICIOS DE PRÁCTICA  –  RecordingLabelsDB
--  Ejecuta consultas individuales con:
--    sqlite3 recording_labels.db "SELECT ..."
--  O abre la BD interactiva:
--    sqlite3 recording_labels.db
-- ============================================================

PRAGMA foreign_keys = ON;

-- ────────────────────────────────────────────────────────────
-- NIVEL 1  –  Consultas básicas (SELECT / WHERE / ORDER BY)
-- ────────────────────────────────────────────────────────────

-- 1. Lista todos los artistas ordenados por apellido.
SELECT firstName, lastName, yearBorn
FROM Artists
ORDER BY lastName;

-- 2. Muestra los CDs con más de 700 000 copias vendidas.
SELECT cdTitle, numberSold
FROM CDTitles
WHERE numberSold > 700000
ORDER BY numberSold DESC;

-- 3. ¿Qué sellos discográficos están en USA?
SELECT labelName, location
FROM RecordingLabels
WHERE location = 'USA';

-- 4. Canciones cuyo título contenga la palabra "Love".
SELECT songTitle
FROM SongTitles
WHERE songTitle LIKE '%Love%';

-- ────────────────────────────────────────────────────────────
-- NIVEL 2  –  JOINs
-- ────────────────────────────────────────────────────────────

-- 5. Lista cada CD con el nombre de su sello discográfico.
SELECT c.cdTitle, r.labelName, c.numberSold
FROM CDTitles c
JOIN RecordingLabels r ON c.labelId = r.labelId;

-- 6. Muestra las canciones de cada CD (con número de pista).
SELECT c.cdTitle, s.songTitle, co.trackNumber
FROM ComposedOf co
JOIN CDTitles   c ON co.cdCode   = c.cdCode
JOIN SongTitles s ON co.songCode = s.songCode
ORDER BY c.cdTitle, co.trackNumber;

-- 7. ¿Qué artistas escribieron cada canción?
SELECT s.songTitle, a.firstName, a.lastName
FROM WrittenBy w
JOIN SongTitles s ON w.songCode  = s.songCode
JOIN Artists    a ON w.artistId  = a.artistId
ORDER BY s.songTitle;

-- 8. Miembros activos de cada grupo (sin fecha de salida).
SELECT mg.groupName, a.firstName, a.lastName, m.formDate
FROM Member m
JOIN Artists       a  ON m.artistId  = a.artistId
JOIN MusicalGroups mg ON m.groupCode = mg.groupCode
WHERE m.toDate IS NULL
ORDER BY mg.groupName;

-- ────────────────────────────────────────────────────────────
-- NIVEL 3  –  Agregaciones (GROUP BY / HAVING)
-- ────────────────────────────────────────────────────────────

-- 9. Total de copias vendidas por sello discográfico.
SELECT r.labelName, SUM(c.numberSold) AS totalSold
FROM CDTitles c
JOIN RecordingLabels r ON c.labelId = r.labelId
GROUP BY r.labelName
ORDER BY totalSold DESC;

-- 10. ¿Cuántos CDs lanzó cada grupo musical?
SELECT mg.groupName, COUNT(c.cdCode) AS totalCDs
FROM CDTitles c
JOIN MusicalGroups mg ON c.groupCode = mg.groupCode
GROUP BY mg.groupName
ORDER BY totalCDs DESC;

-- 11. Sellos con promedio de ventas por CD superior a 700 000.
SELECT r.labelName, AVG(c.numberSold) AS avgSold
FROM CDTitles c
JOIN RecordingLabels r ON c.labelId = r.labelId
GROUP BY r.labelName
HAVING AVG(c.numberSold) > 700000;

-- 12. Año con más ventas totales de CDs.
SELECT year, SUM(numberSold) AS totalSold
FROM CDTitles
GROUP BY year
ORDER BY totalSold DESC
LIMIT 1;

-- ────────────────────────────────────────────────────────────
-- NIVEL 4  –  Subconsultas y consultas avanzadas
-- ────────────────────────────────────────────────────────────

-- 13. CDs con rating 'Platinum' en TopCDs.
SELECT c.cdTitle, t.year, t.rating
FROM TopCDs t
JOIN CDTitles c ON t.cdCode = c.cdCode
WHERE t.rating = 'Platinum';

-- 14. Artistas que escribieron canciones que llegaron al TopSongs.
SELECT DISTINCT a.firstName, a.lastName
FROM WrittenBy w
JOIN Artists   a  ON w.artistId  = a.artistId
WHERE w.songCode IN (SELECT songCode FROM TopSongs);

-- 15. CD más vendido de cada año.
SELECT year, cdTitle, numberSold
FROM CDTitles c1
WHERE numberSold = (
    SELECT MAX(numberSold)
    FROM CDTitles c2
    WHERE c2.year = c1.year
)
ORDER BY year;

-- 16. Grupos que nunca han tenido un CD en TopCDs.
SELECT mg.groupName
FROM MusicalGroups mg
WHERE mg.groupCode NOT IN (
    SELECT DISTINCT c.groupCode
    FROM CDTitles c
    JOIN TopCDs t ON c.cdCode = t.cdCode
);

-- ────────────────────────────────────────────────────────────
-- REGLAS DE NEGOCIO  –  Restricciones / validaciones
-- ────────────────────────────────────────────────────────────

-- 17. Verificar que no haya CDs con numberSold <= 0.
SELECT cdTitle, numberSold
FROM CDTitles
WHERE numberSold <= 0;

-- 18. Artistas sin ningún grupo asignado.
SELECT a.firstName, a.lastName
FROM Artists a
WHERE a.artistId NOT IN (SELECT artistId FROM Member);

-- 19. Canciones que no pertenecen a ningún CD.
SELECT songTitle
FROM SongTitles
WHERE songCode NOT IN (SELECT songCode FROM ComposedOf);

-- 20. CDs cuyo año no coincide con ningún año en YearY.
SELECT cdTitle, year
FROM CDTitles
WHERE year NOT IN (SELECT year FROM YearY);
