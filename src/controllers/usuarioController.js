var usuarioModel = require("../models/usuarioModel");
var aquarioModel = require("../models/aquarioModel");

async function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (typeof email !== "string" || email.trim() === "") {
        return res.status(400).send("Informe um e-mail válido.");
    }
    if (typeof senha !== "string" || senha === "") {
        return res.status(400).send("Informe sua senha.");
    }

    try {
        var resultadoAutenticar = await usuarioModel.autenticar(email.trim(), senha);

        if (resultadoAutenticar.length === 0) {
            return res.status(403).send("E-mail ou senha inválidos.");
        }
        if (resultadoAutenticar.length > 1) {
            return res.status(403).send("Há mais de um usuário com esse e-mail e senha.");
        }

        var usuario = resultadoAutenticar[0];
        var aquarios = [];

        // A autenticação não depende de a empresa já possuir aquários cadastrados.
        try {
            if (usuario.empresaId != null) {
                aquarios = await aquarioModel.buscarAquariosPorEmpresa(usuario.empresaId);
            }
        } catch (erroAquarios) {
            console.error("Não foi possível carregar os aquários após o login:", erroAquarios.sqlMessage || erroAquarios.message);
        }

        return res.status(200).json({
            id: usuario.id,
            email: usuario.email,
            nome: usuario.nome,
            aquarios: aquarios || []
        });
    } catch (erro) {
        console.error("Houve um erro ao realizar o login:", erro.sqlMessage || erro.message || erro);
        return res.status(500).send("Não foi possível validar o login. Verifique a conexão e a estrutura do banco de dados.");
    }
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var sobrenome = req.body.sobrenomeServer;
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;
    var fkEstabelecimento = req.body.idEmpresaVincularServer;

    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    }else if (sobrenome == undefined) {
        res.status(400).send("Seu sobrenome está undefined!");
    }else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    }else if (senha == undefined) {
        res.status(400).send("Sua senha está undefined!");
    }else if (fkEstabelecimento == undefined) {
        res.status(400).send("Sua empresa a vincular está undefined!");
    }else {
        usuarioModel.cadastrar(nome, sobrenome, email, senha, fkEstabelecimento)
            .then(
                function (resultado) {
                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log("\nHouve um erro ao realizar o cadastro! Erro: ", erro.sqlMessage);
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}

module.exports = {
    autenticar,
    cadastrar
}
