(function (global) {
    'use strict';

    const CHAVE = 'anzentech-cozinhas-v1';
    const PADRAO = [
        { id: 1, nome: 'Cozinha 1' },
        { id: 2, nome: 'Cozinha 2' },
        { id: 3, nome: 'Cozinha 3' },
        { id: 4, nome: 'Cozinha 4' }
    ];

    function copiaPadrao() {
        return PADRAO.map(function (c) { return { id: c.id, nome: c.nome }; });
    }

    function normalizar(dados) {
        if (!Array.isArray(dados)) return copiaPadrao();
        const vistos = {};
        const lista = [];
        dados.forEach(function (item) {
            if (!item) return;
            const id = Number(item.id);
            const nome = typeof item.nome === 'string' ? item.nome.trim() : '';
            if (!Number.isInteger(id) || id < 1 || vistos[id] || !nome) return;
            vistos[id] = true;
            lista.push({ id: id, nome: nome });
        });
        return lista.length ? lista : copiaPadrao();
    }

    function carregar() {
        try {
            const bruto = global.localStorage.getItem(CHAVE);
            if (bruto === null) return copiaPadrao();
            return normalizar(JSON.parse(bruto));
        } catch (erro) {
            return copiaPadrao();
        }
    }

    function salvar(lista) {
        try {
            global.localStorage.setItem(CHAVE, JSON.stringify(lista));
            return true;
        } catch (erro) {
            return false;
        }
    }

    function proximoId(lista) {
        return lista.reduce(function (maior, c) { return Math.max(maior, c.id); }, 0) + 1;
    }

    global.CozinhasStore = {
        listar: carregar,

        buscar: function (id) {
            return carregar().filter(function (c) { return c.id === Number(id); })[0] || null;
        },

        adicionar: function (nome) {
            const texto = String(nome || '').trim();
            if (!texto) return null;
            const lista = carregar();
            const cozinha = { id: proximoId(lista), nome: texto };
            lista.push(cozinha);
            return salvar(lista) ? cozinha : null;
        },

        renomear: function (id, nome) {
            const texto = String(nome || '').trim();
            if (!texto) return false;
            const lista = carregar();
            let encontrada = false;
            lista.forEach(function (c) {
                if (c.id === Number(id)) { c.nome = texto; encontrada = true; }
            });
            return encontrada ? salvar(lista) : false;
        },

        remover: function (id) {
            const lista = carregar();
            const restante = lista.filter(function (c) { return c.id !== Number(id); });
            if (!restante.length || restante.length === lista.length) return false;
            return salvar(restante);
        },

        escapar: function (texto) {
            const mapa = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
            return String(texto).replace(/[&<>"']/g, function (ch) { return mapa[ch]; });
        }
    };
})(window);
