SELECT COUNT(*) FROM focos_norte;
SELECT * FROM focos_norte LIMIT 20;

/*Remover quebras de linha e espaços extras*/
UPDATE focos_norte
SET bioma = TRIM(TRAILING '\r' FROM bioma),
    estado = TRIM(estado),
    municipio = TRIM(municipio)
WHERE id IS NOT NULL;
