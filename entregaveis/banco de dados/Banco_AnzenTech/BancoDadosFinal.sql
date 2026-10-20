CREATE DATABASE anzen_glp;
USE anzen_glp;
drop database anzen_glp;
-- empresa: agora guarda tudo o que o cadastro (cadastro.html) pede no passo 2 e 3
--   nome_empresa       <- "Nome da empresa"
--   segmento           <- "Segmento"
--   faixa_funcionarios <- "Número de funcionários"
--   qtd_cozinhas       <- "Quantas cozinhas deseja monitorar?"
--   email              <- "E-mail para receber alertas"
CREATE TABLE empresa (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    nome_empresa VARCHAR(120) NOT NULL,
    cnpj VARCHAR(18) NULL UNIQUE,
    email VARCHAR(120) NULL,
    telefone VARCHAR(25) NULL,
    segmento VARCHAR(60) NULL,
    faixa_funcionarios VARCHAR(30) NULL,
    qtd_cozinhas INT NULL
);

-- cadastro: o usuário que se cadastra no passo 1 (nome, e-mail e senha)
-- A senha NUNCA é salva em texto puro: a API grava o hash em senha_hash.
CREATE TABLE cadastro (
    id_cadastro INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    perfil VARCHAR(30) NOT NULL,   -- quem cria a empresa no cadastro recebe 'ADMIN'
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

-- ambiente = cozinha. A API cria "Cozinha 1", "Cozinha 2"... conforme qtd_cozinhas
CREATE TABLE ambiente (
    id_ambiente INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NULL,
    localizacao VARCHAR(255) NULL,
    observacao_ventilacao VARCHAR(255) NULL,
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    id_ambiente INT NOT NULL,
    identificador VARCHAR(60) NOT NULL UNIQUE,
    modelo VARCHAR(60) NOT NULL DEFAULT 'MQ-2',
    altura_instalacao_cm DECIMAL(5,2) NULL,
    limite_alerta_ppm DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO',
    data_instalacao DATE NULL,
    FOREIGN KEY (id_ambiente) REFERENCES ambiente(id_ambiente)
);

CREATE TABLE leitura_sensor (
    id_sensor INT NOT NULL,
    numero_leitura BIGINT UNSIGNED NOT NULL,
    data_hora DATETIME(3) NOT NULL,
    valor_ppm DECIMAL(10,2) NOT NULL,
    limite_utilizado_ppm DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_sensor, numero_leitura),
    FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
);

CREATE TABLE alerta (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT NOT NULL,
    numero_leitura BIGINT UNSIGNED NOT NULL,
    id_cadastro_responsavel INT NULL,
    data_hora_alerta DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    status VARCHAR(25) NOT NULL DEFAULT 'ABERTO',
    mensagem VARCHAR(255) NOT NULL,
    acao_tomada TEXT NULL,
    data_hora_atendimento DATETIME(3) NULL,
    UNIQUE (id_sensor, numero_leitura),
    FOREIGN KEY (id_sensor, numero_leitura)
        REFERENCES leitura_sensor(id_sensor, numero_leitura),
    FOREIGN KEY (id_cadastro_responsavel)
        REFERENCES cadastro(id_cadastro)
);

-- NOVA: formulário "Fale com a AnzenTech" da página inicial (index.html)
CREATE TABLE contato (
    id_contato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    whatsapp VARCHAR(15) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------------
-- EXEMPLO (opcional, para simulação): criar um sensor numa cozinha da empresa 1
-- e depois testar a API de leituras. Descomente e ajuste os ids.
-- INSERT INTO sensor (id_ambiente, identificador, limite_alerta_ppm)
--     VALUES (1, 'MQ2-COZINHA-01', 1000);
-- ---------------------------------------------------------------------------



select * from cadastro;
select * from empresa;
select * from contato;


