var leituraModel = require("../models/leituraModel");

var LIMITE_PADRAO = 20;
var LIMITE_MAXIMO = 100;

function buscarUltimasLeituras(req, res) {

    var idSensor = parseInt(req.params.idSensor, 10);
    var limite = parseInt(req.query.limite, 10);

    if (isNaN(idSensor)) {
        return res.status(400).send("idSensor inválido!");
    }
    if (isNaN(limite) || limite <= 0) {
        limite = LIMITE_PADRAO;
    }
    limite = Math.min(limite, LIMITE_MAXIMO);

    leituraModel.buscarUltimasLeituras(idSensor, limite).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!");
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as leituras de GLP.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

module.exports = {
    buscarUltimasLeituras
};
