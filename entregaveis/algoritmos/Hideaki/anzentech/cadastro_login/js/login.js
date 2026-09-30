// ===== BOTÃO "MOSTRAR" DA SENHA =====
function mostrarSenha() {
    if (ipt_senha.type == "password") {
        ipt_senha.type = "text";
        btn_olho.innerHTML = "Ocultar";
    } else {
        ipt_senha.type = "password";
        btn_olho.innerHTML = "Mostrar";
    }
}

// ===== MOSTRAR MENSAGEM DE ERRO =====
function mostrarErro(mensagem) {
    var erro = document.getElementById("erro");
    erro.innerHTML = mensagem;
    erro.style.display = "block";
}

// ===== BOTÃO ENTRAR =====
function entrar() {
    var email = ipt_email.value;
    var senha = ipt_senha.value;

    // 1) Validação: campos vazios
    if (email == "" || senha == "") {
        mostrarErro("Preencha o e-mail e a senha.");
        return;
    }

    // 2) Busca a lista de usuários cadastrados
    var usuarios = [];
    var texto = localStorage.getItem("usuarios");
    if (texto != null) {
        usuarios = JSON.parse(texto);
    }

    if (usuarios.length == 0) {
        mostrarErro("Nenhuma conta cadastrada ainda. Clique em \"Cadastre-se grátis\".");
        return;
    }

    // 3) Percorre a lista procurando um usuário com esse e-mail e essa senha
    var achou = false;
    var nomeUsuario = "";
    for (var i = 0; i < usuarios.length; i++) {
        if (usuarios[i].email == email && usuarios[i].senha == senha) {
            achou = true;
            nomeUsuario = usuarios[i].nome;
        }
    }

    // 4) Resultado
    if (achou == true) {
        // Guarda quem está logado (a tela do usuário vai usar isso)
        localStorage.setItem("usuarioLogado", email);
        alert("Bem-vindo(a), " + nomeUsuario + "!");
        window.location = "../site_institucional/index.html";  // quando o dashboard existir, troque por o caminho dele
    } else {
        mostrarErro("E-mail ou senha incorretos.");
    }
}
