    -- Cria o schema landing se não existir
    CREATE SCHEMA IF NOT EXISTS landing;

    -- Cria a tabela produtos dentro do schema landing
    -- Aqui cada "produto" é um plano de assinatura da plataforma
    CREATE TABLE IF NOT EXISTS landing.produtos (
        product_id INT PRIMARY KEY,
        name VARCHAR(255),
        price DECIMAL(10,2)
    );

    -- Insere os dados na tabela
    INSERT INTO landing.produtos (product_id, name, price) VALUES
    (1, 'Plano Basico', 29.90),
    (2, 'Plano Padrao', 49.90),
    (3, 'Plano Premium', 89.90),
    (4, 'Plano Familia', 119.90),
    (5, 'Plano Estudante', 19.90),
    (6, 'Plano Esportes', 99.90),
    (7, 'Plano Cinema e Shows', 79.90),
    (8, 'Plano Premium + Esportes', 149.90),
    (9, 'Plano Premium + Cinema', 129.90),
    (10, 'Plano Premium Ultra', 199.90);
