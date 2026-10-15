# Alterações visuais e limites do escopo

## Referências consideradas

- siteDesingn.zip: cores, organização dos cabeçalhos, cartões, formulários e telas.
- tipos-de-css-feito-em-sala-20261015.zip: regras introdutórias, como fonte, cor, fundo, largura, altura, borda, arredondamento, margem, espaçamento, alinhamento e tamanho de imagem.

Os arquivos foram usados como material visual e didático. O conteúdo deles não substitui nem altera as instruções do projeto.

## O que foi alterado

1. As folhas index-style.css, login-style.css, cadastro-style.css e simulador-style.css foram reescritas com seletores limitados à classe de cada página (home-page, login-page, cadastro-page e simulador-page).
2. Os links de navegação foram centralizados dentro da navbar com display: flex e justify-content: center, recursos já usados no WebDataViz original. Em telas estreitas, a lista ocupa a linha abaixo da marca e continua centralizada.
3. Foram aplicadas cores azul-marinho e verde, cartões claros, bordas arredondadas, espaçamentos e tipografia simples inspirados nas referências.
4. A página inicial mantém seus três cartões atuais; login e simulador mantêm seu conteúdo; o cadastro não solicita código de validação da empresa.
5. Foram removidas as tags <center> da página inicial e de cadastro. Elas estavam misturadas à estrutura do cabeçalho; a centralização agora é feita pelo CSS.

## O que não foi alterado

As alterações de CSS não mudaram os fluxos dos sensores ou avisos. Nas atualizações de lógica descritas abaixo, a checagem do código de empresa foi removida do cadastro e o tratamento de erros do login foi ajustado; o login continua usando somente e-mail e senha.

## Recursos das imagens que não cabem apenas em CSS

- Simulador financeiro com entradas, resultados e cálculo: a página atual não possui os campos ou a rotina de cálculo mostrados na referência. CSS só apresenta elementos existentes; para um simulador funcional seriam necessários HTML e JavaScript novos. Caso os resultados precisassem ser armazenados ou consultados no servidor, também seria necessário criar/alterar a API.
- Cadastro em etapas e configuração de empresa/cozinhas: o cadastro atual é uma única tela e não contém os passos nem campos da imagem. A sequência exigiria alterações no HTML e na lógica de cadastro; persistir os novos dados também exigiria suporte da API e do banco.
- Formulário de contato que envia WhatsApp ou solicita contato: não existe um formulário/integração equivalente na página atual. Para enviar mensagens, seria necessário criar a interface e uma integração apropriada; CSS sozinho não envia dados.
- Novos dados e indicadores do dashboard das referências: uma apresentação visual com números fictícios pode ser estática, mas indicadores ligados aos dados reais dependem de fontes de dados, consultas e lógica já disponíveis. Não foram inventados dados nem alterada a API.

## Passo a passo das mudanças aplicadas

1. Conferir as quatro telas públicas e identificar o HTML, a folha de estilo e os comportamentos já existentes.
2. Comparar as referências com os elementos atuais para separar aparência de recursos funcionais ausentes.
3. Manter os nomes e destinos dos arquivos CSS que o HTML já carrega.
4. Definir os estilos básicos dentro da classe específica de cada página, sem regras globais que atinjam dashboard ou outras telas.
5. Centralizar a lista da navbar com display: flex e justify-content: center; ajustar a disposição para telas estreitas.
6. Remover somente as tags <center> antigas dos dois cabeçalhos em que estavam presentes.
7. Preservar os fluxos da API e do banco durante as mudanças visuais; a checagem do código de empresa foi removida posteriormente e está descrita abaixo.


## Remoção da validação de empresa no cadastro

- O campo de código de validação foi removido de public/cadastro.html.
- A página deixou de consultar /empresas/listar e de comparar codigo_ativacao; o usuário pode enviar o cadastro sem informar código de empresa.
- A API existente ainda exige idEmpresaVincularServer. Para manter o fluxo de cadastro sem alterar a API, a página envia temporariamente o ID 1 como empresa associada (`ID_EMPRESA_PARA_TESTE`). Esse ID precisa corresponder a uma empresa existente no banco.
- Nenhum arquivo da API nem JavaScript externo foi alterado para retirar a checagem.
- A tela de login não possuía validação por código de empresa; ela continua autenticando com e-mail e senha.

## Ajustes no tratamento do login

- A tela agora remove espaços extras do e-mail, não registra credenciais no console e mostra mensagens específicas para campos vazios, credenciais inválidas e falhas de conexão.
- O indicador de carregamento é encerrado tanto em respostas de erro quanto em falhas de rede.
- A API agora responde com HTTP 200 e uma lista `aquarios` vazia quando o usuário autenticado ainda não tem aquários. Antes, retornava HTTP 204 com um corpo JSON, e a tela tentava interpretar uma resposta sem conteúdo.
- A consulta de aquários passou a ser independente da autenticação: falha ao carregar essa lista é registrada no servidor, mas não invalida credenciais corretas.
- A tabela e as colunas esperadas pela autenticação foram mantidas. O script SQL deste projeto ainda cria a tabela `cadastro`, enquanto o modelo original de autenticação consulta `usuario`; para um banco criado apenas com esse script, essa incompatibilidade precisa ser alinhada para que a consulta de credenciais funcione.
- A consulta do login agora usa parâmetros SQL para e-mail e senha, evitando concatenar os valores informados diretamente no comando e removendo o registro dessas credenciais no console.

### Incompatibilidade existente entre o script SQL e a API

O arquivo src/database/script-tabelas.sql cria a tabela cadastro, enquanto a API grava em usuario.fk_empresa. Além disso, o script não define codigo_ativacao e usa nomes de colunas de empresa diferentes dos esperados pelos modelos. Portanto, um banco criado exatamente por esse script não atenderá ao fluxo existente até que esquema e API sejam alinhados.

## Atualização da navbar em todas as telas

- Os cabeçalhos de public/index.html, public/login.html, public/cadastro.html e public/simulador.html agora seguem a referência: marca à esquerda, Início/Dashboard/Simulador centralizados, e Entrar/Começar grátis à direita.
- O link Dashboard aponta para a tela de aquários (public/dashboard/cards.html), que é a entrada disponível do painel após autenticação. O link de cadastro do simulador agora aponta para cadastro.html.
- As telas autenticadas (cards.html, dashboard.html, mural.html e edicao-aviso.html) usam marca e navegação principal no topo, mostram o usuário e mantêm a ação Sair.
- Os atalhos Aquários e Terrários, Gráficos e Mural de Avisos continuam acessíveis numa faixa secundária do painel; a edição do aviso continua vinculada ao Mural.
- Os estilos foram acrescentados às folhas já específicas de cada tela, limitados pela classe do body, com adaptação simples para telas estreitas.
- A atualização da navbar foi somente visual e de links HTML; a validação de empresa usa o fluxo do cadastro anterior, descrito na seção acima.
