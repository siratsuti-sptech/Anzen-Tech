-- SCRIPTS NO WINDOWS ABAIXO

-- CRIANDO O BANCO DE DADOS
CREATE DATABASE anzen_glp;


-- SELECIONANDO O BANCO DE DADOS PARA USO
USE anzen_glp;


/*
CRIANDO A TABELA endereco

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR OS ENDEREÇOS DOS ESTABELECIMENTOS

idEndreço -> Chave Primária da tabela endereco
cep -> Cep do endereço
logradouro -> Logradouro do endereço
bairro -> Bairro do endereço
numero -> Número do endereço
cidade -> Cidade do endereço
uf -> UF do endereço
complemento -> Complementos do endereço
*/
CREATE TABLE endereco(
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(9),
    logradouro VARCHAR(90),
    bairro VARCHAR(90),
    numero VARCHAR(10),
    cidade VARCHAR(45),
    uf CHAR(2),
    complemento VARCHAR(45)
);


/*
CRIANDO A TABELA empresa

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR OS PRINCIPAIS DADOS DAS EMPRESAS

idEmpresa -> chave primária da tabela empresa
razaoSocial -> Razão Social da empresa
nomeFantasia -> Nome Fantasia da empresa
cnpjMatriz -> CNPJ da Matriz da empresa
telefoneContato -> Telefone para contato da empresa
emailContato -> Email para contato da empresa
fkEndereco -> Chave Estrangeira que liga a tabela empresa à tabela endereco
*/
CREATE TABLE empresa(
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(90),
    nomeFantasia VARCHAR(90),
    cnpjMatriz CHAR(14),
    telefoneContato VARCHAR(20),
    emailContato VARCHAR(90),
    fkEndereco INT,
    FOREIGN KEY (fkEndereco)
		REFERENCES endereco(idEndereco)
);


/*
CRIANDO A TABELA estabelecimento

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR OS PRINCIPAIS DADOS DOS ESTABELECIMENTOS

idEstabelecimento -> chave primária da tabela estabelecimento
nome -> nome do estabelecimento
segmento -> segmento de mercado do estabelecimento
cnpjFilial -> CNPJ da Filial
fkEmpresa -> chave estrangeira que liga a tabela estabelecimento à tabela empresa
fkEndereco -> chave estrangeira que liga a tabela estabelecimento à tabela endereco
*/
CREATE TABLE estabelecimento(
	idEstabelecimento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    segmento VARCHAR(50),
    cnpjFilial CHAR(14),
    fkEmpresa INT,
    fkEndereco INT,
    FOREIGN KEY (fkEmpresa)
		REFERENCES empresa (idEmpresa),
	FOREIGN KEY (fkEndereco)
		REFERENCES endereco(idEndereco)
);


/*
CRIANDO A TABELA usuario

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR OS PRINCIPAIS DADOS DOS USUÁRIOS

idUsuario -> Chave Primária da tabela usuario
nome -> Nome do usuário
dataCadastro -> Data do Cadastro do usuário no site
email -> E-mail utilizado pelo usuário
senha -> Senha do usuário
fkEstabelecimento -> Chave Estrangeira que liga a tabela usuario à tabela estabelecimento
*/
CREATE TABLE usuario(
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40),
    dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(90),
    senha VARCHAR(45),
    fkEstabelecimento INT,
	FOREIGN KEY (fkEstabelecimento) 
		REFERENCES estabelecimento (idEstabelecimento)
);


/*
CRIANDO A TABELA sensor

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR TODOS OS DADOS DE CADA SENSOR INSTALADO

idSensor -> Chave Primária da tabela sensor
modeloSensor -> Modelo do sensor instalado
localInstalacao -> Localização do sensor
dataInstalacao -> Data em que o sensor foi instalado
statusSensor -> Status do sensor (0 ou 1 - Inativo ou Ativo)
ultimaManutencao -> Data da última manutenção do sensor
fkEstabelecimento -> Chave Estrangeira que liga a tabela sensor à tabela estabelecimento
*/
CREATE TABLE sensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
    modeloSensor VARCHAR(30),
    localSensor VARCHAR(80),
    dataInstalacao DATE,
    statusSensor TINYINT,
    ultimaManutencao DATE,
    fkEstabelecimento INT,
    FOREIGN KEY (fkEstabelecimento)
		REFERENCES estabelecimento (idEstabelecimento)
);


/*
CRIANDO A TABELA leituraSensor

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR TODAS AS LEITURAS REALIZADAS PELO SENSOR

idLeitura -> Chave Primária da tabela leituraSensor
ppm -> Leitura do nível de ppm do ambiente
dataHora -> Data e Hora em que a leitura foi realizada
situacao -> Estado em que o ambiente se encontra (Normal, Risco ou Crítico)
fkSensor -> Chave Estrangeira que liga a tabela leituraSensor à tabela Sensor
*/
CREATE TABLE leituraSensor(
	idLeitura INT NOT NULL auto_increment,
    ppm DECIMAL(9,2),
    dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
    situacao VARCHAR(20),
    /*CONSTRAINT chkSituacao CHECK(
		(ppm <= 300 AND situacao = 'NORMAL')
        OR (ppm > 300 AND ppm < 1000 AND situacao = 'RISCO')
        OR (ppm >= 1000 AND situacao = 'CRITICO')),*/
    fkSensor INT NOT NULL,
    FOREIGN KEY (fkSensor)
		REFERENCES sensor (idSensor),
	PRIMARY KEY (IdLeitura, fkSensor)
);


-- INSERÇÃO DOS DADOS NA TABELA endereco
INSERT INTO endereco VALUES
	(DEFAULT, '05171-000', 'Av. Santa Mônica', 'Pirituba', '655', 'São Paulo', 'SP', NULL),
    (DEFAULT, '01451-000', 'Av. Brigadeiro Faria Lima', 'Jardim Paulistano', '2705', 'São Paulo', 'SP', NULL),
    (DEFAULT, '04010-000', 'Rua Domingos de Morais', 'Vila Mariana', '90', 'São Paulo', 'SP', NULL),
    (DEFAULT, '01235-000', 'Rua Traipu', 'Perdizes', '551', 'São Paulo', 'SP', NULL),
    (DEFAULT, '03336-010', 'Rua Cândido Lacerda', 'Jardim Analia Franco', '33', 'São Paulo', 'SP', NULL),
    (DEFAULT, '01328-010', 'Rua Manoel Dutra', 'Bela Vista', '498', 'São Paulo', 'SP', NULL),
    (DEFAULT, '05089-001', 'Av. Imperatriz Leopoldina', 'Vila Leopoldina', '553', 'São Paulo', 'SP', NULL),
    (DEFAULT, '02436-000', 'Rua Sousa Lopes', 'Mandaqui', '283', 'São Paulo', 'SP', NULL),
    (DEFAULT, '02068-010', 'Rua Jacuna', 'Carandiru', '302', 'São Paulo', 'SP', NULL),
    (DEFAULT, '02219-001', 'Av. Nossa Sra. do Loreto', 'Vila Medeiros', '1100', 'São Paulo', 'SP', NULL);
    

-- INSERÇÃO DOS DADOS NA TABELA empresa
INSERT INTO empresa VALUES
	(DEFAULT, 'JTL Lanchonete LTDA - ME', 'A Casa da Esfiha', '52845530000134', '(11)4508-9444', NULL, 1),
    (DEFAULT, 'Capim Restaurante e Eventos LTDA.', 'Capim Santo', '07338081000183', '(11)3032-2277', NULL, 2),
    (DEFAULT, 'Restaurante O Benedito LTDA', 'Benedita 2', '64441410000150', '(11)94158-0250', NULL, 3),
    (DEFAULT, 'Fat Buddha Comercio de Alimentos LTDA', 'Fat Buddha', '42081535000184', '(11)98837-0473', NULL, 4),
    (DEFAULT, 'Empório Vila Anália LTDA', 'Complexo Gastronômico Vila Anália', '45214030000139 ', '(11)2674-0843', NULL, 5),
    (DEFAULT, 'Restaurante Ramos da Terra LTDA - ME', 'Rancho Nordestino', '52984913000193', '(11)2548-4092', NULL, 6),
    (DEFAULT, 'Bar e Restaurante Terramar LTDA', 'Terra Mar', '45643322000197', '(11)2614-2460', NULL, 7),
    (DEFAULT, 'Comida de Porteco LTDA', 'Comida de Porteco', '54424066000138', '(11)97883-6019', NULL, 8),
    (DEFAULT, 'Divina Corte Alimentos LTDA', 'LeLui Bar e Cozinha', '31119575000151', '(11)2251-1531', NULL, 9),
    (DEFAULT, 'Mocoto Restaurante e Cachacaria LTDA', 'Mocoto Bar e Restaurante', '46179149000180', '(11)2951-3056', NULL, 10);


-- INSERÇÃO DOS DADOS NA TABELA estabelecimento
INSERT INTO estabelecimento VALUES
	(DEFAULT, 'A Casa da Esfiha', 'Alimentação/Fast Food e Culinária Árabe', '52845530000134', 1, 1),
	(DEFAULT, 'Capim Santo', 'Alimentação/Cozinha Brasileira', '07338081000183', 2, 2),
	(DEFAULT, 'Benedita 2', 'Alimentação/Restaurante Self-Service', '64441410000150', 3, 3),
	(DEFAULT, 'Fat Buddha', 'Alimentação/Culinária Asiática Fast-Casual', '42081535000184', 4, 4),
	(DEFAULT, 'Complexo Gastronômico Vila Anália', 'Alimentação/Alta Gastronomia Internacional', '45214030000139', 5, 5),
	(DEFAULT, 'Rancho Nordestino', 'Alimentação/Culinária Regional Nordestina', '52984913000193', 6, 6),
	(DEFAULT, 'Terra Mar', 'Alimentação/Restaurante Self-Service e Bar', '45643322000197', 7, 7),
	(DEFAULT, 'Comida de Porteco', 'Alimentação/Bar, Restaurante e Petiscaria', '54424066000138', 8, 8),
	(DEFAULT, 'LeLui Bar e Cozinha', 'Alimentação/Cozinha Mediterrânea/Ibérica', '31119575000151', 9, 9),
	(DEFAULT, 'Mocotó Bar e Restaurante', 'Alimentação/Culinária Sertaneja/Nordestina', '46179149000180', 10, 10);


-- INSERÇÃO DOS DADOS NA TABELA sensor
INSERT INTO sensor VALUES (DEFAULT, 'MQ-2', 'Central de Cilindros GLP - Junto ao Piso', '2026-03-15', 1,'2026-08-10', 1),
	(DEFAULT, 'MQ-2', 'Cozinha Principal/Atrás do Fogão Industrial', '2026-03-15', 0, '2026-09-13', 2),
	(DEFAULT, 'MQ-2', 'Cozinha Principal/Próximo ao Forno de Lastro', '2026-02-20', 0, '2026-08-14', 3),
	(DEFAULT, 'MQ-2', 'Próximo à Tubulação Primária de Gás/Entrada da Cozinha', '2026-04-16', 1, NULL, 4),
	(DEFAULT, 'MQ-2', 'Cozinha de Apoio/Confeitaria - Base do Fogão', '2026-01-02', 1, '2026-07-22', 5),
	(DEFAULT, 'MQ-2', 'Área de Fritadeiras a Gás - Canto Inferior da Parede', '2026-02-11', 1, '2026-10-10', 6),
	(DEFAULT, 'MQ-2', 'Abrigo de Medidores de Gás - Base Interna', '2026-05-18', 1, NULL, 7),
	(DEFAULT, 'MQ-2', 'Próximo à Válvula de Bloqueio Geral de Gás', '2026-02-09', 0, '2026-09-15', 8),
	(DEFAULT, 'MQ-2', 'Salão - Próximo à Coleta de Aquecedores a Gás', '2026-05-10', 1, NULL, 9),
	(DEFAULT, 'MQ-2', 'Área Técnica de Manutenção - Shaft de Tubulações de Gás', '2026-01-15', 1, '2026-06-30', 10);
    
    
-- SELECTS COM JOIN
SELECT s.idSensor, s.localSensor,
CASE 
	WHEN s.statusSensor = 1 THEN 'Ativo'
    ELSE 'Inativo'
END AS StatusSensor,
e.nome, e.segmento 
FROM sensor AS s
JOIN estabelecimento AS e
	ON e.idEstabelecimento = s.fkEstabelecimento;
    
SELECT em.idEmpresa, em.razaoSocial, es.nome, en.cep, en.logradouro, en.bairro 
FROM empresa AS em
JOIN estabelecimento AS es
	ON em.idEmpresa = es.fkEmpresa
JOIN endereco AS en
	ON en.idEndereco = es.fkEndereco;
    
SELECT u.nome, u.email, u.dataCadastro, e.nome, e.segmento
FROM usuario AS u
JOIN estabelecimento AS e
	ON e.idEstabelecimento = u.fkEstabelecimento;
    
    
-- SCRIPTS NA VM (LINUX) ABAIXO

-- CRIANDO O BANCO DE DADOS
CREATE DATABASE anzen_glp;


-- SELECIONANDO O BANCO DE DADOS PARA USO
USE anzen_glp;


-- CRIANDO A TABELA endereco
CREATE TABLE endereco(idEndereco INT PRIMARY KEY AUTO_INCREMENT, cep CHAR(9), logradouro VARCHAR(90), bairro VARCHAR(90), numero VARCHAR(10), cidade VARCHAR(45), uf CHAR(2), complemento VARCHAR(45));


-- CRIANDO A TABELA empresa
CREATE TABLE empresa(idEmpresa INT PRIMARY KEY AUTO_INCREMENT, razaoSocial VARCHAR(90), nomeFantasia VARCHAR(90), cnpjMatriz CHAR(14), telefoneContato VARCHAR(20), emailContato VARCHAR(90), fkEndereco INT, FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco));


-- CRIANDO A TABELA estabelecimento
CREATE TABLE estabelecimento(idEstabelecimento INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(45), segmento VARCHAR(50), cnpjFilial CHAR(14), fkEmpresa INT, fkEndereco INT, FOREIGN KEY (fkEmpresa) REFERENCES empresa (idEmpresa), FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco));


-- CRIANDO A TABELA usuario
CREATE TABLE usuario(idUsuario INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(40), dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP, email VARCHAR(90), senha VARCHAR(45), fkEstabelecimento INT, FOREIGN KEY (fkEstabelecimento) REFERENCES estabelecimento (idEstabelecimento));


-- CRIANDO A TABELA sensor
CREATE TABLE sensor(idSensor INT PRIMARY KEY AUTO_INCREMENT, modeloSensor VARCHAR(30), localSensor VARCHAR(80), dataInstalacao DATE, statusSensor TINYINT, ultimaManutencao DATE, fkEstabelecimento INT, FOREIGN KEY (fkEstabelecimento) REFERENCES estabelecimento (idEstabelecimento));


-- CRIANDO A TABELA leituraSensor
CREATE TABLE leituraSensor(idLeitura INT NOT NULL, ppm DECIMAL(9,2), dataHora DATETIME DEFAULT CURRENT_TIMESTAMP, situacao VARCHAR(20));


-- INSERINDO OS DADOS NA TABELA endereco
INSERT INTO endereco VALUES (DEFAULT, '05171-000', 'Av. Santa Mônica', 'Pirituba', '655', 'São Paulo', 'SP', NULL), (DEFAULT, '01451-000', 'Av. Brigadeiro Faria Lima', 'Jardim Paulistano', '2705', 'São Paulo', 'SP', NULL), (DEFAULT, '04010-000', 'Rua Domingos de Morais', 'Vila Mariana', '90', 'São Paulo', 'SP', NULL), (DEFAULT, '01235-000', 'Rua Traipu', 'Perdizes', '551', 'São Paulo', 'SP', NULL), (DEFAULT, '03336-010', 'Rua Cândido Lacerda', 'Jardim Analia Franco', '33', 'São Paulo', 'SP', NULL), (DEFAULT, '01328-010', 'Rua Manoel Dutra', 'Bela Vista', '498', 'São Paulo', 'SP', NULL), (DEFAULT, '05089-001', 'Av. Imperatriz Leopoldina', 'Vila Leopoldina', '553', 'São Paulo', 'SP', NULL), (DEFAULT, '02436-000', 'Rua Sousa Lopes', 'Mandaqui', '283', 'São Paulo', 'SP', NULL), (DEFAULT, '02068-010', 'Rua Jacuna', 'Carandiru', '302', 'São Paulo', 'SP', NULL), (DEFAULT, '02219-001', 'Av. Nossa Sra. do Loreto', 'Vila Medeiros', '1100', 'São Paulo', 'SP', NULL);


-- INSERINDO OS DADOS NA TABELA empresa
INSERT INTO empresa VALUES (DEFAULT, 'JTL Lanchonete LTDA - ME', 'A Casa da Esfiha', '52845530000134', '(11)4508-9444', NULL, 1), (DEFAULT, 'Capim Restaurante e Eventos LTDA.', 'Capim Santo', '07338081000183', '(11)3032-2277', NULL, 2), (DEFAULT, 'Restaurante O Benedito LTDA', 'Benedita 2', '64441410000150', '(11)94158-0250', NULL, 3), (DEFAULT, 'Fat Buddha Comercio de Alimentos LTDA', 'Fat Buddha', '42081535000184', '(11)98837-0473', NULL, 4), (DEFAULT, 'Empório Vila Anália LTDA', 'Complexo Gastronômico Vila Anália', '45214030000139 ', '(11)2674-0843', NULL, 5), (DEFAULT, 'Restaurante Ramos da Terra LTDA - ME', 'Rancho Nordestino', '52984913000193', '(11)2548-4092', NULL, 6), (DEFAULT, 'Bar e Restaurante Terramar LTDA', 'Terra Mar', '45643322000197', '(11)2614-2460', NULL, 7), (DEFAULT, 'Comida de Porteco LTDA', 'Comida de Porteco', '54424066000138', '(11)97883-6019', NULL, 8), (DEFAULT, 'Divina Corte Alimentos LTDA', 'LeLui Bar e Cozinha', '31119575000151', '(11)2251-1531', NULL, 9), (DEFAULT, 'Mocoto Restaurante e Cachacaria LTDA', 'Mocoto Bar e Restaurante', '46179149000180', '(11)2951-3056', NULL, 10);


-- INSERINDO OS DADOS NA TABELA estabelecimento
INSERT INTO estabelecimento VALUES (DEFAULT, 'A Casa da Esfiha', 'Alimentação/Fast Food e Culinária Árabe', '52845530000134', 1, 1), (DEFAULT, 'Capim Santo', 'Alimentação/Cozinha Brasileira', '07338081000183', 2, 2), (DEFAULT, 'Benedita 2', 'Alimentação/Restaurante Self-Service', '64441410000150', 3, 3), (DEFAULT, 'Fat Buddha', 'Alimentação/Culinária Asiática Fast-Casual', '42081535000184', 4, 4), (DEFAULT, 'Complexo Gastronômico Vila Anália', 'Alimentação/Alta Gastronomia Internacional', '45214030000139', 5, 5), (DEFAULT, 'Rancho Nordestino', 'Alimentação/Culinária Regional Nordestina', '52984913000193', 6, 6), (DEFAULT, 'Terra Mar', 'Alimentação/Restaurante Self-Service e Bar', '45643322000197', 7, 7), (DEFAULT, 'Comida de Porteco', 'Alimentação/Bar, Restaurante e Petiscaria', '54424066000138', 8, 8), (DEFAULT, 'LeLui Bar e Cozinha', 'Alimentação/Cozinha Mediterrânea/Ibérica', '31119575000151', 9, 9), (DEFAULT, 'Mocotó Bar e Restaurante', 'Alimentação/Culinária Sertaneja/Nordestina', '46179149000180', 10, 10);


-- INSERINDO OS DADOS NA TABELA sensor
INSERT INTO sensor VALUES (DEFAULT, 'MQ-2', 'Central de Cilindros GLP - Junto ao Piso', '2026-03-15', 1,'2026-08-10', 1), (DEFAULT, 'MQ-2', 'Cozinha Principal/Atrás do Fogão Industrial', '2026-03-15', 0, '2026-09-13', 2), (DEFAULT, 'MQ-2', 'Cozinha Principal/Próximo ao Forno de Lastro', '2026-02-20', 0, '2026-08-14', 3), (DEFAULT, 'MQ-2', 'Próximo à Tubulação Primária de Gás/Entrada da Cozinha', '2026-04-16', 1, NULL, 4), (DEFAULT, 'MQ-2', 'Cozinha de Apoio/Confeitaria - Base do Fogão', '2026-01-02', 1, '2026-07-22', 5), (DEFAULT, 'MQ-2', 'Área de Fritadeiras a Gás - Canto Inferior da Parede', '2026-02-11', 1, '2026-10-10', 6), (DEFAULT, 'MQ-2', 'Abrigo de Medidores de Gás - Base Interna', '2026-05-18', 1, NULL, 7), (DEFAULT, 'MQ-2', 'Próximo à Válvula de Bloqueio Geral de Gás', '2026-02-09', 0, '2026-09-15', 8), (DEFAULT, 'MQ-2', 'Salão - Próximo à Coleta de Aquecedores a Gás', '2026-05-10', 1, NULL, 9), (DEFAULT, 'MQ-2', 'Área Técnica de Manutenção - Shaft de Tubulações de Gás', '2026-01-15', 1, '2026-06-30', 10);


-- SELECTS COM JOIN
SELECT s.idSensor, s.localSensor, CASE WHEN s.statusSensor = 1 THEN 'Ativo' ELSE 'Inativo' END AS StatusSensor, e.nome, e.segmento  FROM sensor AS s JOIN estabelecimento AS e ON e.idEstabelecimento = s.fkEstabelecimento;
  
  
SELECT em.idEmpresa, em.razaoSocial, es.nome, en.cep, en.logradouro, en.bairro FROM empresa AS em JOIN estabelecimento AS es ON em.idEmpresa = es.fkEmpresa JOIN endereco AS en ON en.idEndereco = es.fkEndereco;
  
  
SELECT u.nome, u.email, u.dataCadastro, e.nome, e.segmento FROM usuario AS u JOIN estabelecimento AS e ON e.idEstabelecimento = u.fkEstabelecimento;