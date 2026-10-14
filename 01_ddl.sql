-- =============================================================================
-- 01_ddl.sql — Oficina Mecânica — Modelo Lógico normalizado (3FN)
-- SGBD: PostgreSQL
-- Mudanças em relação à Semana 02 (resultado da normalização):
--   * marca/modelo saíram de VEICULO e viraram as tabelas MARCA e MODELO
--     (eliminação da dependência transitiva id_veiculo -> modelo -> marca)
--   * valor_total saiu de ORDEM_SERVICO (atributo derivado dos itens);
--     agora é calculado nas consultas
-- =============================================================================

DROP TABLE IF EXISTS parcela_pagamento, os_peca, os_servico, vistoria, ordem_servico,
                     peca, servico, mecanico, veiculo, modelo, marca, cliente CASCADE;

-- -----------------------------------------------------------------------------
-- Tabelas sem dependências
-- -----------------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    nome            VARCHAR(100)    NOT NULL,
    cpf             CHAR(11)        NOT NULL UNIQUE,
    telefone        VARCHAR(15)     NOT NULL,
    email           VARCHAR(100)    UNIQUE,
    data_cadastro   DATE            NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE marca (
    id_marca        SERIAL          PRIMARY KEY,
    nome            VARCHAR(50)     NOT NULL UNIQUE
);

CREATE TABLE mecanico (
    id_mecanico     SERIAL          PRIMARY KEY,
    nome            VARCHAR(100)    NOT NULL,
    cpf             CHAR(11)        NOT NULL UNIQUE,
    especialidade   VARCHAR(50)     NOT NULL,
    data_admissao   DATE            NOT NULL,
    ativo           BOOLEAN         NOT NULL DEFAULT TRUE
);

CREATE TABLE servico (
    id_servico      SERIAL          PRIMARY KEY,
    descricao       VARCHAR(100)    NOT NULL UNIQUE,
    valor_mao_obra  DECIMAL(10,2)   NOT NULL CHECK (valor_mao_obra >= 0),
    tempo_estimado  INT             NOT NULL CHECK (tempo_estimado > 0)   -- minutos
);

CREATE TABLE peca (
    id_peca         SERIAL          PRIMARY KEY,
    codigo          VARCHAR(20)     NOT NULL UNIQUE,
    nome            VARCHAR(100)    NOT NULL,
    preco_venda     DECIMAL(10,2)   NOT NULL CHECK (preco_venda >= 0),
    qtd_estoque     INT             NOT NULL DEFAULT 0 CHECK (qtd_estoque >= 0)
);

-- -----------------------------------------------------------------------------
-- Tabelas com FK
-- -----------------------------------------------------------------------------

-- 1:N marca -> modelo
CREATE TABLE modelo (
    id_modelo       SERIAL          PRIMARY KEY,
    nome            VARCHAR(50)     NOT NULL,
    id_marca        INT             NOT NULL,
    CONSTRAINT fk_modelo_marca FOREIGN KEY (id_marca) REFERENCES marca (id_marca),
    CONSTRAINT uq_modelo_marca UNIQUE (id_marca, nome)   -- sem modelo repetido na mesma marca
);

-- 1:N cliente -> veiculo  |  1:N modelo -> veiculo
CREATE TABLE veiculo (
    id_veiculo      SERIAL          PRIMARY KEY,
    placa           CHAR(7)         NOT NULL UNIQUE,
    ano             INT             NOT NULL CHECK (ano BETWEEN 1950 AND 2100),
    cor             VARCHAR(30),
    id_modelo       INT             NOT NULL,
    id_cliente      INT             NOT NULL,
    CONSTRAINT fk_veiculo_modelo  FOREIGN KEY (id_modelo)  REFERENCES modelo (id_modelo),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);

-- 1:N veiculo -> OS  |  1:N mecanico -> OS
CREATE TABLE ordem_servico (
    id_os           SERIAL          PRIMARY KEY,
    data_abertura   DATE            NOT NULL DEFAULT CURRENT_DATE,
    data_conclusao  DATE,
    status          VARCHAR(20)     NOT NULL DEFAULT 'aberta'
                    CHECK (status IN ('aberta', 'em_andamento', 'concluida', 'cancelada')),
    km_entrada      INT             NOT NULL CHECK (km_entrada >= 0),
    id_veiculo      INT             NOT NULL,
    id_mecanico     INT             NOT NULL,
    CONSTRAINT fk_os_veiculo  FOREIGN KEY (id_veiculo)  REFERENCES veiculo (id_veiculo),
    CONSTRAINT fk_os_mecanico FOREIGN KEY (id_mecanico) REFERENCES mecanico (id_mecanico),
    CONSTRAINT ck_os_datas CHECK (data_conclusao IS NULL OR data_conclusao >= data_abertura)
);

-- 1:1 OS -> vistoria (UNIQUE na FK)
CREATE TABLE vistoria (
    id_vistoria         SERIAL          PRIMARY KEY,
    nivel_combustivel   VARCHAR(10)     NOT NULL
                        CHECK (nivel_combustivel IN ('reserva', '1/4', '1/2', '3/4', 'cheio')),
    avarias             VARCHAR(255),
    possui_estepe       BOOLEAN         NOT NULL DEFAULT TRUE,
    data_hora           TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_os               INT             NOT NULL UNIQUE,
    CONSTRAINT fk_vistoria_os FOREIGN KEY (id_os) REFERENCES ordem_servico (id_os) ON DELETE CASCADE
);

-- N:N OS <-> servico
CREATE TABLE os_servico (
    id_os           INT             NOT NULL,
    id_servico      INT             NOT NULL,
    quantidade      INT             NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    valor_cobrado   DECIMAL(10,2)   NOT NULL CHECK (valor_cobrado >= 0),  -- preço praticado nesta OS
    CONSTRAINT pk_os_servico PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_ossrv_os      FOREIGN KEY (id_os)      REFERENCES ordem_servico (id_os) ON DELETE CASCADE,
    CONSTRAINT fk_ossrv_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico)
);

-- N:N OS <-> peca
CREATE TABLE os_peca (
    id_os           INT             NOT NULL,
    id_peca         INT             NOT NULL,
    quantidade      INT             NOT NULL CHECK (quantidade > 0),
    preco_unitario  DECIMAL(10,2)   NOT NULL CHECK (preco_unitario >= 0), -- preço praticado nesta OS
    CONSTRAINT pk_os_peca PRIMARY KEY (id_os, id_peca),
    CONSTRAINT fk_ospeca_os   FOREIGN KEY (id_os)   REFERENCES ordem_servico (id_os) ON DELETE CASCADE,
    CONSTRAINT fk_ospeca_peca FOREIGN KEY (id_peca) REFERENCES peca (id_peca)
);

-- Entidade fraca: identificada por (id_os, numero_parcela)
CREATE TABLE parcela_pagamento (
    id_os           INT             NOT NULL,
    numero_parcela  INT             NOT NULL CHECK (numero_parcela > 0),
    valor           DECIMAL(10,2)   NOT NULL CHECK (valor > 0),
    data_vencimento DATE            NOT NULL,
    data_pagamento  DATE,
    forma_pagamento VARCHAR(20)     NOT NULL
                    CHECK (forma_pagamento IN ('dinheiro', 'pix', 'debito', 'credito', 'boleto')),
    CONSTRAINT pk_parcela PRIMARY KEY (id_os, numero_parcela),
    CONSTRAINT fk_parcela_os FOREIGN KEY (id_os) REFERENCES ordem_servico (id_os) ON DELETE CASCADE
);
