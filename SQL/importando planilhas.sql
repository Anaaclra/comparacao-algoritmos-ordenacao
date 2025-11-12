use desmatamento;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deter-cerrado-nb-daily-22-10-2025-20_31_25.csv'
INTO TABLE desmatamento #selecionando a tabela 
CHARACTER SET utf8mb4 #codificando o arquivo para evitar problemas com ascentos 
FIELDS TERMINATED BY ',' #indica os campos separados por virgulas 
ENCLOSED BY '"' #aceitar campos com aspas 
LINES TERMINATED BY '\r\n' #declara o fim da linha 
IGNORE 1 LINES #ignora o cabeçalho e le cada coluna
(@dateclass, @areaMunKm, @areaUcKm, @uc_nome, @uf, @municipio, @geocod)
SET
  #converte a data para DATE padrão 
  dateclass = REGEXP_SUBSTR(TRIM(@dateclass), '[0-9]{2}/[0-9]{2}/[0-9]{4}'),
  #remove linhas vazias e transforma em null
  areaMunKm = NULLIF(TRIM(@areaMunKm), ''),
  areaUcKm  = NULLIF(TRIM(@areaUcKm), ''),
  uc_nome   = NULLIF(TRIM(@uc_nome), ''),
  uf        = NULLIF(TRIM(@uf), ''),
  municipio = NULLIF(TRIM(@municipio), ''),
  geocod    = NULLIF(TRIM(@geocod), '');
  
  

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deter-amz-daily-22-10-2025-20_30_44.csv'
INTO TABLE desmatamento #seleciona a tabela 
CHARACTER SET utf8mb4 #codificando o arquivo para evitar problemas com ascentos 
FIELDS TERMINATED BY ',' #indica os campos separados por virgulas 
OPTIONALLY ENCLOSED BY '"'  #aceitar campos com aspas 
ESCAPED BY '"' #declara o fim da linha 
LINES TERMINATED BY '\r\n' #declara o fim da linha 
IGNORE 1 LINES #ignora o cabeçalho e le cada coluna
(@dateclass, @areaMunKm, @areaUcKm, @uc_nome, @uf, @municipio, @geocod, @extra1, @extra2, @extra3)
SET
#converte a data para DATE padrão 
  dateclass = REGEXP_SUBSTR(TRIM(@dateclass), '[0-9]{2}/[0-9]{2}/[0-9]{4}'),
  #remove linhas vazias e transforma em null
  areaMunKm = NULLIF(TRIM(@areaMunKm), ''),
  areaUcKm  = NULLIF(TRIM(@areaUcKm), ''),
  uc_nome   = NULLIF(TRIM(@uc_nome), ''),
  uf        = NULLIF(TRIM(@uf), ''),
  municipio = NULLIF(TRIM(@municipio), ''),
  geocod    = NULLIF(TRIM(@geocod), '');