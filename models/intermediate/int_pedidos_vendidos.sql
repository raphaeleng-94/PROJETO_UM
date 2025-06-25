{{ config(
    tags=['vendas']
) }}

with pedidos as (
    select * from {{ ref('stg_pedidos') }}
)

, clientes as (
    select * from {{ ref('stg_clientes') }}
)

, produtos as (
    select * from {{ ref('stg_produtos') }}
)

, itens_pedidos as (
    select * from {{ ref('stg_itens_pedidos') }}
)

, pagamentos as (
    select * from {{ ref('stg_pagamentos') }}
)

, categorias as (
    select * from {{ ref('stg_categorias') }}
)

, joined as (
    select
        clientes.nome as cliente_nome,
        clientes.email as cliente_email,
        pagamentos.valor as valor,
        pagamentos.metodo as metodo_pagamento,
        pagamentos.status as status_pagamento,
        pagamentos.data_pagamento as data_pagamento,
        produtos.nome as produto_nome,
        itens_pedidos.quantidade as quantidade,
        produtos.preco as produto_preco,
        produtos.marca as produto_marca,
        categorias.nome as categoria_nome,
        itens_pedidos.preco_unitario as valor_unitario
    from pedidos
    left join clientes on pedidos.cliente_id = clientes.id
    left join itens_pedidos on pedidos.id = itens_pedidos.pedido_id    
    left join produtos on itens_pedidos.produto_id = produtos.id
    left join categorias on produtos.categoria_id = categorias.id
    left join pagamentos on pedidos.id = pagamentos.pedido_id
)

select *
from joined