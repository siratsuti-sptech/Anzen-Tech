// ===== VARIÁVEL GLOBAL: guarda em qual etapa o usuário está =====
var etapa = 1;

// ===== MOSTRAR A ETAPA CERTA =====
function mostrarEtapa() {
    // Percorre as 3 etapas: mostra só a atual e esconde as outras
    for (var i = 1; i <= 3; i++) {
        var div = document.getElementById("etapa" + i);
        if (i == etapa) {
            div.style.display = "block";
        } else {
            div.style.display = "none";
        }
    }

    // Percorre as 3 bolinhas do indicador e muda a aparência de cada uma
    for (var i = 1; i <= 3; i++) {
        var bolinha = document.getElementById("bolinha" + i);
        if (i < etapa) {
            bolinha.innerHTML = "✓";              // etapa já concluída
            bolinha.className = "bolinha ativa";
        } else if (i == etapa) {
            bolinha.innerHTML = i;                // etapa atual
            bolinha.className = "bolinha ativa";
        } else {
            bolinha.innerHTML = i;                // etapa futura
            bolinha.className = "bolinha";
        }
    }

    // As duas linhas entre as bolinhas ficam verdes quando a etapa já passou
    for (var i = 1; i <= 2; i++) {
        var linha = document.getElementById("linha" + i);
        if (i < etapa) {
            linha.className = "linha ativa";
        } else {
            linha.className = "linha";
        }
    }
}

// ===== MOSTRAR / LIMPAR MENSAGEM DE ERRO =====
function mostrarErro(mensagem) {
    var erro = document.getElementById("erro");
    erro.innerHTML = mensagem;
    erro.style.display = "block";
}

function limparErro() {
    document.getElementById("erro").style.display = "none";
}

// ===== VALIDAÇÃO DE CADA ETAPA (retorna true se estiver tudo certo) =====
function validarEtapa1() {
    var nome = ipt_nome.value;
    var email = ipt_email.value;
    var senha = ipt_senha.value;

    if (nome == "" || email == "" || senha == "") {
        mostrarErro("Preencha todos os campos.");
        return false;
    }
    if (email.indexOf("@") == -1 || email.indexOf(".") == -1) {
        mostrarErro("Digite um e-mail válido.");
        return false;
    }
    if (senha.length < 8) {
        mostrarErro("A senha precisa ter no mínimo 8 caracteres.");
        return false;
    }
    return true;
}

function validarEtapa2() {
    var empresa = ipt_empresa.value;
    var segmento = sel_segmento.value;
    var funcionarios = sel_funcionarios.value;

    if (empresa == "" || segmento == "" || funcionarios == "") {
        mostrarErro("Preencha o nome da empresa e escolha as duas opções.");
        return false;
    }
    return true;
}

function validarEtapa3() {
    var cozinhas = Number(ipt_cozinhas.value);
    var emailAlerta = ipt_email_alerta.value;

    if (cozinhas < 1) {
        mostrarErro("Informe pelo menos 1 cozinha.");
        return false;
    }
    if (emailAlerta.indexOf("@") == -1 || emailAlerta.indexOf(".") == -1) {
        mostrarErro("Digite um e-mail válido para receber os alertas.");
        return false;
    }
    return true;
}

// ===== BOTÃO CONTINUAR / CRIAR CONTA =====
function continuar() {
    limparErro();

    if (etapa == 1) {
        if (validarEtapa1() == true) {
            etapa = 2;
            mostrarEtapa();
        }
    } else if (etapa == 2) {
        if (validarEtapa2() == true) {
            etapa = 3;
            mostrarEtapa();
        }
    } else {
        if (validarEtapa3() == true) {
            criarConta();
        }
    }
}

// ===== BOTÃO VOLTAR =====
function voltar() {
    limparErro();
    etapa = etapa - 1;
    mostrarEtapa();
}

// ===== CRIAR CONTA: grava o usuário no localStorage =====
function criarConta() {
    // Pega a lista de usuários já cadastrados (ou cria uma lista vazia)
    var usuarios = [];
    var texto = localStorage.getItem("usuarios");
    if (texto != null) {
        usuarios = JSON.parse(texto);   // transforma o texto de volta em array
    }

    // Percorre a lista para ver se esse e-mail já foi cadastrado
    var contador = 0;
    var jaExiste = false;
    while (contador < usuarios.length) {
        if (usuarios[contador].email == ipt_email.value) {
            jaExiste = true;
        }
        contador++;
    }

    if (jaExiste == true) {
        mostrarErro("Este e-mail já está cadastrado. Volte e use outro, ou faça login.");
        return;
    }

    // Monta o novo usuário e coloca na lista
    var novoUsuario = {
        nome: ipt_nome.value,
        email: ipt_email.value,
        senha: ipt_senha.value,
        empresa: ipt_empresa.value,
        segmento: sel_segmento.value,
        funcionarios: sel_funcionarios.value,
        cozinhas: Number(ipt_cozinhas.value),
        emailAlerta: ipt_email_alerta.value
    };
    usuarios.push(novoUsuario);

    // Salva a lista (o localStorage só guarda texto, por isso o JSON.stringify)
    localStorage.setItem("usuarios", JSON.stringify(usuarios));

    alert("Conta criada com sucesso! Agora faça login.");
    window.location = "login.html";
}

// Ao abrir a página, mostra a etapa 1
mostrarEtapa();
