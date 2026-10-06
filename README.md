<p align="center">
  <img src="https://github.com/user-attachments/assets/242b49ca-d94a-47b0-9b45-35c416802563" alt="Logo Anzen Tech" width="450">
</p>


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
- [Funcionalidades](#funcionalidades)
- [Arquitetura](#arquitetura)
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

## Funcionalidades

- Leitura contínua da concentração de gás pelo sensor MQ-2
- Exibição dos dados em tempo real em um painel web
- Alerta visual quando o nível de gás ultrapassa o limite configurado
- Registro do histórico de leituras no MySQL
- API em Node.js que recebe os dados do Arduino e os disponibiliza para a interface web
- Interface web responsiva (HTML, CSS e JavaScript)

> Ajuste esta lista conforme o que o projeto realmente faz (por exemplo: buzzer, LED, notificações).

---

## Arquitetura

```
┌──────────┐    ┌──────────┐    ┌────────────┐    ┌──────────────┐    ┌──────────┐
│  MQ-2    │───▶│ Arduino  │───▶│   Porta    │───▶│ API Node.js  │───▶│  MySQL   │
│ (sensor) │    │   UNO    │    │   Serial   │    │              │    │(histórico)│
└──────────┘    └──────────┘    └────────────┘    └──────┬───────┘    └──────────┘
                                                          │ HTTP (JSON)
                                                          ▼
                                                   ┌──────────────┐
                                                   │ Interface Web│
                                                   │ HTML/CSS/JS  │
                                                   └──────────────┘
```

O Arduino envia as leituras pela porta serial. A API em Node.js lê esses dados, grava no MySQL e os expõe para a interface web, que consome a API via requisições HTTP.

![Diagrama de arquitetura](docs/images/arquitetura.png)

---

## Tecnologias

| Área | Tecnologias |
|---|---|
| Hardware e embarcados | Arduino UNO, Sensor MQ-2, C/C++ (Arduino) |
| Back-end | Node.js (API) |
| Aplicação web | HTML, CSS, JavaScript |
| Banco de dados | MySQL |
| Ferramentas | Git, Git Bash, VS Code, Arduino IDE, Máquina Virtual (VM) |

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

> Confira a pinagem do seu módulo MQ-2 e atualize esta tabela caso utilize outros pinos (por exemplo, a saída digital D0).

![Esquema do circuito](docs/images/circuito.png)

---

## Instalação

### Pré-requisitos

- [Git](https://git-scm.com/) (com Git Bash)
- [Node.js](https://nodejs.org/) 18 ou superior (inclui o npm)
- [Arduino IDE](https://www.arduino.cc/en/software)
- [MySQL](https://www.mysql.com/) 8.0 ou superior
- [Visual Studio Code](https://code.visualstudio.com/)
- Máquina virtual (VM), caso o ambiente do projeto seja executado nela

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

> A porta serial é a mesma selecionada na Arduino IDE. Feche o Monitor Serial da IDE antes de iniciar a API, pois só um programa pode usar a porta por vez.

**6. Iniciar a API**

```bash
npm start
```

A API ficará disponível em `http://localhost:3000`.

**7. Abrir a interface web**

Abra o arquivo `web/index.html` no navegador (ou use a extensão *Live Server* do VS Code).

> Ajuste os nomes de scripts, variáveis e configurações conforme o código real do projeto.

---

## Como usar

1. Ligue o Arduino e aguarde o **pré-aquecimento** do sensor MQ-2 (de 20 segundos a alguns minutos).
2. Inicie a API (`npm start`) e abra a interface web no navegador.
3. Acompanhe a leitura em tempo real no painel.
4. Se a concentração de gás ultrapassar o limite configurado, o sistema exibe o alerta.

![Dashboard](docs/images/dashboard.png)
![Tela de alerta](docs/images/alerta.png)

---

## Estrutura de pastas

```
anzen-tech/
├── arduino/          # Código do Arduino (.ino)
├── api/              # API em Node.js (conexão serial e MySQL)
├── web/              # Interface web (HTML, CSS, JS)
├── database/         # Scripts SQL
├── docs/
│   └── images/       # Imagens usadas no README
└── README.md
```

> Ajuste conforme a organização real do repositório.

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
| Pedro Nunes Pereira | [@pedronunessptech](https://github.com/usuario) |
| Zanee Lopes Pereira | [@zanee-07](https://github.com/usuario) |
| Flávio Sandri Caputo | [@FlavioCaputo85](https://github.com/usuario) |
| Kauã Hideaki Siratsuti | [@siratsuti-sptech](https://github.com/usuario) |
| Nicollas Martins Candido | [@nicandido](https://github.com/usuario) |
| Pietro Giuliani da Silva | [@pietrogds](https://github.com/usuario) |

---

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<p align="center">
  <strong>Anzen Tech 安全テク</strong> · Tecnologia a serviço da segurança
</p>
