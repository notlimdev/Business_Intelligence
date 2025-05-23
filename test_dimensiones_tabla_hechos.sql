
-- 1. DIM_TIEMPO
CREATE TABLE DIM_TIEMPO (
  id_tiempo INT IDENTITY(1,1) PRIMARY KEY,
  anio INT,
  fecha_corte DATE
);

-- Tabla de hechos
CREATE TABLE HECHOS_FINANCIAMIENTO (
  id_hecho INT IDENTITY(1,1) PRIMARY KEY,
  id_tiempo INT,
  monto_financiamiento DECIMAL(18,2),
  FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO(id_tiempo),
);

INSERT INTO DIM_TIEMPO (anio, fecha_corte)
SELECT DISTINCT 
  CAST(ANIO AS INT) AS anio,
  TRY_CAST(FECHA_CORTE AS DATE) AS fecha_corte
FROM [Financiamiento].[dbo].FINAL_DB$
WHERE 
  ISNUMERIC(ANIO) = 1 AND
  TRY_CAST(FECHA_CORTE AS DATE) IS NOT NULL;

INSERT INTO HECHOS_FINANCIAMIENTO (id_tiempo, monto_financiamiento)
SELECT
  t.id_tiempo,
  f.MONTO_FINANCIERO
FROM [Financiamiento].[dbo].FINAL_DB$ f
JOIN DIM_TIEMPO t
  ON CAST(f.ANIO AS INT) = t.anio
  AND TRY_CAST(f.FECHA_CORTE AS DATE) = t.fecha_corte;

SELECT 
  t.anio,
  t.fecha_corte,
  h.monto_financiamiento
FROM HECHOS_FINANCIAMIENTO h
JOIN DIM_TIEMPO t ON h.id_tiempo = t.id_tiempo;