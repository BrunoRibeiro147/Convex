# Convex

## Resumo
### Propósito
Essa aplicação é uma API de conversão de moedas utilizando as taxas de moedas em tempo real, permite que através da moeda base `EUR` se obtenha a conversão mais atualizada possível para outras moedas

### Features
- Conversão de Moedas: A API permite a conversão de moedas devolvendo o valor final e a atual taxa cambial
- Listagem de Transações: Toda a conversão é convertida em uma transação que também pode ser listada, permitindo assim a visualização do histórico de todas as conversões já feitas

### Tecnologias Utilizadas
- Elixir: Liguagem de programação que permite alta escalabilidade e concorrência, além de dar uma boa experiência para o desenvolvedor
- Phoenix: Web Framework para desenvolvimento de API's em Elixir, já trás inumeras abstrações que permite mais agilidade no desenvolvimento e segurança para a escalabilidade de aplicação
- Ecto: Ferramenta que fornece uma camada de banco de dados e linguagem integrada para consultas
- Credo: Linter para Elixir
- Tesla: Cliente HTTP para Elixir
- Dialyxir: Ferramenta para analisar descrepâncias no código
- Hammox: Ferramenta para criar mocks de trechos de códigos e facilitar nossos testes
- Excoveralls: Ferramenta para analisar a cobertura de testes da aplicação
- Ex_machina: Ferramenta para criar dados de testes e facilitar os testes da aplicação
- Swagger: Ferramenta para documentar os endpoints existentes na aplicação de forma fácil e legível

### Arquitetura Hexagonal
Nessa aplicação foi utilizada a arquitetura hexagonal, que divide a aplicação em Ports e Adapters para facilitar o desacoplamento do código e assim facilitar a manutenção do mesmo, caso queira saber mais: [`Desvendando a Arquitetura Hexagonal`](https://medium.com/tableless/desvendando-a-arquitetura-hexagonal-52c56f8824c) <br/>
**Camadas do Código**:
- Commands: São os DTOS, resposáveis por fazer a primeira checagem e validar os parâmetros enviados pelo usuário:
- Services: São os serviços da aplicação, onde fica a regra de negócio
- Schemas: As entidades que modelam os dados que irão para o banco de dados
- Ports: As interfaces para aplicações externas
- Adapters: As implementações das aplicações externas

## System Design
Você pode conferir toda a documentação da aplicação para entender melhor o seu funcionamento nesse link:
[`Convex System Design`](https://fern-silene-3c6.notion.site/Convex-f9a46f44844145199df33768fb00c14d)

## Como Executar a aplicação
Para rodar localmente você precisa ter instalado na sua maquina:
- Elixir
- NodeJS

Após fazer o clone da aplicação, siga os passos:
* Rode o comando `mix setup` para instalar as dependências e configurar o banco de dados
* Adicione a variável de ambiente para fazer uso da API, basta seguir o .env.example, você pode usar a sua access_key do Exchange Rates, ou utiliza a chave disponibilizada no System Design
* Inicie a aplicação com o comando: `mix phx.server`

Pronto, agora você pode entrar em [`localhost:4000`](http://localhost:4000) a partir do seu navegador

**API Insomnia**:
Também está disponível no [`Convex System Design`](https://fern-silene-3c6.notion.site/Convex-f9a46f44844145199df33768fb00c14d) um arquivo com todas as requisições pré-definidas para ser importado no Insomnia

## Como executar os testes

* Execute o comando `mix test` para executar todos os testes da aplicação
* Para ver a cobertura de testes da aplicação use o comando: `mix coveralls.html`
