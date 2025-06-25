{% docs __overview__ %}

# 🚀 Overview do Projeto DBT - Projeto Um

> **🎯 Objetivo**: Pipeline de dados para e-commerce utilizando BigQuery como data warehouse

---

## 📋 Índice Rápido

- ⚙️ Configuração do Projeto
- 🏗️ Estrutura do Projeto  
- 📊 Fontes de Dados (Sources)
- 🌱 Seeds (Dados de Referência)
- 🔧 Modelos de Dados
- ✅ Testes e Qualidade de Dados
- ⚡ Execução do Projeto
- 📈 Schemas do BigQuery
- 🔮 Próximos Passos

---

## ⚙️ Configuração do Projeto

### 📦 Dependências

O projeto utiliza as seguintes bibliotecas Python, definidas no arquivo `requeriments.txt`:

```bash
dbt-core      # 🎯 Core do DBT
dbt-bigquery  # ☁️ Conector BigQuery
```

---

## 🏗️ Estrutura do Projeto

### 📄 Configuração Principal (`dbt_project.yml`)

```yaml
name: 'projeto_um'
version: '1.0.0'
profile: 'projeto_um'

# 🏛️ Configuração de schemas por camada
models:
  projeto_um:
    staging:
      schema: stg
      materialized: table
      tag: ['staging']
    intermediate:
      schema: int
      materialized: ephemeral
      tag: ['intermediate']
    marts:
      schema: marts
      materialized: table
      tag: ['marts']

seeds:
  projeto_um:
    schema: raw
    tags: ['seeds']
```

---

## 📊 Fontes de Dados (Sources)

### 🗂️ Schema: `dbt_dw_raw`

O projeto utiliza dados de e-commerce armazenados no schema `dbt_dw_raw` do BigQuery, definidos no arquivo `models/staging/sources.yml`.

#### 📋 Tabelas Disponíveis:

| 🏷️ Tabela | 📝 Descrição | 🔑 Chaves |
|-----------|-------------|-----------|
| **🛍️ avaliacoes** | Avaliações dos produtos pelos clientes | `cliente_id`, `produto_id` |
| **🛒 carrinho** | Carrinho de compras dos clientes | `cliente_id`, `produto_id` |
| **📂 categorias** | Categorias dos produtos | `id` (PK) |
| **👥 clientes** | Informações dos clientes | `id` (PK) |
| **📦 itens_pedidos** | Itens individuais dos pedidos | `pedido_id`, `produto_id` |
| **💳 pagamentos** | Informações de pagamento | `id` (PK), `pedido_id` |
| **📋 pedidos** | Pedidos realizados | `id` (PK), `cliente_id` |
| **🛍️ produtos** | Catálogo de produtos | `id` (PK), `categoria_id` |

#### 📊 Detalhamento das Tabelas:

**🛍️ avaliacoes** - Avaliações dos produtos pelos clientes
- `cliente_id` - Chave estrangeira do cliente
- `produto_id` - Chave estrangeira do produto  
- `nota` - Nota da avaliação
- `comentario` - Comentário da avaliação
- `data_avaliacao` - Data da avaliação

**🛒 carrinho** - Carrinho de compras dos clientes
- `cliente_id` - Chave estrangeira do cliente
- `produto_id` - Chave estrangeira do produto
- `quantidade` - Quantidade do produto no carrinho

**📂 categorias** - Categorias dos produtos
- `id` - Chave primária da categoria
- `nome` - Nome da categoria

**👥 clientes** - Informações dos clientes
- `id` - Chave primária do cliente
- `nome` - Nome do cliente
- `email` - Email do cliente
- `telefone` - Telefone do cliente
- `data_registro` - Data de registro do cliente

**📦 itens_pedidos** - Itens dos pedidos
- `pedido_id` - Chave estrangeira do pedido
- `produto_id` - Chave estrangeira do produto
- `quantidade` - Quantidade do produto no pedido
- `preco_unitario` - Preço unitário do produto
- `subtotal` - Subtotal do pedido

**💳 pagamentos** - Informações de pagamento
- `id` - Chave primária do pagamento
- `pedido_id` - Chave estrangeira do pedido
- `valor` - Valor do pagamento
- `metodo` - Método de pagamento
- `status` - Status do pagamento
- `data_pagamento` - Data do pagamento

**📋 pedidos** - Pedidos realizados
- `id` - Chave primária do pedido
- `cliente_id` - Chave estrangeira do cliente
- `endereco_id` - Chave estrangeira do endereço
- `data_pedido` - Data do pedido
- `status` - Status do pedido

**🛍️ produtos** - Catálogo de produtos
- `id` - Chave primária do produto
- `nome` - Nome do produto
- `descricao` - Descrição do produto
- `categoria_id` - Chave estrangeira da categoria
- `preco` - Preço do produto
- `marca` - Marca do produto
- `estoque` - Quantidade em estoque
- `data_cadastro` - Data de cadastro do produto

---

## 🌱 Seeds (Dados de Referência)

O projeto inclui arquivos CSV na pasta `seeds/` que são carregados como tabelas de referência no schema `raw`:

### 📊 Arquivos Disponíveis:

| 📁 Arquivo | 📊 Linhas | 📝 Descrição |
|------------|-----------|--------------|
| `avaliacoes.csv` | 1.502 | Avaliações dos produtos |
| `carrinho.csv` | 1.002 | Carrinho de compras |
| `categorias.csv` | 9 | Categorias de produtos |
| `clientes.csv` | 1.002 | Dados dos clientes |
| `itens_pedidos.csv` | 6.090 | Itens dos pedidos |
| `pagamentos.csv` | 2.002 | Informações de pagamento |
| `pedidos.csv` | 2.002 | Pedidos realizados |
| `produtos.csv` | 502 | Catálogo de produtos |

**📈 Total de registros**: 14.111 linhas de dados

---

## 🔧 Modelos de Dados

### 🏗️ Arquitetura em Camadas

```
┌─────────────────┐
│   📊 Sources    │ ← Dados brutos do BigQuery
│  (dbt_dw_raw)   │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   🧹 Staging    │ ← Limpeza e padronização
│    (schema:stg) │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│ 🔄 Intermediate │ ← Lógica de negócio
│   (ephemeral)   │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   🎯 Marts      │ ← Modelos finais
│  (schema:marts) │
└─────────────────┘
```

### 🧹 Camada Staging (`models/staging/`)

Modelos que fazem a limpeza e padronização dos dados brutos:

| 📄 Modelo | 🎯 Função | 🏷️ Schema |
|-----------|-----------|-----------|
| `stg_avaliacoes.sql` | Limpeza da tabela de avaliações | `stg` |
| `stg_carrinho.sql` | Limpeza da tabela de carrinho | `stg` |
| `stg_categorias.sql` | Limpeza da tabela de categorias | `stg` |
| `stg_clientes.sql` | Limpeza da tabela de clientes | `stg` |
| `stg_itens_pedidos.sql` | Limpeza da tabela de itens de pedidos | `stg` |
| `stg_pagamentos.sql` | Limpeza da tabela de pagamentos | `stg` |
| `stg_pedidos.sql` | Limpeza da tabela de pedidos | `stg` |
| `stg_produtos.sql` | Limpeza da tabela de produtos | `stg` |

**⚙️ Configuração**: Materializados como tabelas no schema `stg`

### 🔄 Camada Intermediária (`models/intermediate/`)

Modelos que implementam lógica de negócio complexa:

| 📄 Modelo | 🎯 Função | 🏷️ Tags |
|-----------|-----------|---------|
| `int_pedidos_vendidos.sql` | Agregação de dados de vendas | `vendas` |

**🔗 Junções realizadas:**
- Pedidos ↔ Clientes
- Pedidos ↔ Itens de Pedidos  
- Itens ↔ Produtos
- Produtos ↔ Categorias
- Pedidos ↔ Pagamentos

**⚙️ Configuração**: Materializados como ephemeral (CTEs)

### 🎯 Camada Marts (`models/marts/`)

Modelos finais otimizados para consumo:

| 📄 Modelo | 🎯 Função | 🏷️ Tags |
|-----------|-----------|---------|
| `fct_pedidos_vendidos.sql` | Fato de pedidos vendidos | `vendas` |

**📊 Métricas calculadas:**
- Valor total por cliente
- Quantidade por produto
- Método de pagamento
- Status de pagamento
- Categoria do produto

**⚙️ Configuração**: Materializados como tabelas no schema `marts`

---

## ✅ Testes e Qualidade de Dados

### 🧪 Testes Genéricos

O arquivo `sources.yml` define testes automáticos para as colunas:

| 🎯 Tipo de Campo | ✅ Testes Aplicados |
|------------------|-------------------|
| **🔑 Chaves primárias** | `not_null` + `unique` |
| **🔗 Chaves estrangeiras** | `not_null` |
| **📝 Campos obrigatórios** | `not_null` |

### 🏗️ Estrutura de Testes

- 📁 Pasta `tests/` disponível para testes customizados
- 🔧 Pasta `macros/` disponível para macros de teste reutilizáveis

---

## ⚡ Execução do Projeto

### 🚀 Comandos Principais

```bash
# 📁 Navegar para o diretório do projeto
cd projeto_um

# 🔄 Executar todos os modelos
dbt run

# 🧹 Executar apenas modelos de staging
dbt run --select staging

# 🎯 Executar apenas modelos de marts
dbt run --select marts

# ✅ Executar testes
dbt test

# 🌱 Executar seeds
dbt seed

# 📚 Gerar documentação
dbt docs generate
dbt docs serve

# 📸 Executar snapshots
dbt snapshot
```

### 🏷️ Tags Disponíveis

| 🏷️ Tag | 🎯 Descrição |
|--------|--------------|
| `staging` | Modelos de staging |
| `intermediate` | Modelos intermediários |
| `marts` | Modelos de marts |
| `seeds` | Dados de referência |
| `vendas` | Modelos relacionados a vendas |

---

## 📈 Schemas do BigQuery

### 🗂️ Schemas Utilizados:

| 🏷️ Schema | 🎯 Propósito | 📊 Tipo |
|-----------|--------------|---------|
| **`dbt_dw_raw`** | Dados brutos | Sources |
| **`raw`** | Seeds | Dados de referência |
| **`stg`** | Modelos de staging | Tabelas |
| **`int`** | Modelos intermediários | Ephemeral |
| **`marts`** | Modelos finais | Tabelas |

### 🔄 Fluxo de Dados

```
dbt_dw_raw → stg → int → marts
    ↓         ↓     ↓     ↓
  Sources  Staging Int.  Marts
```

---

## 📊 Monitoramento e Logs

- 📝 Logs de execução armazenados em `logs/`
- 🎯 Target de compilação em `target/`
- 📚 Artefatos de documentação gerados automaticamente

---

## 🔮 Próximos Passos

### 🚀 Roadmap de Desenvolvimento

1. **🔧 Implementar macros customizados** para lógica reutilizável
2. **✅ Adicionar testes customizados** para validações específicas de negócio
3. **📸 Implementar snapshots** para rastreamento de mudanças
4. **📚 Expandir documentação** dos modelos
5. **🔄 Configurar CI/CD** para automação do pipeline

### 🎯 Prioridades

| 📊 Prioridade | 🎯 Item | 📅 Timeline |
|---------------|---------|------------|
| 🔴 Alta | Macros customizados | Próxima sprint |
| 🟡 Média | Testes customizados | 2 sprints |
| 🟢 Baixa | Documentação expandida | 3 sprints |

---

## 📞 Contato e Suporte

### 🔗 Links Úteis

- 📚 [Documentação oficial do DBT](https://docs.getdbt.com/)
- 🎯 [DBT Community](https://community.getdbt.com/)
- 📖 [DBT Best Practices](https://docs.getdbt.com/guides/best-practices)

### 💡 Dicas Rápidas

> 💡 **Dica**: Use `dbt run --select tag:vendas` para executar apenas modelos relacionados a vendas

> 💡 **Dica**: Use `dbt test --select source:ecomerce` para testar apenas as fontes de dados

> 💡 **Dica**: Use `dbt docs serve` para visualizar a documentação interativa

---

{% enddocs %} 