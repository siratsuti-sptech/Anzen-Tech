/*
SPRINT 1 Grupo 2 - AnzenTech 
Gabriel Figueiredo
Kauã Hideaki
Miguel Vargas
Patrick Scaglia
Paulo Henrique
Pedro Gabriel
Thiago Prado
-----------------------------------------
SPRINT 2 Grupo 3 - AnzenTech 
Flávio Sandri Caputo
Kauã Hideaki 
Nicollas Martins
Pedro Nunes 
Pietro Giuliani
Zanee Lopes
*/

-- SPRINT 1

-- Criando e selecionando o banco de dados
CREATE DATABASE AnzenTech;
USE AnzenTech;

-- TABELA 1
-- Criação da tabela cadastro
CREATE TABLE cadastro (
idCadastro INT PRIMARY KEY AUTO_INCREMENT,
estabelecimento VARCHAR(50),
responsavel VARCHAR(40),
telefone VARCHAR(20),
cidade VARCHAR(40),
dataCadastro DATE,
situacaoMonitoramento VARCHAR(20) CHECK
(situacaoMonitoramento IN ('Ativo', 'Inativo', 'Em instalacao'))
) AUTO_INCREMENT = 1;
DESC cadastro;

-- Inserindo dados na tabela
INSERT INTO cadastro VALUES
(default, 'Temprerani Cucina','Davi Temperani', 
'11987654321', 'Sao Paulo','2026-09-06', 'Ativo'),
(default, 'Macaxeira','Vitor Fraga', 
'11976378364', 'Sao Paulo', '2026-08-15', 'Ativo'),
(default, 'Hotel Capriccio','Leticia Souza', '11962936159', 
'Sao Caetano do Sul','2026-05-17', 'Em instalacao'),
(default, 'Figo','Nelson Lima', '11954621875', 
'Sao Bernardo','2026-08-25', 'Ativo');

-- Selects na tabela cadastro
SELECT * FROM cadastro;

SELECT * FROM cadastro WHERE situacaoMonitoramento = 'Ativo';

SELECT * FROM cadastro WHERE cidade = 'Sao Paulo';

select concat('O estabelecimento ', estabelecimento, ' do representante ', responsavel, ', residido na cidade de ', cidade, ', está com a situação dos senores ', situacaoMonitoramento) as 'Situação cadastral' from cadastro;

-- TABELA 2
-- Criando tabela dos dados técnicos do sensor
CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
clienteEmpresa VARCHAR(50),
modeloSensor VARCHAR(30),
localInstalacao VARCHAR(50),
dataInstalacao DATE,
limiteAlerta DECIMAL(5,2) CHECK (limiteAlerta BETWEEN 0 AND 100),
statusSensor VARCHAR(20) CHECK
(statusSensor IN ('Ativo', 'Manutencao', 'Inativo')),
ultimaManutencao DATE
) AUTO_INCREMENT = 1;
DESC sensor;

-- Inserindo dados na tabela sensor
INSERT INTO sensor VALUES
(default, 'Temprerani Cucina','Sensor GLP A1', 
'Area de coccao','2026-08-21', 60.00, 'Ativo', '2026-08-21'),
(default, 'Macaxeira', 'Sensor GLP A1', 'Area de preparação',
'2026-06-07', 60.00, 'Ativo', '2026-08-02'),
(default, 'Hotel Capriccio','Sensor GLP B2',
 'Área de Grelhados', '2026-07-14', 65.00, 'Ativo', '2026-07-14'),
(default,  'Figo', 'Sensor GLP B2', 'Área de Fornos',
'2026-08-21', 65.00, 'Manutencao', '2026-09-06');

-- Selects na tabela sensor
SELECT * FROM sensor;

SELECT * FROM sensor WHERE dataInstalacao > '2026-08-01';

SELECT * FROM sensor WHERE statusSensor = 'Manutencao';

select concat('O sensor ', idsensor, ' do modelo', modelosensor, ', está instalado em ', localinstalacao, ', desde o dia ', datainstalacao, ', tendo sido feita a última manutenção no dia ', ultimaManutencao, ', e seu status atual é ', statussensor) as 'Informações do sensor' from sensor;

-- TABELA 3
-- Criando a tabela das leturas do sensor
CREATE TABLE leituraSensor (
idLeitura INT PRIMARY KEY AUTO_INCREMENT,
idSensor INT,
ppm DECIMAL(6,2),
dataHora DATETIME,
situacao VARCHAR(20),
CONSTRAINT chkPpm CHECK (ppm >= 0),
CONSTRAINT chkSituacao CHECK (situacao IN ('normal', 'atenção', 'perigoso'))
) AUTO_INCREMENT = 1;
DESC leituraSensor;

-- Inserindo dados na tabela leitoras do sensor
INSERT INTO leituraSensor VALUES
(default, 1, 200.00, '2026-09-07 08:00:00', 'normal'),
(default, 1, 250.00, '2026-09-07 09:00:00', 'normal'),
(default, 2, 400.00, '2026-09-07 09:30:00', 'atenção'),
(default, 2, 750.00, '2026-09-07 10:00:00', 'atenção'),
(default, 2, 1000.00, '2026-09-07 10:30:00', 'atenção'),
(default, 4, 1200.00, '2026-09-07 11:00:00', 'perigoso'),
(default, 4, 1500.00, '2026-09-07 11:30:00', 'perigoso'),
(default, 5, 300.00, '2026-09-07 12:00:00', 'normal');

-- Selects na tabela das leituras do sensor
SELECT * FROM leituraSensor;

SELECT * FROM leituraSensor WHERE situacao = 'atenção';

SELECT * FROM leituraSensor WHERE ppm > 1000;

SELECT concat('O sensor ', idsensor, ' captou um ppm de ', ppm, ', na data de', dataHora, ', e sua situação atual é ', situacao) AS Leitura FROM leiturasensor;

-- SELECTS

-- Selects na tabela cadastro
SELECT * FROM cadastro;
-- Clientes com situação cadastral ativa
SELECT * FROM cadastro WHERE situacaoMonitoramento = 'Ativo';
-- Clientes da cidade de São Paulo
SELECT * FROM cadastro WHERE cidade = 'Sao Paulo';
-- Select descritivo para o leitor
SELECT concat('O estabelecimento ', estabelecimento, ' do representante ', responsavel, ', residido na cidade de ', cidade, ', está com a situação dos senores ', situacaoMonitoramento) as 'Situação cadastral' from cadastro;

-- Selects na tabela sensor
SELECT * FROM sensor;
-- Sensores onde a data de instalação é após o dia 01/08/2026
SELECT * FROM sensor WHERE dataInstalacao > '2026-08-01';
-- Sensores que o status é "Manutenção"
SELECT * FROM sensor WHERE statusSensor = 'Manutencao';
-- Select com um texto descritivo
select concat('O sensor ', idsensor, ' do modelo', modelosensor, ', está instalado em ', localinstalacao, ', desde o dia ', datainstalacao, ', tendo sido feita a última manutenção no dia ', ultimaManutencao, ', e seu status atual é ', statussensor) as 'Informações do sensor' from sensor;

-- Selects na tabela das leituras do sensor
SELECT * FROM leituraSensor;
-- Busca leituras que 
SELECT * FROM leituraSensor WHERE situacao = 'atenção';
-- Leituras que ppm está maior que 1000
SELECT * FROM leituraSensor WHERE ppm > 1000;
-- Select como um texto descritivo
SELECT concat('O sensor ', idsensor, ' captou um ppm de ', ppm, ', na data de', dataHora, ', e sua situação atual é ', situacao) AS Leitura FROM leiturasensor;

-- SPRINT 2
CREATE DATABASE sprint2TabelasGLP;
USE sprint2TabelasGLP;
-- TABELA 4
-- tabela de estabelecimento
CREATE TABLE Estabelecimento (
    idEstabelecimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    segmento VARCHAR(45) NOT NULL,
    numeroFunc INT,
    cnpj CHAR(14) NOT NULL,
    endereco VARCHAR(90) NOT NULL
);

-- tabela Cadastro
CREATE TABLE Cadastro (
    idCadastro INT AUTO_INCREMENT PRIMARY KEY,
    estabelecimento VARCHAR(50) NOT NULL,
    responsavel VARCHAR(40) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cidade VARCHAR(40) NOT NULL,
    dataCadastro DATE NOT NULL,
    situacaoMonitoramento VARCHAR(20) NOT NULL,
    fkEstabelecimento INT NOT NULL,
    CONSTRAINT fk_Cadastro_Estabelecimento
        FOREIGN KEY (fkEstabelecimento)
        REFERENCES Estabelecimento(idEstabelecimento)
);
-- tabela Sensor
CREATE TABLE Sensor (
    idSensor INT AUTO_INCREMENT PRIMARY KEY,
    clienteEmpresa VARCHAR(50) NOT NULL,
    modeloSensor VARCHAR(30) NOT NULL,
    localInstalacao VARCHAR(50) NOT NULL,
    dataInstalacao DATE NOT NULL,
    limiteAlerta DECIMAL(5,2) NOT NULL,
    statusSensor VARCHAR(20) NOT NULL,
    ultimaManutencao DATE
    -- pensei em adicionar: 
    -- CONSTRAINT fk_Sensor_Estabelecimento
    --    FOREIGN KEY (fkEstabelecimento)
    --    REFERENCES Estabelecimento(idEstabelecimento)
);
-- tabela Leitura Sensor
CREATE TABLE LeituraSensor (
    idLeitura INT AUTO_INCREMENT PRIMARY KEY,
    ppm DECIMAL(6,2) NOT NULL,
    dataHora DATETIME NOT NULL,
    situacao VARCHAR(20) NOT NULL,
    Sensor_idSensor INT NOT NULL,
    CONSTRAINT fk_LeituraSensor_Sensor
        FOREIGN KEY (Sensor_idSensor)
        REFERENCES Sensor(idSensor)
);

