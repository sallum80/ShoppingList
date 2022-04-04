/* 
  Esse SQL é responsável por criar tabelas para um banco de dados relacional PostgreSQL, desenvolvido
   para qualquer aplicação bancária cujo escopo tem relação a Cliente, Conta e Transação. 

  Primeiramente é preciso rodar a criação dos tipos ENUM para depois rodar a criação das tabelas.
*/

CREATE DATABASE stone;

/*
  Criação de tipos (ENUM):
*/

-- Cria o tipo status_ativdade. Ele pode ser ativo ou inativo.
CREATE TYPE status_atividade AS ENUM ('ativo', 'inativo');
CREATE TYPE tipo_conta AS ENUM ('corrente', 'poupanca');

CREATE TYPE status_transacao AS ENUM ('concluida', 'cancelada', 'estornada', 'processando');
CREATE TYPE especie_transacao AS ENUM ('deposito', 'saque', 'transferencia');

/*
  Tabela responsável por todas as informações de um cliente, quando o mesmo for querer abrir
  uma conta no banco. 
*/

/*
  Tabela responsável por todas as informações de um cliente, quando o mesmo for querer abrir
  uma conta no banco. 
*/

CREATE TABLE cliente
(
    id serial NOT NULL,

    -- Decidi utilizar o CPF como padrão de documento
    "cpf" varchar (11) NOT NULL,
    "primeiro_nome" char(20) NOT NULL,
    "nome_do_meio" char(20),
    "sobrenome" char(50) NOT NULL,
    -- Realizando inclusão para os que não se identificam no gênero masculino ou feminino 
    "pronome" char(10),
    "email" char(50) NOT NULL,

    "ddd" char(3) NOT NULL,
    "telefone" char(15) NOT NULL,

    "logradouro" char(20) NOT NULL,
    "numero_residencial" integer NOT NULL,
    "bairro" char(30) NOT NULL,
    "cep" char(15) NOT NULL,
    "estado" char (10) NOT NULL,
    "pais" char(20) NOT NULL,
                        
    -- Se a conta encontra no estado ativo ou inativo
    "status" status_atividade NOT NULL,
    
    -- Data de criação da conta no banco
    "criado_em" timestamp without time zone DEFAULT now() NOT NULL,

    -- Data da última atualização feita na conta
    "atualizado_em" timestamp without time zone DEFAULT now() NOT NULL,
    
    -- Tornando o atributo ID como chave primária, para que tenha uma relação com a tabela CONTA
    CONSTRAINT clientes_pkey PRIMARY KEY (id)

);

    /* 
  Tabela de contas, responsável por todas as informações de contas abertas, fechadas ou suspensas no banco
  a tabela conta tem uma depêndencia com a tabela de cliente, pois, não é possível existir uma conta
  sem um cliente.
*/

CREATE TABLE conta
(
    "id" serial NOT NULL,

/* ID cliente, responsável por fazer uma relação com a tabela cliente, pois, não é possível existir 
   uma conta sem o cliente cadastrado no banco,
*/    
    "id_cliente" serial NOT NULL, 

    "agencia" NUMERIC (15) NOT NULL,
    "numero" NUMERIC (15) NOT NULL,
    "atualizado_em" timestamp without time zone DEFAULT now() NOT NULL,
    "senha" varchar(30) NOT NULL,
    -- Responsável por saber a quantidade de dinheiro existente na conta
    "balanco" integer NOT NULL,

    -- Status se a conta está ativa ou inativa
    "status" status_atividade NOT NULL,
    
    -- Tipo da conta corrente, poupança
    "tipo" tipo_conta NOT NULL,
    "criado_em" timestamp without time zone DEFAULT now() NOT NULL,

    -- Tornando o atributo ID como chave primária, para que tenha uma relação com a tabela CLIENTE 
    CONSTRAINT conta_pkey PRIMARY KEY (id),
    -- Criando a chave estrangeira, realizando a relação de tabelas CONTA com a tabela CLIENTE. 
    -- Uma conta não pode existir sem um cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)

);
  /*
    Tabela de transações, responsável por todos os dados de uma transação bancária, seja depósitos, saques ou tranferências.
    A tabela transação tem uma dependência com a tabela de conta, pois, não é possível fazer uma transação sem conta
*/

CREATE TABLE transacoes
(   
    --Número de identificação único de uma transação
    "id" serial NOT NULL,

    "criado_em" timestamp without time zone DEFAULT now() NOT NULL,
    "conta_origem" integer NOT NULL,
    -- Somente existirá uma conta destino se caso a transação for uma transferência
    "conta_destino" integer,
    "atualizado_em" timestamp without time zone DEFAULT now() NOT NULL,
    "valor_transacao" integer NOT NULL,

    --Status da transação, aprovada, rejeitada ou em processamento. 
    "status" status_transacao NOT NULL,
    --Espécie de transação bancária, depósitos, saques ou tranferências
    "especie" especie_transacao NOT NULL,

    --Realizando o ID como chave primária para que o valor dela não se repita nessa tabela
    CONSTRAINT transacoes_pkey PRIMARY KEY (id),
    --Criando a relação do atributo conta_origem com o atributo ID da tabela de CONTA, pois uma transação não existe sem uma conta.
    FOREIGN KEY (conta_origem) REFERENCES conta(id),
    --Criando a relação do atributo conta_destino com o atributo ID da tabela de CONTA, pois uma transação não existe sem uma conta.    
    FOREIGN KEY (conta_destino) REFERENCES conta(id)
);

INSERT INTO cliente(
	id, cpf, primeiro_nome, nome_do_meio, sobrenome, pronome, email, ddd, telefone, logradouro, numero_residencial, bairro, cep, estado, pais, criado_em, atualizado_em)
	VALUES (13, '33434566783', 'fabio', 'junior', 'sallum', 'eleDele', 'sallum80@gmail.com', '17', '996012310', 'casa', 1430, 'centro', '148938763', 'sp', 'Brasil', current_timestamp, current_timestamp);

INSERT INTO cliente(
	id, cpf, primeiro_nome, nome_do_meio, sobrenome, pronome, email, ddd, telefone, logradouro, numero_residencial, bairro, cep, estado, pais, criado_em, atualizado_em)
	VALUES (67, '88789044578', 'maria', 'gabriela', 'silva', 'elaDela', 'gabs_silva@hotmail.com', '19', '997654737', 'apt', 'AC', 'Santo Antonio', '4567654345', 'MG', 'Brasil', current_timestamp, current_timestamp);

INSERT INTO conta (
    id_cliente, atualizado_em, agencia, numero, balanco, status, senha, id, tipo)
    VALUES (13, current_timestamp, 56435, 4980-1, 9.800, 'ativo', 5343, 2786, 'corrente');

INSERT INTO transacoes (
    conta_origem, atualizado_em, criado_em, valor_transacao, status, especie, id)
    VALUES (2786, current_timestamp, current_timestamp, 200.00, 'concluida','deposito', 166);

INSERT INTO transacoes (
    conta_origem, atualizado_em, criado_em, valor_transacao, status, especie, id)
    VALUES (2786, '2022-12-12 16:39:51.634027', '2022-12-12 16:39:51.634027', 200.00, 'concluida','deposito', 167);


/*
  Queries:
    - Para calcular o valor de entrada, fazemos a soma de todas as transações de DEPÓSITO que foram 
    criadas no ano atual e as agrupamos pelo seu mês.

    - Para calcular o valor de saída, fazemos a mesma coisa porém somamos todas as transações de SAQUE.
*/

SELECT date_part('month', criado_em) as mes, sum(valor_transacao) as valor_total_entrada from transacoes where DATE_PART('year', criado_em) = date_part('year', CURRENT_DATE) and especie = 'deposito' GROUP BY date_part('month', criado_em);

SELECT date_part('month', criado_em) as mes, sum(valor_transacao) as valor_total_saida from transacoes where DATE_PART('year', criado_em) = date_part('year', CURRENT_DATE) and especie = 'saque' GROUP BY date_part('month', criado_em);