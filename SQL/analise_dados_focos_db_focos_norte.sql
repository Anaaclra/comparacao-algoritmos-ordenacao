-- Total de focos por estado e bioma
SELECT estado, bioma, COUNT(*) AS total_focos
FROM focos_norte
GROUP BY estado, bioma
ORDER BY total_focos DESC;

-- Evolução anual por estado
SELECT estado, YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) AS ano, COUNT(*) AS total
FROM focos_norte
GROUP BY estado, ano
ORDER BY estado, ano;

-- estados com mais de 1000 focos
SELECT estado, total
FROM (
  SELECT estado, COUNT(*) AS total
  FROM focos_norte
  GROUP BY estado
) AS sub
WHERE total > 1000
ORDER BY total DESC;

-- Comparar focos entre três anos
SELECT '2022' AS ano, COUNT(*) AS total
FROM focos_norte
WHERE YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) = 2022
UNION
SELECT '2023' AS ano, COUNT(*) AS total
FROM focos_norte
WHERE YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) = 2023
UNION
SELECT '2024' AS ano, COUNT(*) AS total
FROM focos_norte
WHERE YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) = 2024;

-- Comparar focos entre dois anos
SELECT YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) AS ano,
       COUNT(*) AS total
FROM focos_norte
WHERE YEAR(STR_TO_DATE(data_pas, '%Y-%m-%d %H:%i:%s')) IN (2022, 2023, 2024)
GROUP BY ano
ORDER BY ano;

-- Trazer os 10 municipios com total de queimadas
SELECT 
    municipio,
    COUNT(*) AS total_focos
FROM focos_norte
GROUP BY municipio
ORDER BY total_focos 
LIMIT 10

/*
Essa query calcula a média da potência dos focos por estado.
Ela depende da coluna 'frp', que não existe na tabela atual.
Por isso, está comentada para evitar erro.
*/
/*SELECT estado, AVG(frp) AS media_frp
FROM focos_norte
GROUP BY estado
ORDER BY media_frp DESC;*/
