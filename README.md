<p align="center">
  <img width="1280" height="300" alt="Vamos com Tudo!(2)" src="https://github.com/user-attachments/assets/529106f6-48f6-4144-b581-234ee30f9213" />
</p>


<h1 align="center">Anzen Tech 安全テク</h1>

<p align="center">
  Sistema de Monitoramento e Detecção de Vazamento de Gás GLP
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arduino-UNO-00979D?logo=arduino&logoColor=white" alt="Arduino UNO">
  <img src="https://img.shields.io/badge/C%2FC%2B%2B-00599C?logo=cplusplus&logoColor=white" alt="C/C++">
  <img src="https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white" alt="HTML5">
  <img src="https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white" alt="CSS3">
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black" alt="JavaScript">
  <img src="https://img.shields.io/badge/Node.js-339933?logo=nodedotjs&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=white" alt="MySQL">
  <img src="https://img.shields.io/badge/status-em%20desenvolvimento-yellow" alt="Status">
</p>

---

## Sumário

- [Sobre o projeto](#sobre-o-projeto)
- [Visão de negócio](#visão-de-negócio)
- [Funcionalidades](#funcionalidades)
- [Arquitetura da solução](#arquitetura-da-solução)
- [Tecnologias](#tecnologias)
- [Hardware](#hardware)
- [Instalação](#instalação)
- [Como usar](#como-usar)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Limitações e aviso de segurança](#limitações-e-aviso-de-segurança)
- [Roadmap](#roadmap)
- [Equipe](#equipe)
- [Licença](#licença)

---

## Sobre o projeto

O **Anzen Tech** (安全テク, "tecnologia de segurança" em japonês) é um sistema de monitoramento e detecção de vazamento de gás GLP (gás de cozinha). Vazamentos de GLP são uma causa comum de incêndios, explosões e intoxicações domésticas, e muitas vezes passam despercebidos até ser tarde demais.

A solução usa um **Arduino UNO** com um **sensor MQ-2** para medir continuamente a concentração de gás no ambiente. Os dados são enviados para uma **aplicação web**, que exibe as leituras em tempo real, registra o histórico em banco de dados **MySQL** e sinaliza quando o nível de gás ultrapassa o limite de segurança.

**Objetivo:** oferecer um sistema de baixo custo que permita identificar vazamentos rapidamente e alertar os moradores antes que o risco se agrave.

---

## Visão de negócio

O diagrama abaixo mostra a jornada completa do sistema, do ponto de vista de quem usa: desde a instalação do sensor até a decisão do cliente diante de um alerta.

<p align="center">
  <img src="docs/images/visao_negocio.png" alt="Diagrama de visão de negócio com as 6 etapas do sistema" width="100%">
</p>

| # | Etapa | O que acontece |
|:---:|---|---|
| 1 | **Instalação do sensor** | O sensor é posicionado no ambiente, próximo à central de gás. |
| 2 | **Vazamento de gás** | Ocorre um vazamento de gás. |
| 3 | **Detecção do sensor** | O sensor captura a presença elevada de gás GLP no ambiente. |
| 4 | **Emissão do alerta** | O sistema emite um alerta sobre o vazamento para o cliente. |
| 5 | **Exibição na web** | O sistema exibe um gráfico de dados sobre o vazamento na web. |
| 6 | **Ação do cliente** | O cliente toma uma ação, evitando riscos, diminuindo prejuízos e salvando vidas. |

---

## Funcionalidades

- Leitura contínua da concentração de gás pelo sensor MQ-2
- Exibição dos dados em tempo real em um painel web
- Alerta visual quando o nível de gás ultrapassa o limite configurado
- Registro do histórico de leituras no MySQL
- API em Node.js que recebe os dados do Arduino e os disponibiliza para a interface web
- Interface web responsiva (HTML, CSS e JavaScript)

---

## Arquitetura da solução

O sistema roda em um computador físico (host) e é dividido em duas APIs em Node.js, com o banco de dados MySQL em uma máquina virtual:

1. O **Arduino UNO**, com o sensor MQ-2, envia as leituras ao computador pela porta serial (cabo USB).
2. A **API 1** (`data-aqc-ino`), em Node.js, lê a serial e grava as leituras no MySQL (*Insert*).
3. O **MySQL** fica em uma **VM Lubuntu (VirtualBox)** e guarda os dados.
4. A **API 2** (API web *data viz*), em Node.js, consulta o MySQL (*Select*) e serve os dados, além das páginas do site.
5. O **navegador** do gestor (HTML, CSS e JavaScript) consome a API 2 via HTTP e exibe o painel. O **cliente final** usa o sistema por esse navegador.

<p align="center">
  <img src="docs/images/diagrama_solucao.png" alt="Diagrama da solução: Arduino UNO, API 1, MySQL na VM Lubuntu, API 2 e navegador" width="100%">
</p>

### Fluxo de dados

| Origem | Destino | Meio | Descrição |
|---|---|---|---|
| Arduino UNO + MQ-2 | API 1 (`data-aqc-ino`) | USB (serial) | Envio das leituras do sensor |
| API 1 | MySQL (VM Lubuntu) | `INSERT` | Gravação do histórico de leituras |
| MySQL | API 2 (API web data viz) | `SELECT` | Consulta dos dados armazenados |
| API 2 | Navegador | HTTP | Entrega do site e dos dados para o painel |

---

## Tecnologias

| Área | Tecnologias |
|---|---|
| Hardware e embarcados | Arduino UNO, Sensor MQ-2, C/C++ (Arduino) |
| Back-end | Node.js (API 1 de aquisição e API 2 de visualização) |
| Aplicação web | HTML, CSS, JavaScript |
| Banco de dados | MySQL |
| Infraestrutura | VM Lubuntu no VirtualBox |
| Ferramentas | Git, Git Bash, VS Code, Arduino IDE |

---

## Hardware

### Componentes

| Componente | Quantidade |
|---|:---:|
| Placa Arduino UNO | 1 |
| Cabo USB de comunicação | 1 |
| Sensor de gás MQ-2 | 1 |
| Protoboard | 1 |
| Cabos jumper | 1 kit |

### Ligações (pinagem)

| MQ-2 | Arduino UNO |
|---|---|
| VCC | 5V |
| GND | GND |
| A0 (saída analógica) | A0 |

---

## Instalação

### Pré-requisitos

- [Git](https://git-scm.com/) (com Git Bash)
- [Node.js](https://nodejs.org/) 18 ou superior (inclui o npm)
- [Arduino IDE](https://www.arduino.cc/en/software)
- [MySQL](https://www.mysql.com/) 8.0 ou superior
- [Visual Studio Code](https://code.visualstudio.com/)
- [VirtualBox](https://www.virtualbox.org/) com a VM Lubuntu, caso o MySQL seja executado nela, como na arquitetura do projeto

### Passo a passo

**1. Clonar o repositório** (no Git Bash)

```bash
git clone https://github.com/seu-usuario/anzen-tech.git
cd anzen-tech
```

**2. Montar o circuito**

Monte o hardware conforme a seção [Hardware](#hardware) e conecte o Arduino ao computador pelo cabo USB.

**3. Gravar o código no Arduino**

1. Abra o arquivo `arduino/anzen_tech.ino` na Arduino IDE.
2. Selecione a placa **Arduino UNO** e a porta serial correta em *Ferramentas*.
3. Clique em **Carregar** (Upload).

**4. Configurar o banco de dados**

```bash
mysql -u root -p < database/schema.sql
```

**5. Configurar a API (Node.js)**

```bash
cd api
npm install
```

Crie um arquivo `.env` na pasta `api/` com as suas configurações (use o `.env.example` como modelo):

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=sua_senha
DB_NAME=anzen_tech
SERIAL_PORT=COM3        # Linux/macOS: /dev/ttyUSB0 ou /dev/ttyACM0
SERIAL_BAUD_RATE=9600
```

> Se o MySQL estiver na VM, use o IP da VM em `DB_HOST`.

**6. Iniciar a API**

```bash
npm start
```

A API ficará disponível em `http://localhost:3000`.

**7. Abrir a interface web**

Abra o arquivo `web/index.html` no navegador (ou use a extensão *Live Server* do VS Code).

---

## Como usar

1. Ligue o Arduino e aguarde o **pré-aquecimento** do sensor MQ-2 (de 20 segundos a alguns minutos).
2. Inicie a API (`npm start`) e abra a interface web no navegador.
3. Acompanhe a leitura em tempo real no painel.
4. Se a concentração de gás ultrapassar o limite configurado, o sistema exibe o alerta.


---

## Estrutura de pastas

```
anzen-tech/
├── arduino/          # Código do Arduino (.ino)
├── api/              # API em Node.js (conexão serial e MySQL)
├── web/              # Interface web (HTML, CSS, JS)
├── database/         # Scripts SQL
├── docs/
│   └── images/       # Imagens usadas no README (diagramas e telas)
└── README.md
```



---

## Limitações e aviso de segurança

- O sensor **MQ-2** exige pré-aquecimento e calibração para leituras confiáveis.
- Ele é sensível a diferentes gases (fumaça, álcool, hidrogênio, entre outros) e pode gerar falsos positivos.
- Este projeto é um **protótipo educacional** e **não substitui detectores de gás certificados**.
- Em caso de suspeita de vazamento real: feche o registro do gás, abra portas e janelas, não acione interruptores nem chamas e saia do local.

---

## Roadmap

- [ ] Alarme sonoro (buzzer ou sirene)
- [ ] Notificações no celular
- [ ] Conectividade Wi-Fi com ESP32
- [ ] Calibração automática do sensor
- [ ] Gráficos de histórico no painel
- [ ] Versão em inglês da documentação

---

## Equipe

| Nome | GitHub |
|---|---|
| Pedro Nunes Pereira | [@pedronunessptech](https://github.com/pedronunessptech) |
| Zanee Lopes Pereira | [@zanee-07](https://github.com/zanee-07) |
| Flávio Sandri Caputo | [@FlavioCaputo85](https://github.com/FlavioCaputo85) |
| Kauã Hideaki Siratsuti | [@siratsuti-sptech](https://github.com/siratsuti-sptech) |
| Nicollas Martins Candido | [@nicandido](https://github.com/nicandido) |
| Pietro Giuliani da Silva | [@pietrogds](https://github.com/pietrogds) |

---

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<p align="center">
  <strong>Anzen Tech 安全テク</strong> · Preservando hoje para existirem amanhã.
</p> Tecnologia a serviço da segurança
</p>
