
-- Tabelas principais com IDs inteiros sequenciais
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(200) NOT NULL,
    perfil VARCHAR(50) NOT NULL,
    ultimo_login TIMESTAMP,
    data_criacao TIMESTAMP DEFAULT NOW()
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    empresa VARCHAR(150),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT NOW()
);

CREATE TABLE perfis_processamento (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo_arquivo VARCHAR(20),
    delimitador VARCHAR(5),
    template_pcl VARCHAR(200),
    data_criacao TIMESTAMP DEFAULT NOW()
);

CREATE TABLE lotes_processamento (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    perfil_processamento_id INTEGER NOT NULL REFERENCES perfis_processamento(id),
    nome_arquivo VARCHAR(200) NOT NULL,
    caminho_s3 VARCHAR(300) NOT NULL,
    status VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP DEFAULT NOW(),
    data_processamento TIMESTAMP
);

CREATE TABLE lote_registros (
    id SERIAL PRIMARY KEY,
    lote_id INTEGER NOT NULL REFERENCES lotes_processamento(id) ON DELETE CASCADE,
    nome VARCHAR(200),
    endereco VARCHAR(300),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf VARCHAR(2),
    cep VARCHAR(20)
);

CREATE TABLE processamento_logs (
    id SERIAL PRIMARY KEY,
    lote_id INTEGER NOT NULL REFERENCES lotes_processamento(id) ON DELETE CASCADE,
    mensagem TEXT,
    tipo VARCHAR(20),
    data_criacao TIMESTAMP DEFAULT NOW()
);

CREATE TABLE credenciais_api_clientes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    api_key VARCHAR(200),
    secret_key VARCHAR(200),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT NOW()
);
