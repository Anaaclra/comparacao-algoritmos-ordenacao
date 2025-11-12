#desmatamento total por dia (em (data) representou % do grafico todo)
SELECT
  dateclass,
  SUM(areaMunKm) AS area_dia_km2,
  ROUND(SUM(areaMunKm) / (SELECT SUM(areaMunKm) FROM desmatamento) * 100, 2) AS pct_total
FROM desmatamento
GROUP BY dateclass
ORDER BY dateclass;

#total por mes 
SELECT
  DATE_FORMAT(STR_TO_DATE(dateclass, '%d/%m/%Y'), '%Y-%m-%d') AS data,
  DATE_FORMAT(STR_TO_DATE(dateclass, '%d/%m/%Y'), '%Y-%m') AS mes,
  SUM(areaMunKm) AS area_dia_km2,
  ROUND(
    SUM(areaMunKm) /
    SUM(SUM(areaMunKm)) OVER (PARTITION BY DATE_FORMAT(STR_TO_DATE(dateclass, '%d/%m/%Y'), '%Y-%m')) * 100,
    2
  ) AS pct_no_mes
FROM desmatamento
GROUP BY data, mes
ORDER BY data;

#top 10 desmatamentos 
SELECT
  uf,
  SUM(areaMunKm) AS area_km2,
  ROUND(SUM(areaMunKm) / (SELECT SUM(areaMunKm) FROM desmatamento) * 100, 2) AS pct_total
FROM desmatamento
GROUP BY uf
ORDER BY area_km2 DESC
LIMIT 10;

#total por mes de cada estado 
SELECT
  uf,
  DATE_FORMAT(dateclass, '%Y-%m') AS ano_mes,
  SUM(areaMunKm) AS area_total_km2,
  ROUND(
    SUM(areaMunKm) /
    SUM(SUM(areaMunKm)) OVER (PARTITION BY DATE_FORMAT(dateclass, '%Y-%m')) * 100,
    2
  ) AS pct_no_mes
FROM desmatamento
GROUP BY uf, DATE_FORMAT(dateclass, '%Y-%m')
ORDER BY ano_mes, pct_no_mes DESC;

#total de cada região 
SELECT
  regiao,
  ano_mes,
  area_total_km2,
  ROUND(
    area_total_km2 /
    SUM(area_total_km2) OVER (PARTITION BY ano_mes) * 100,
    2
  ) AS pct_no_mes
FROM (
  SELECT
    CASE
      WHEN uf IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
      WHEN uf IN ('BA','MA','PI')                     THEN 'Nordeste'
      WHEN uf IN ('DF','GO','MS','MT')                THEN 'Centro-Oeste'
      WHEN uf IN ('MG','SP')                          THEN 'Sudeste'
      WHEN uf IN ('PR')                               THEN 'Sul'
      ELSE 'Outras'
    END AS regiao,
    DATE_FORMAT(dateclass, '%Y-%m') AS ano_mes,
    SUM(areaMunKm) AS area_total_km2
  FROM desmatamento
  WHERE uf IN ('AC','AM','AP','BA','DF','GO','MA','MG','MS','MT',
               'PA','PI','PR','RO','RR','SP','TO')
  GROUP BY regiao, DATE_FORMAT(dateclass, '%Y-%m')
) AS base
ORDER BY ano_mes, pct_no_mes DESC;

#total de cada regiao por mes 
SELECT
  regiao,
  ano_mes,
  area_total_km2,
  ROUND(
    area_total_km2 /
    SUM(area_total_km2) OVER (PARTITION BY ano_mes) * 100,
    2
  ) AS pct_no_mes
FROM (
  SELECT
    CASE
      WHEN uf IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
      WHEN uf IN ('BA','MA','PI')                     THEN 'Nordeste'
      WHEN uf IN ('DF','GO','MS','MT')                THEN 'Centro-Oeste'
      WHEN uf IN ('MG','SP')                          THEN 'Sudeste'
      WHEN uf IN ('PR')                               THEN 'Sul'
      ELSE 'Outras'
    END AS regiao,
    DATE_FORMAT(STR_TO_DATE(dateclass, '%d/%m/%Y'), '%Y-%m') AS ano_mes,
    SUM(areaMunKm) AS area_total_km2
  FROM desmatamento
  WHERE uf IN ('AC','AM','AP','BA','DF','GO','MA','MG','MS','MT',
               'PA','PI','PR','RO','RR','SP','TO')
  GROUP BY regiao, DATE_FORMAT(STR_TO_DATE(dateclass, '%d/%m/%Y'), '%Y-%m')
) AS base
ORDER BY ano_mes, pct_no_mes DESC;

#total 2023, total 2024 e diferença porcentual 
WITH anual AS (
  SELECT
    YEAR(STR_TO_DATE(dateclass, '%d/%m/%Y')) AS ano,  
    SUM(areaMunKm) AS area_total_km2               
  FROM desmatamento
  GROUP BY ano
)
SELECT
  a2023.area_total_km2 AS total_2023,                                
  a2024.area_total_km2 AS total_2024,                                
  ROUND(
    (a2024.area_total_km2 - a2023.area_total_km2) / a2023.area_total_km2 * 100,
    2
  ) AS variacao_percentual                                           
FROM anual a2023
JOIN anual a2024 ON a2024.ano = a2023.ano + 1                     
WHERE a2023.ano = 2023;   