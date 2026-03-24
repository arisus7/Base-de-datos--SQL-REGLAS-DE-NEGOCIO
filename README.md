# 🎵 RecordingLabelsDB — SQL Practice Codespace

Base de datos de sellos discográficos para practicar consultas SQL.

## Estructura de tablas

```
RecordingLabels    ← Sellos (Warner, Sony, Televisa…)
MusicalGroups      ← Grupos musicales
Artists            ← Artistas individuales
Member             ← Qué artistas pertenecen a qué grupo
CDTitles           ← Álbumes/CDs publicados
SongTitles         ← Canciones
ComposedOf         ← Qué canciones tiene cada CD (con # de pista)
WrittenBy          ← Quién escribió cada canción
YearY              ← Años de referencia
TopCDs             ← CDs destacados por año
TopSongs           ← Canciones destacadas por año
```

## Cómo empezar

### Opción A — SQLTools (recomendado en Codespace)
1. Abre `ejercicios.sql`
2. `Ctrl+Shift+P` → **SQLTools: Run Selected Query**
3. Selecciona la conexión `RecordingLabelsDB`

### Opción B — Terminal
```bash
# Abrir la BD de forma interactiva
sqlite3 recording_labels.db

# Ejecutar todos los ejercicios de una vez
sqlite3 recording_labels.db < ejercicios.sql

# Ver tablas disponibles
sqlite3 recording_labels.db ".tables"

# Ver estructura de una tabla
sqlite3 recording_labels.db ".schema CDTitles"
```

### Recrear la BD desde cero
```bash
rm -f recording_labels.db
sqlite3 recording_labels.db < setup_db.sql
```

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `setup_db.sql` | Crea todas las tablas e inserta datos de ejemplo |
| `ejercicios.sql` | 20 ejercicios organizados por nivel de dificultad |
| `recording_labels.db` | Base de datos SQLite (se genera automáticamente) |

## Niveles de ejercicios

| Nivel | Temas |
|-------|-------|
| 1 | SELECT, WHERE, ORDER BY |
| 2 | JOIN (INNER, múltiples tablas) |
| 3 | GROUP BY, HAVING, funciones de agregación |
| 4 | Subconsultas, reglas de negocio |
