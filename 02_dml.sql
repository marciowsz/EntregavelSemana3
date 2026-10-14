-- =============================================================================
-- 02_dml.sql — Oficina Mecânica — Carga de dados e consultas com JOIN
-- Executar depois do 01_ddl.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- INSERTS (mínimo de 3 por tabela, na ordem das dependências)
-- -----------------------------------------------------------------------------

-- CLIENTE
INSERT INTO cliente (nome, cpf, telefone, email, data_cadastro) VALUES ('Ana Souza',    '11111111111', '(11) 98888-1111', 'ana@email.com',   '2026-01-10');
INSERT INTO cliente (nome, cpf, telefone, email, data_cadastro) VALUES ('Bruno Lima',   '22222222222', '(41) 97777-2222', 'bruno@email.com', '2026-02-15');
INSERT INTO cliente (nome, cpf, telefone, email, data_cadastro) VALUES ('Carla Mendes', '33333333333', '(31) 96666-3333', NULL,              '2026-03-20');
INSERT INTO cliente (nome, cpf, telefone, email)                VALUES ('Diego Rocha',  '44444444444', '(21) 95555-4444', 'diego@email.com');  -- data_cadastro via DEFAULT

-- MARCA
INSERT INTO marca (nome) VALUES ('Fiat');
INSERT INTO marca (nome) VALUES ('Volkswagen');
INSERT INTO marca (nome) VALUES ('Chevrolet');

-- MODELO
INSERT INTO modelo (nome, id_marca) VALUES ('Uno',  1);
INSERT INTO modelo (nome, id_marca) VALUES ('Argo', 1);
INSERT INTO modelo (nome, id_marca) VALUES ('Gol',  2);
INSERT INTO modelo (nome, id_marca) VALUES ('Onix', 3);

-- VEICULO
INSERT INTO veiculo (placa, ano, cor, id_modelo, id_cliente) VALUES ('ABC1D23', 2015, 'Prata',  1, 1);
INSERT INTO veiculo (placa, ano, cor, id_modelo, id_cliente) VALUES ('DEF2G34', 2018, 'Branco', 3, 2);
INSERT INTO veiculo (placa, ano, cor, id_modelo, id_cliente) VALUES ('GHI3J45', 2021, 'Preto',  4, 3);
INSERT INTO veiculo (placa, ano, cor, id_modelo, id_cliente) VALUES ('JKL4M56', 2022, 'Vermelho', 2, 1);  -- Ana tem 2 veículos

-- MECANICO
INSERT INTO mecanico (nome, cpf, especialidade, data_admissao) VALUES ('José Pereira', '55555555555', 'Motor',     '2018-03-01');
INSERT INTO mecanico (nome, cpf, especialidade, data_admissao) VALUES ('Marcos Alves', '66666666666', 'Suspensão', '2020-07-15');
INSERT INTO mecanico (nome, cpf, especialidade, data_admissao) VALUES ('Rita Gomes',   '77777777777', 'Elétrica',  '2022-01-10');

-- SERVICO
INSERT INTO servico (descricao, valor_mao_obra, tempo_estimado) VALUES ('Troca de óleo',               80.00, 30);
INSERT INTO servico (descricao, valor_mao_obra, tempo_estimado) VALUES ('Alinhamento e balanceamento', 120.00, 60);
INSERT INTO servico (descricao, valor_mao_obra, tempo_estimado) VALUES ('Revisão de freios',           150.00, 90);
INSERT INTO servico (descricao, valor_mao_obra, tempo_estimado) VALUES ('Diagnóstico elétrico',        100.00, 45);

-- PECA
INSERT INTO peca (codigo, nome, preco_venda, qtd_estoque) VALUES ('OL5W30', 'Óleo 5W30 (1 litro)',      45.00, 50);
INSERT INTO peca (codigo, nome, preco_venda, qtd_estoque) VALUES ('FO001',  'Filtro de óleo',           35.00, 20);
INSERT INTO peca (codigo, nome, preco_venda, qtd_estoque) VALUES ('PF001',  'Pastilha de freio (jogo)', 180.00, 10);
INSERT INTO peca (codigo, nome, preco_venda, qtd_estoque) VALUES ('BT60',   'Bateria 60Ah',             520.00, 5);

-- ORDEM_SERVICO
INSERT INTO ordem_servico (data_abertura, data_conclusao, status, km_entrada, id_veiculo, id_mecanico) VALUES ('2026-09-01', '2026-09-01', 'concluida',    85000, 1, 1);
INSERT INTO ordem_servico (data_abertura, data_conclusao, status, km_entrada, id_veiculo, id_mecanico) VALUES ('2026-09-10', '2026-09-11', 'concluida',    62000, 2, 2);
INSERT INTO ordem_servico (data_abertura, data_conclusao, status, km_entrada, id_veiculo, id_mecanico) VALUES ('2026-10-05', NULL,         'em_andamento', 30000, 3, 3);
INSERT INTO ordem_servico (data_abertura, km_entrada, id_veiculo, id_mecanico)                         VALUES ('2026-10-12', 15000, 4, 1);  -- status 'aberta' via DEFAULT

-- VISTORIA (uma por OS — relacionamento 1:1)
INSERT INTO vistoria (nivel_combustivel, avarias, possui_estepe, data_hora, id_os) VALUES ('1/2',     'Risco na porta traseira', TRUE,  '2026-09-01 08:10', 1);
INSERT INTO vistoria (nivel_combustivel, avarias, possui_estepe, data_hora, id_os) VALUES ('reserva', NULL,                      TRUE,  '2026-09-10 09:30', 2);
INSERT INTO vistoria (nivel_combustivel, avarias, possui_estepe, data_hora, id_os) VALUES ('3/4',     'Para-choque amassado',    FALSE, '2026-10-05 14:00', 3);
INSERT INTO vistoria (nivel_combustivel, avarias, possui_estepe, data_hora, id_os) VALUES ('cheio',   NULL,                      TRUE,  '2026-10-12 10:45', 4);

-- OS_SERVICO
INSERT INTO os_servico (id_os, id_servico, quantidade, valor_cobrado) VALUES (1, 1, 1,  80.00);
INSERT INTO os_servico (id_os, id_servico, quantidade, valor_cobrado) VALUES (2, 2, 1, 120.00);
INSERT INTO os_servico (id_os, id_servico, quantidade, valor_cobrado) VALUES (2, 3, 1, 150.00);
INSERT INTO os_servico (id_os, id_servico, quantidade, valor_cobrado) VALUES (3, 4, 1, 100.00);
INSERT INTO os_servico (id_os, id_servico, quantidade, valor_cobrado) VALUES (4, 1, 1,  80.00);

-- OS_PECA
INSERT INTO os_peca (id_os, id_peca, quantidade, preco_unitario) VALUES (1, 1, 4,  45.00);
INSERT INTO os_peca (id_os, id_peca, quantidade, preco_unitario) VALUES (1, 2, 1,  35.00);
INSERT INTO os_peca (id_os, id_peca, quantidade, preco_unitario) VALUES (2, 3, 1, 180.00);
INSERT INTO os_peca (id_os, id_peca, quantidade, preco_unitario) VALUES (3, 4, 1, 520.00);

-- PARCELA_PAGAMENTO
INSERT INTO parcela_pagamento (id_os, numero_parcela, valor, data_vencimento, data_pagamento, forma_pagamento) VALUES (1, 1, 295.00, '2026-09-01', '2026-09-01', 'pix');
INSERT INTO parcela_pagamento (id_os, numero_parcela, valor, data_vencimento, data_pagamento, forma_pagamento) VALUES (2, 1, 225.00, '2026-09-11', '2026-09-11', 'boleto');
INSERT INTO parcela_pagamento (id_os, numero_parcela, valor, data_vencimento, data_pagamento, forma_pagamento) VALUES (2, 2, 225.00, '2026-10-11', NULL,         'boleto');
INSERT INTO parcela_pagamento (id_os, numero_parcela, valor, data_vencimento, data_pagamento, forma_pagamento) VALUES (3, 1, 620.00, '2026-10-20', NULL,         'pix');


-- -----------------------------------------------------------------------------
-- CONSULTAS COM JOIN
-- -----------------------------------------------------------------------------

-- Q1: Resumo de cada OS — cliente, veículo (marca/modelo), mecânico e valor
--     total calculado a partir dos itens (o total não é mais armazenado: 3FN).
--     JOIN entre 6 tabelas + subconsultas agregadas.
SELECT  os.id_os,
        c.nome                              AS cliente,
        v.placa,
        ma.nome || ' ' || mo.nome           AS veiculo,
        m.nome                              AS mecanico,
        os.status,
        COALESCE(s.total_servicos, 0)                               AS total_servicos,
        COALESCE(p.total_pecas, 0)                                  AS total_pecas,
        COALESCE(s.total_servicos, 0) + COALESCE(p.total_pecas, 0)  AS total_os
FROM ordem_servico os
JOIN veiculo  v  ON v.id_veiculo   = os.id_veiculo
JOIN cliente  c  ON c.id_cliente   = v.id_cliente
JOIN modelo   mo ON mo.id_modelo   = v.id_modelo
JOIN marca    ma ON ma.id_marca    = mo.id_marca
JOIN mecanico m  ON m.id_mecanico  = os.id_mecanico
LEFT JOIN (SELECT id_os, SUM(quantidade * valor_cobrado)  AS total_servicos FROM os_servico GROUP BY id_os) s ON s.id_os = os.id_os
LEFT JOIN (SELECT id_os, SUM(quantidade * preco_unitario) AS total_pecas    FROM os_peca    GROUP BY id_os) p ON p.id_os = os.id_os
ORDER BY os.id_os;

-- Q2: Peças utilizadas em cada OS, com o nome do cliente e a placa.
SELECT  os.id_os,
        c.nome                              AS cliente,
        v.placa,
        pe.nome                             AS peca,
        op.quantidade,
        op.preco_unitario,
        op.quantidade * op.preco_unitario   AS subtotal
FROM os_peca op
JOIN peca          pe ON pe.id_peca    = op.id_peca
JOIN ordem_servico os ON os.id_os      = op.id_os
JOIN veiculo       v  ON v.id_veiculo  = os.id_veiculo
JOIN cliente       c  ON c.id_cliente  = v.id_cliente
ORDER BY os.id_os, pe.nome;

-- Q3: Parcelas em aberto (lista de cobrança), com telefone do cliente
--     e indicação de atraso.
SELECT  c.nome              AS cliente,
        c.telefone,
        pp.id_os,
        pp.numero_parcela,
        pp.valor,
        pp.data_vencimento,
        CASE WHEN pp.data_vencimento < CURRENT_DATE THEN 'ATRASADA' ELSE 'a vencer' END AS situacao
FROM parcela_pagamento pp
JOIN ordem_servico os ON os.id_os     = pp.id_os
JOIN veiculo       v  ON v.id_veiculo = os.id_veiculo
JOIN cliente       c  ON c.id_cliente = v.id_cliente
WHERE pp.data_pagamento IS NULL
ORDER BY pp.data_vencimento;

-- Q4: Faturamento de mão de obra por mecânico (JOIN + GROUP BY).
SELECT  m.nome                                      AS mecanico,
        m.especialidade,
        COUNT(DISTINCT os.id_os)                    AS qtd_os,
        COALESCE(SUM(oss.quantidade * oss.valor_cobrado), 0) AS total_mao_obra
FROM mecanico m
LEFT JOIN ordem_servico os  ON os.id_mecanico = m.id_mecanico
LEFT JOIN os_servico    oss ON oss.id_os      = os.id_os
GROUP BY m.id_mecanico, m.nome, m.especialidade
ORDER BY total_mao_obra DESC;
