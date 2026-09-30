// ===== DADOS DOS CARDS (um array de objetos) =====
var funcionalidades = [
    { titulo: "Monitoramento", icone: "📡", cor: "#cfe4fb",
      texto: "Acompanhe continuamente as informações coletadas pelos sensores instalados na cozinha." },
    { titulo: "Detecção", icone: "🔍", cor: "#c9eedb",
      texto: "O sensor realiza leituras e identifica alterações na presença de GLP no ambiente." },
    { titulo: "Alertas", icone: "🔔", cor: "#fcd3d3",
      texto: "Quando o nível definido pelo sistema é ultrapassado, um alerta é emitido para que o responsável possa tomar uma ação." }
];

var beneficios = [
    "Mais segurança para sua equipe",
    "Redução de custos com imprevistos",
    "Tecnologia de fácil implementação",
    "Suporte especializado em todo o processo"
];

// ===== CRIAR OS CARDS: o for percorre o array e monta o HTML de cada card =====
function criarCards() {
    var html = "";
    for (var i = 0; i < funcionalidades.length; i++) {
        var item = funcionalidades[i];
        html += '<div class="card-func">';
        html += '  <div class="icone" style="background:' + item.cor + '">' + item.icone + '</div>';
        html += '  <div><h3>' + item.titulo + '</h3><p>' + item.texto + '</p></div>';
        html += '</div>';
    }
    lista_cards.innerHTML = html;
}

// ===== CRIAR A LISTA DE BENEFÍCIOS: mesma ideia, mas com while =====
function criarBeneficios() {
    var html = "";
    var contador = 0;
    while (contador < beneficios.length) {
        html += "<li>" + beneficios[contador] + "</li>";
        contador++;
    }
    lista_beneficios.innerHTML = html;
}

// ===== BARRA DE CONTATO =====
function mostrarMensagem(texto, classe) {
    msg_contato.innerHTML = texto;
    msg_contato.className = "msg-contato " + classe;
    msg_contato.style.display = "block";
}

function solicitarContato() {
    var nome = ipt_nome.value;
    var whatsapp = ipt_whatsapp.value;

    if (nome == "" || whatsapp == "") {
        mostrarMensagem("Preencha o nome e o WhatsApp.", "msg-erro");
        return;
    }

    // Percorre o texto do WhatsApp letra por letra, contando só os números
    var digitos = 0;
    for (var i = 0; i < whatsapp.length; i++) {
        if (whatsapp[i] >= "0" && whatsapp[i] <= "9") {
            digitos++;
        }
    }

    if (digitos < 10) {
        mostrarMensagem("Digite o WhatsApp com DDD (mínimo 10 números).", "msg-erro");
    } else {
        mostrarMensagem("Obrigado, " + nome + "! Entraremos em contato pelo WhatsApp.", "msg-ok");
        ipt_nome.value = "";
        ipt_whatsapp.value = "";
    }
}

// ===== MENU: se já fez login, o botão "Login" vira "Sair" =====
function ajustarMenu() {
    var logado = localStorage.getItem("usuarioLogado");
    if (logado != null) {
        area_login.innerHTML = '<button class="btn-menu" onclick="sair()">Sair</button>';
    }
}

function sair() {
    localStorage.removeItem("usuarioLogado");
    window.location = "index.html";
}

// ===== AO ABRIR A PÁGINA =====
criarCards();
criarBeneficios();
ajustarMenu();
