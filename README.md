#  RecordingLabelsDB — Reglas de Negocio en SQLite

##  Descripción

En este proyecto se implementa una base de datos de sellos discográficos utilizando **SQLite**.
El objetivo fue aplicar **reglas de negocio** usando triggers, así como realizar consultas para obtener información.

> Nota: Profee, se utilizó SQLite en el Codespace, pq algunas instrucciones cambian respecto a MySQL (por ejemplo, `RAISE(ABORT)` en lugar de `SIGNAL` y no hay stored procedures).

---

##  Estructura de la base de datos

Las tablas utilizadas son:

* RecordingLabels → Sellos discográficos
* MusicalGroups → Grupos musicales
* Artists → Artistas
* Member → Relación artista–grupo
* CDTitles → Álbumes
* SongTitles → Canciones
* ComposedOf → Relación CD–canciones
* WrittenBy → Autoría de canciones
* YearY → Años
* TopCDs → CDs destacados
* TopSongs → Canciones destacadas

---

## Cómo ejecutar el proyecto!!

### 1. Crear la base de datos

```bash
rm -f recording_labels.db
sqlite3 recording_labels.db < setup_db.sql
```

---

### 2. Ejecutar las reglas de negocio

```bash
sqlite3 recording_labels.db < respuestas.sql
```

---

### 3. Entrar a la base de datos

```bash
sqlite3 recording_labels.db
```

---

### 4. Verificar que los triggers existen

```sql
SELECT name FROM sqlite_master WHERE type='trigger';
```

Se deben mostrar:

* unLabelPorAnio
* unGrupoALaVez
* notificarVentasAltas

---

##  Reglas de negocio implementadas

### 1. Un grupo no puede tener diferentes disqueras en el mismo año

Se implementó con el trigger **unLabelPorAnio**.

---

### 2. Un artista solo puede pertenecer a un grupo a la vez

Se implementó con el trigger **unGrupoALaVez**, validando que no haya traslape de fechas.

---

### 3. Total de CDs vendidos por grupo

Se resolvió con una consulta SQL usando `SUM`, ya que SQLite no soporta stored procedures.

```sql
SELECT SUM(numberSold)
FROM CDTitles
WHERE groupCode = 1;
```

---

### 4. Notificación por altas ventas

Se implementó el trigger **notificarVentasAltas**, que detecta cuando un CD supera los 5 millones de ventas y no está en el Top 10.

---

## 🧪 Pruebas realizadas

### ✔ Prueba 1 — Regla de disquera

```sql
INSERT INTO CDTitles VALUES (99, 'Test', 1000, 2023, 2, 1);
```

Resultado esperado: ❌ Error

---

### ✔ Prueba 2 — Artista en dos grupos

```sql
INSERT INTO Member VALUES (50, 1, '2020-01-01', '2022-01-01');
INSERT INTO Member VALUES (50, 2, '2021-01-01', '2023-01-01');
```

Resultado esperado: ❌ Error en la segunda inserción

---

### ✔ Prueba 3 — Total de ventas

```sql
SELECT SUM(numberSold)
FROM CDTitles
WHERE groupCode = 1;
```

Resultado esperado: ✔ Número total

---

### ✔ Prueba 4 — Ventas mayores a 5 millones

```sql
UPDATE CDTitles
SET numberSold = 6000000
WHERE cdCode = 1;
```

Resultado esperado: ❌ Error / aviso


