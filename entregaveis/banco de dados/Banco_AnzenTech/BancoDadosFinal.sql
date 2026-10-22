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
    cep CHAR(8),
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
    segmento VARCHAR(45),
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
    dataCadastro DATE,
    email VARCHAR(90),
    senha VARCHAR(45),
    fkEstabelecimento INT,
	FOREIGN KEY (fkEstabelecimento) 
		REFERENCES estabelecimento (idUsuario)
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
    localInstalacao VARCHAR(50),
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
    ppm DECIMAL(7,2),
    dataHora DATETIME default current_timestamp,
    situacao VARCHAR(20),
    CONSTRAINT chkSituacao CHECK(
		(ppm <= 300 AND situacao = 'Normal')
        OR (ppm > 300 AND ppm < 1000 AND situacao = 'Risco')
        OR (ppm >= 1000 AND situacao = 'Crítico')),
    fkSensor INT NOT NULL,
    FOREIGN KEY (fkSensor)
		REFERENCES sensor (idSensor),
	PRIMARY KEY (IdLeitura, fkSensor)
);