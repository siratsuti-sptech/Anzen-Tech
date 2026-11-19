var database = require("../database/config");

// Retorna as últimas leituras de ppm de um sensor, da mais recente para a mais antiga.
function buscarUltimasLeituras(idSensor, limite) {

    var instrucaoSql = `SELECT
                        ppm,
                        situacao,
                        DATE_FORMAT(dataHora,'%H:%i:%s') AS horario,
                        dataHora
                    FROM leituraSensor
                    WHERE fkSensor = ?
                    ORDER BY dataHora DESC, idLeitura DESC
                    LIMIT ?`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql, [idSensor, limite]);
}

module.exports = {
    buscarUltimasLeituras
};
