# 🛒 E-commerce Database Refinado

Projeto de modelagem e implementação de banco de dados relacional para um cenário de e-commerce, desenvolvido como parte do desafio do módulo de Modelagem de Dados.

---

## 📌 Objetivo do Projeto

Replicar e refinar a modelagem lógica de um banco de dados de e-commerce, aplicando:

- Chaves primárias e estrangeiras
- Constraints de integridade
- Relacionamentos 1:1, 1:N e N:N
- Mapeamento do modelo conceitual para o modelo lógico
- Persistência de dados
- Consultas SQL avançadas

---

## 🧩 Regras de Negócio Implementadas

- **Cliente PF e PJ**
  - Um cliente pode ser Pessoa Física ou Pessoa Jurídica, mas nunca ambos.
- **Pagamentos**
  - Um cliente pode possuir mais de uma forma de pagamento.
- **Entrega**
  - Cada pedido possui status de entrega e código de rastreio.
- **Vendedores e Fornecedores**
  - Um vendedor pode ou não ser também um fornecedor.
- **Estoque**
  - Controle de produtos por local de armazenamento.

---

## 🗂️ Estrutura do Banco de Dados

Principais tabelas:

- `clients`
- `client_pf`
- `client_pj`
- `orders`
- `payments`
- `delivery`
- `product`
- `seller`
- `supplier`
- `product_order`
- `product_seller`
- `product_supplier`
- `product_storage`
- `storage_location`

O relacionamento N:N é resolvido por tabelas associativas, garantindo integridade e normalização.

---

## 🛠️ Tecnologias Utilizadas

- MySQL
- MySQL Workbench
- SQL (DDL e DML)

---

## 🔎 Exemplos de Consultas SQL

- Quantos pedidos foram feitos por cada cliente
- Quais vendedores também são fornecedores
- Quantidade de produtos por vendedor
- Total vendido por produto
- Clientes que já realizaram pedidos
- Valor total estimado de pedidos (frete + itens)

As consultas utilizam:
- `JOIN`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- Atributos derivados

---

## 📷 Diagrama EER

O diagrama entidade-relacionamento foi desenvolvido no MySQL Workbench e representa visualmente todas as entidades e relacionamentos do projeto.

---

## 🚀 Como Executar

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/ecommerce-database-refinado.git
