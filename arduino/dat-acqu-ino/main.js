const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// sensores simulados: cada objeto representa um sensor que usa o valor do sensor real multiplicado por um fator
const SENSORES_SIMULADOS = [
    { fkSensor: 2, fator: 0.8 },
    { fkSensor: 3, fator: 1.15 }
];

// limites de estado (ppm) - mesmas regras do Arduino
const PPM_NORMAL_MAXIMO = 300;
const PPM_CRITICO = 1000;
const PPM_MAXIMO = 2000;

// classifica o estado do ambiente a partir do ppm (igual ao Arduino)
const classificarEstado = (ppm) => {
    if (ppm >= PPM_CRITICO) return 'CRITICO';
    if (ppm > PPM_NORMAL_MAXIMO) return 'RISCO';
    return 'NORMAL';
};

// arrays dos sensores simulados, indexados pelo fkSensor (ex.: { 2: [], 3: [] })
const valoresSimulados = Object.fromEntries(
    SENSORES_SIMULADOS.map((sensor) => [sensor.fkSensor, []])
);

// função para comunicação serial
const serial = async (
    valoresSensorGas
) => {

    // conexão com o banco de dados MySQL
    let poolBancoDados = mysql.createPool(
        {
            host: 'localhost',
            user: 'user_insert',
            password: 'Urubu100',
            database: 'anzen_glp',
            port: 3306
        }
    ).promise();

    // lista as portas seriais disponíveis e procura pelo Arduino
    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);
    if (!portaArduino) {
        throw new Error('O arduino não foi encontrado em nenhuma porta serial');
    }

    // configura a porta serial com o baud rate especificado
    const arduino = new serialport.SerialPort(
        {
            path: portaArduino.path,
            baudRate: SERIAL_BAUD_RATE
        }
    );

    // evento quando a porta serial é aberta
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // processa os dados recebidos do Arduino
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        const linha = data.trim();
        const fkSensor = 1;
        //console.log(linha);
        console.log(data);
        const valores = data.split(";");
        const sensorGas = parseFloat(valores[0]);
        const situacao = valores[1];
        
        const situacoesValidas = ['NORMAL', 'RISCO', 'CRITICO'];
        if (valores.length !== 2 || isNaN(sensorGas) || !situacoesValidas.includes(situacao)) {
        console.warn('Linha ignorada:', linha);
        return;
    }

        // armazena os valores dos sensores nos arrays correspondentes
        valoresSensorGas.push(sensorGas);

        // insere os dados no banco de dados (se habilitado)
        if (HABILITAR_OPERACAO_INSERIR) {
        //try {
            await poolBancoDados.execute(
                'INSERT INTO leituraSensor (ppm, situacao, dataHora, fkSensor) VALUES (?, ?, current_timestamp(), 1)',
                [sensorGas, situacao]
            );
            console.log('valores inseridos no banco:', sensorGas, situacao);
        //} catch (erro) {
            //console.error('Erro ao inserir no banco:', erro.message);
        //}
    }

        // gera os valores dos sensores simulados a partir do valor real
        const leiturasSimuladas = SENSORES_SIMULADOS.map((sensor) => {
            const ppm = Math.min(sensorGas * sensor.fator, PPM_MAXIMO);
            return {
                fkSensor: sensor.fkSensor,
                ppm: parseFloat(ppm.toFixed(2)),
                situacao: classificarEstado(ppm)
            };
        });

        // guarda nos arrays e insere no banco (se habilitado)
        await Promise.all(leiturasSimuladas.map(async (leitura) => {
            valoresSimulados[leitura.fkSensor].push(leitura.ppm);

            if (HABILITAR_OPERACAO_INSERIR) {
                await poolBancoDados.execute(
                    'INSERT INTO leituraSensor (ppm, situacao, dataHora, fkSensor) VALUES (?, ?, current_timestamp(), ?)',
                    [leitura.ppm, leitura.situacao, leitura.fkSensor]
                );
                console.log(`valores simulados inseridos (sensor ${leitura.fkSensor}):`, leitura.ppm, leitura.situacao);
            }
        }));
});

    // evento para lidar com erros na comunicação serial
    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

// função para criar e configurar o servidor web
const servidor = (
    valoresSensorGas
) => {
    const app = express();

    // configurações de requisição e resposta
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    // inicia o servidor na porta especificada
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    // define os endpoints da API para cada tipo de sensor
    app.get('/sensores/gas', (_, response) => {
        return response.json(valoresSensorGas);
    });

    // endpoints dos sensores simulados: /sensores/gas2 e /sensores/gas3
    SENSORES_SIMULADOS.forEach((sensor) => {
        app.get(`/sensores/gas${sensor.fkSensor}`, (_, response) => {
            return response.json(valoresSimulados[sensor.fkSensor]);
        });
    });
}

// função principal assíncrona para iniciar a comunicação serial e o servidor web
(async () => {
    // arrays para armazenar os valores dos sensores
    const valoresSensorGas = [];

    // inicia a comunicação serial
    await serial(
        valoresSensorGas
    );

    // inicia o servidor web
    servidor(
        valoresSensorGas
    );
})();
