-- 1. Agregar las columnas si no existen
IF COL_LENGTH('prestamos', 'fecha_prestamo') IS NULL
BEGIN
    ALTER TABLE prestamos
    ADD fecha_prestamo DATE NOT NULL DEFAULT GETDATE();
END;

IF COL_LENGTH('prestamos', 'fecha_devolucion') IS NULL
BEGIN
    ALTER TABLE prestamos
    ADD fecha_devolucion DATE NULL;
END;

-- 2. Asignar fecha de pr�stamo aleatoria en los �ltimos 6 a�os
UPDATE prestamos
SET fecha_prestamo = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 2190), GETDATE());


-- 3. Asignar fecha de devoluci�n al 85% de los pr�stamos
UPDATE prestamos
SET fecha_devolucion = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30), fecha_prestamo)
WHERE fecha_devolucion IS NULL AND ABS(CHECKSUM(NEWID()) % 100) < 85;

select *from prestamos