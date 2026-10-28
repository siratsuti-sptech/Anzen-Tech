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
CRIANDO A TABELA estabelecimento

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR OS PRINCIPAIS DADOS DOS ESTABELECIMENTOS

idEstabelecimento -> chave primária da tabela estabelecimento
nome -> nome do estabelecimento
segmento -> segmento de mercado do estabelecimento
cnpjFilial -> CNPJ da Filial
fkEmpresa -> chave estrangeira que cria o autorrelacionamento na tabela estabelecimento
fkEndereco -> chave estrangeira que liga a tabela estabelecimento à tabela endereco
*/
CREATE TABLE estabelecimento(
	idEstabelecimento INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(90),
    nomeFantasia VARCHAR(90),
    tipo VARCHAR(10),
    cnpj CHAR(14),
    segmento VARCHAR(50),
    idMatriz INT,
    fkEndereco INT,
    FOREIGN KEY (idMatriz)
		REFERENCES estabelecimento (idEstabelecimento),
	FOREIGN KEY (fkEndereco)
		REFERENCES endereco(idEndereco)
);


/*
CRIANDO A TABELA contato

ESSA TABELA É RESPONSÁVEL POR ARMAZENAR TODOS OS CONTATOS DOS ESTABELECIMENTOS

idContato -> Chave Primária da tabela contato
email -> e-mail de contato
telefone -> telefone de contato
fkEstabelecimento -> Chave Estrangeira que liga a tabela contato à tabela estabelecimento
*/
CREATE TABLE contato (
	idContato INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(90),
    telefone VARCHAR(15),
    fkEstabelecimento INT,
    FOREIGN KEY(fkEstabelecimento)
		REFERENCES estabelecimento(idEstabelecimento)
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
    sobrenome VARCHAR(40),
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
	idLeitura INT NOT NULL,
    ppm DECIMAL(9,2),
    dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
    situacao VARCHAR(20)
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
    

-- INSERÇÃO DOS DADOS NA TABELA estabelecimento
INSERT INTO estabelecimento VALUES
    (DEFAULT, 'JTL Lanchonete LTDA - ME', 'A Casa da Esfiha', 'Matriz', '52845530000134', 'Fast Food e Culinária Árabe', NULL, 1),
    (DEFAULT, 'Capim Restaurante e Eventos LTDA.', 'Capim Santo', 'Matriz', '07338081000183', 'Cozinha Brasileira', NULL, 2),
    (DEFAULT, 'Restaurante O Benedito LTDA', 'Benedita 2', 'Matriz', '64441410000150', 'Restaurante Self-Service', NULL, 3),
    (DEFAULT, 'Fat Buddha Comercio de Alimentos LTDA', 'Fat Buddha', 'Matriz', '42081535000184', 'Culinária Asiática Fast-Casual', NULL, 4),
    (DEFAULT, 'Empório Vila Anália LTDA', 'Complexo Gastronômico Vila Anália', 'Matriz', '45214030000139', 'Alta Gastronomia Internacional', NULL, 5),
    (DEFAULT, 'Restaurante Ramos da Terra LTDA - ME', 'Rancho Nordestino', 'Matriz', '52984913000193', 'Culinária Regional Nordestina', NULL, 6),
    (DEFAULT, 'Bar e Restaurante Terramar LTDA', 'Terra Mar', 'Matriz', '45643322000197', 'Restaurante Self-Service e Bar', NULL, 7),
    (DEFAULT, 'Comida de Porteco LTDA', 'Comida de Porteco', 'Matriz', '54424066000138', 'Bar, Restaurante e Petiscaria', NULL, 8),
    (DEFAULT, 'Divina Corte Alimentos LTDA', 'LeLui Bar e Cozinha', 'Matriz', '31119575000151', 'Cozinha Mediterrânea/Ibérica', NULL, 9),
    (DEFAULT, 'Mocoto Restaurante e Cachacaria LTDA', 'Mocotó Bar e Restaurante', 'Matriz', '46179149000180', 'Culinária Sertaneja/Nordestina', NULL, 10);
    
    
-- INSERÇÃO DOS DADOS NA TABELA contato
INSERT INTO contato VALUES
    (DEFAULT, NULL, '(11)4508-9444', 1),
    (DEFAULT, NULL, '(11)3032-2277', 2),
    (DEFAULT, NULL, '(11)94158-0250', 3),
    (DEFAULT, NULL, '(11)98837-0473', 4),
    (DEFAULT, NULL, '(11)2674-0843', 5),
    (DEFAULT, NULL, '(11)2548-4092', 6),
    (DEFAULT, NULL, '(11)2614-2460', 7),
    (DEFAULT, NULL, '(11)97883-6019', 8),
    (DEFAULT, NULL, '(11)2251-1531', 9),
    (DEFAULT, NULL, '(11)2951-3056', 10);


-- INSERÇÃO DOS DADOS NA TABELA sensor
INSERT INTO sensor VALUES 
	(DEFAULT, 'MQ-2', 'Central de Cilindros GLP - Junto ao Piso', '2026-03-15', 1,'2026-08-10', 1),
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
		WHEN s.statusSensor = 1 THEN 'Ativo' ELSE 'Inativo' 
	END AS 'Status do Sensor',
e.nomeFantasia, e.segmento
FROM sensor AS s
JOIN estabelecimento AS e 
	ON e.idEstabelecimento = s.fkEstabelecimento;
    
SELECT IFNULL(m.idEstabelecimento, es.idEstabelecimento) AS 'ID da Empresa',
       IFNULL(m.razaoSocial, es.razaoSocial) AS 'Razão Social',
es.nomeFantasia AS Estabelecimento, es.tipo, en.cep, en.logradouro, en.bairro
FROM estabelecimento AS es
LEFT JOIN estabelecimento AS m 
	ON m.idEstabelecimento = es.idMatriz
JOIN endereco AS en 
	ON en.idEndereco = es.fkEndereco;
    
SELECT u.nome, u.sobrenome, u.email, u.dataCadastro, e.nomeFantasia, e.segmento
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


-- CRIANDO A TABELA estabelecimento
CREATE TABLE estabelecimento(idEstabelecimento INT PRIMARY KEY AUTO_INCREMENT, razaoSocial VARCHAR(90), nomeFantasia VARCHAR(90), tipo VARCHAR(10), cnpj CHAR(14), segmento VARCHAR(50), idMatriz INT, fkEndereco INT, FOREIGN KEY (idMatriz) REFERENCES estabelecimento (idEstabelecimento), FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco));


-- CRIANDO A TABELA contato
CREATE TABLE contato (
	idContato INT PRIMARY KEY AUTO_INCREMENT, email VARCHAR(90), telefone VARCHAR(15), fkEstabelecimento INT, FOREIGN KEY(fkEstabelecimento) REFERENCES estabelecimento(idEstabelecimento));


-- CRIANDO A TABELA usuario
CREATE TABLE usuario(idUsuario INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(40), dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP, email VARCHAR(90), senha VARCHAR(45), fkEstabelecimento INT, FOREIGN KEY (fkEstabelecimento) REFERENCES estabelecimento (idEstabelecimento));


-- CRIANDO A TABELA sensor
CREATE TABLE sensor(idSensor INT PRIMARY KEY AUTO_INCREMENT, modeloSensor VARCHAR(30), localSensor VARCHAR(80), dataInstalacao DATE, statusSensor TINYINT, ultimaManutencao DATE, fkEstabelecimento INT, FOREIGN KEY (fkEstabelecimento) REFERENCES estabelecimento (idEstabelecimento));


-- CRIANDO A TABELA leituraSensor
CREATE TABLE leituraSensor(idLeitura INT NOT NULL, ppm DECIMAL(9,2), dataHora DATETIME DEFAULT CURRENT_TIMESTAMP, situacao VARCHAR(20));


-- INSERINDO OS DADOS NA TABELA endereco
INSERT INTO endereco VALUES (DEFAULT, '05171-000', 'Av. Santa Mônica', 'Pirituba', '655', 'São Paulo', 'SP', NULL), (DEFAULT, '01451-000', 'Av. Brigadeiro Faria Lima', 'Jardim Paulistano', '2705', 'São Paulo', 'SP', NULL), (DEFAULT, '04010-000', 'Rua Domingos de Morais', 'Vila Mariana', '90', 'São Paulo', 'SP', NULL), (DEFAULT, '01235-000', 'Rua Traipu', 'Perdizes', '551', 'São Paulo', 'SP', NULL), (DEFAULT, '03336-010', 'Rua Cândido Lacerda', 'Jardim Analia Franco', '33', 'São Paulo', 'SP', NULL), (DEFAULT, '01328-010', 'Rua Manoel Dutra', 'Bela Vista', '498', 'São Paulo', 'SP', NULL), (DEFAULT, '05089-001', 'Av. Imperatriz Leopoldina', 'Vila Leopoldina', '553', 'São Paulo', 'SP', NULL), (DEFAULT, '02436-000', 'Rua Sousa Lopes', 'Mandaqui', '283', 'São Paulo', 'SP', NULL), (DEFAULT, '02068-010', 'Rua Jacuna', 'Carandiru', '302', 'São Paulo', 'SP', NULL), (DEFAULT, '02219-001', 'Av. Nossa Sra. do Loreto', 'Vila Medeiros', '1100', 'São Paulo', 'SP', NULL);


-- INSERINDO OS DADOS NA TABELA estabelecimento
INSERT INTO estabelecimento VALUES (DEFAULT, 'JTL Lanchonete LTDA - ME', 'A Casa da Esfiha', 'Matriz', '52845530000134', 'Fast Food e Culinária Árabe', NULL, 1), (DEFAULT, 'Capim Restaurante e Eventos LTDA.', 'Capim Santo', 'Matriz', '07338081000183', 'Cozinha Brasileira', NULL, 2), (DEFAULT, 'Restaurante O Benedito LTDA', 'Benedita 2', 'Matriz', '64441410000150', 'Restaurante Self-Service', NULL, 3), (DEFAULT, 'Fat Buddha Comercio de Alimentos LTDA', 'Fat Buddha', 'Matriz', '42081535000184', 'Culinária Asiática Fast-Casual', NULL, 4), (DEFAULT, 'Empório Vila Anália LTDA', 'Complexo Gastronômico Vila Anália', 'Matriz', '45214030000139', 'Alta Gastronomia Internacional', NULL, 5), (DEFAULT, 'Restaurante Ramos da Terra LTDA - ME', 'Rancho Nordestino', 'Matriz', '52984913000193', 'Culinária Regional Nordestina', NULL, 6), (DEFAULT, 'Bar e Restaurante Terramar LTDA', 'Terra Mar', 'Matriz', '45643322000197', 'Restaurante Self-Service e Bar', NULL, 7), (DEFAULT, 'Comida de Porteco LTDA', 'Comida de Porteco', 'Matriz', '54424066000138', 'Bar, Restaurante e Petiscaria', NULL, 8), (DEFAULT, 'Divina Corte Alimentos LTDA', 'LeLui Bar e Cozinha', 'Matriz', '31119575000151', 'Cozinha Mediterrânea/Ibérica', NULL, 9), (DEFAULT, 'Mocoto Restaurante e Cachacaria LTDA', 'Mocotó Bar e Restaurante', 'Matriz', '46179149000180', 'Culinária Sertaneja/Nordestina', NULL, 10);
    

-- INSERINDO OS DADOS NA TABELA contato
INSERT INTO contato VALUES (DEFAULT, NULL, '(11)4508-9444', 1), (DEFAULT, NULL, '(11)3032-2277', 2), (DEFAULT, NULL, '(11)94158-0250', 3), (DEFAULT, NULL, '(11)98837-0473', 4), (DEFAULT, NULL, '(11)2674-0843', 5), (DEFAULT, NULL, '(11)2548-4092', 6), (DEFAULT, NULL, '(11)2614-2460', 7), (DEFAULT, NULL, '(11)97883-6019', 8), (DEFAULT, NULL, '(11)2251-1531', 9), (DEFAULT, NULL, '(11)2951-3056', 10);
    
    
-- INSERINDO OS DADOS NA TABELA sensor
INSERT INTO sensor VALUES (DEFAULT, 'MQ-2', 'Central de Cilindros GLP - Junto ao Piso', '2026-03-15', 1,'2026-08-10', 1), (DEFAULT, 'MQ-2', 'Cozinha Principal/Atrás do Fogão Industrial', '2026-03-15', 0, '2026-09-13', 2), (DEFAULT, 'MQ-2', 'Cozinha Principal/Próximo ao Forno de Lastro', '2026-02-20', 0, '2026-08-14', 3), (DEFAULT, 'MQ-2', 'Próximo à Tubulação Primária de Gás/Entrada da Cozinha', '2026-04-16', 1, NULL, 4), (DEFAULT, 'MQ-2', 'Cozinha de Apoio/Confeitaria - Base do Fogão', '2026-01-02', 1, '2026-07-22', 5), (DEFAULT, 'MQ-2', 'Área de Fritadeiras a Gás - Canto Inferior da Parede', '2026-02-11', 1, '2026-10-10', 6), (DEFAULT, 'MQ-2', 'Abrigo de Medidores de Gás - Base Interna', '2026-05-18', 1, NULL, 7), (DEFAULT, 'MQ-2', 'Próximo à Válvula de Bloqueio Geral de Gás', '2026-02-09', 0, '2026-09-15', 8), (DEFAULT, 'MQ-2', 'Salão - Próximo à Coleta de Aquecedores a Gás', '2026-05-10', 1, NULL, 9), (DEFAULT, 'MQ-2', 'Área Técnica de Manutenção - Shaft de Tubulações de Gás', '2026-01-15', 1, '2026-06-30', 10);


-- SELECTS COM JOIN
SELECT s.idSensor, s.localSensor, CASE WHEN s.statusSensor = 1 THEN 'Ativo' ELSE 'Inativo' END AS 'Status do Sensor', e.nomeFantasia, e.segmento  FROM sensor AS s JOIN estabelecimento AS e ON e.idEstabelecimento = s.fkEstabelecimento;
  
  
SELECT em.idEmpresa, em.razaoSocial, es.nome, en.cep, en.logradouro, en.bairro FROM empresa AS em JOIN estabelecimento AS es ON em.idEmpresa = es.fkEmpresa JOIN endereco AS en ON en.idEndereco = es.fkEndereco;
  
  
SELECT u.nome, u.sobrenome, u.email, u.dataCadastro, e.nome, e.segmento FROM usuario AS u JOIN estabelecimento AS e ON e.idEstabelecimento = u.fkEstabelecimento;