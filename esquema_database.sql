create database ecommerce_refinado;
use ecommerce_refinado;
show tables;
CREATE TABLE clients(
idClient INT AUTO_INCREMENT PRIMARY KEY,
Fname varchar(20),
Minit char(3),
Lname varchar(30),
Address varchar(255)
);

CREATE TABLE client_pf (
    idClient INT,
    CPF CHAR(11) NOT NULL,
    CONSTRAINT pk_client_pf PRIMARY KEY (idClient),
    CONSTRAINT uq_client_pf_cpf UNIQUE (CPF),
    CONSTRAINT fk_client_pf FOREIGN KEY (idClient)
        REFERENCES clients(idClient)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE client_pj (
    idClient INT,
    CNPJ CHAR(15) NOT NULL,
    SocialName VARCHAR(255) NOT NULL,
    CONSTRAINT pk_client_pj PRIMARY KEY (idClient),
    CONSTRAINT uq_client_pj_cnpj UNIQUE (CNPJ),
    CONSTRAINT fk_client_pj FOREIGN KEY (idClient)
        REFERENCES clients(idClient)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    classification_Kids bool default false,
    Category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    review FLOAT DEFAULT 0 CHECK (review BETWEEN 0 AND 5),
    size VARCHAR(10)
);

create table payments(
idPayment int AUTO_INCREMENT PRIMARY KEY,
idClient int NOT NULL,
typePayment ENUM('Boleto','Cartão', 'Dois Cartões') NOT NULL,
limitAvaliable FLOAT CHECK (limitAvaliable >= 0),
dataValid DATE,
CONSTRAINT fk_payment_client FOREIGN KEY (idClient) 
	REFERENCES clients(idClient)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);


create table Orders(
idOrder INT AUTO_INCREMENT PRIMARY KEY,
idOrderClient INT NOT NULL,
orderStatus ENUM('Cancelado','Confirmado','Em Processamento') DEFAULT 'Em Processamento',
orderDescription VARCHAR(255),
sendValue FLOAT DEFAULT 10,
paymentCash BOOL DEFAULT FALSE, 
CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) 
    REFERENCES clients(idClient)
	ON UPDATE CASCADE
    ON DELETE RESTRICT
);


create table ProductStorage(
idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
storageLocation VARCHAR(255),
quantity INT DEFAULT 0
);

create table supplier(
idSupplier INT AUTO_INCREMENT PRIMARY KEY,
SocialName VARCHAR(255) NOT NULL,
CNPJ CHAR(15) NOT NULL,
contact CHAR(11) NOT NULL,
CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CPF CHAR(11),
    CNPJ CHAR(14),
    location VARCHAR(255) NOT NULL,
    contact CHAR(11) NOT NULL,

    CONSTRAINT uq_seller_cpf UNIQUE (CPF),
    CONSTRAINT uq_seller_cnpj UNIQUE (CNPJ),

    -- Regra de exclusividade PF ou PJ
    CONSTRAINT chk_seller_pf_pj CHECK (
        (CPF IS NOT NULL AND CNPJ IS NULL)
        OR
        (CPF IS NULL AND CNPJ IS NOT NULL)
    )
);

CREATE TABLE product_seller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1 CHECK (prodQuantity >= 0),
	 CONSTRAINT pk_product_seller 
        PRIMARY KEY (idSeller, idProduct),

     CONSTRAINT fk_ps_seller FOREIGN KEY (idSeller)
        REFERENCES seller(idSeller)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_ps_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE product_order (
    idOrder INT,
    idProduct INT,
    quantity INT NOT NULL DEFAULT 1,
    itemStatus ENUM('Disponível','Sem estoque') 
        DEFAULT 'Disponível',
        
    CONSTRAINT pk_product_order 
    PRIMARY KEY (idOrder, idProduct),
    
    CONSTRAINT chk_po_quantity 
        CHECK (quantity > 0),

    CONSTRAINT fk_po_order 
        FOREIGN KEY (idOrder)
        REFERENCES orders(idOrder)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_po_product 
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE storage_location (
    idProduct INT,
    idLstorage INT,
    quantity INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    CONSTRAINT pk_storage_location 
        PRIMARY KEY (idProduct, idLstorage),
        
    CONSTRAINT chk_storage_quantity 
        CHECK (quantity >= 0),

    CONSTRAINT fk_sl_product 
        FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sl_location_storage
        FOREIGN KEY (idLstorage)
        REFERENCES ProductStorage(idProductStorage)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE product_supplier (
    idSupplier INT,
    idProduct INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
       CONSTRAINT pk_product_supplier 
        PRIMARY KEY (idSupplier, idProduct),
     CONSTRAINT fk_ps_supplier_supplier FOREIGN KEY (idSupplier)
        REFERENCES supplier(idSupplier)
        ON DELETE CASCADE,
    CONSTRAINT fk_ps_product_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
        ON DELETE CASCADE
);

CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    deliveryStatus ENUM('Aguardando envio','Enviado','Em trânsito','Entregue') 
        DEFAULT 'Aguardando envio',
    trackingCode VARCHAR(50),

    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder)
        REFERENCES orders(idOrder)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Select
select * from clients;
select * from client_pf;
select * from client_pj;
select * from orders;
select * from payments;
select * from product;
select * from product_order;
select * from product_seller;
select * from product_supplier;
select * from product_storage;
select * from seller;
select * from storage_location;
select * from supplier;
 
-- Insert

INSERT INTO clients (Fname, Minit, Lname, Address)
		VALUES ('Maria', 'M', 'Silva', 'rua silva da prata 29, Carangola - Cidade das flores'),
			   ('Matheus', 'O','Pimentel', 'rua alameda 289, Centro - Cidades das flores'),
               ('Ricardo', 'F', 'Silva', 'avenida alameda vinha 1009 , Centro - Cidade das flores'),
               ('Julia', 'S', 'França', 'rua laranjeiras 861, Centro - Cidade das flores'),
               ('Roberta', 'G', 'Assis', 'avenida koller 19, Centro - Cidade das flores'),
               ('Isabela', 'M', 'Cruz', 'rua alameda das flores 28, Centro - Cidade das flores'),
               ('Mariane','G','Pinto', 'Rua Conceição 1234, Centro - Santos'),
               ('Carlos','A', 'Andrades', 'Rua Teresa 345, São Pedro - Alagoas');
               
INSERT INTO client_pj(idClient, CNPJ, SocialName)
		VALUES (7, '12345678912345','MultiTreco LTDA'),
			  (8, '12345543217890', 'Tudo Certo LTDA');
              
INSERT INTO client_pf(idClient, CPF)
		VALUES (1, '12345678923'),
			   (2, '98765432134'),
               (3, '45678913455'),
               (4, '78912345656'),
               (5, '98745631670'),
               (6, '65478912378');
               
INSERT INTO supplier (SocialName, CNPJ, contact)
VALUES
('Almeida e filhos', '123456789123456', '21985474'),
('Eletrônicos Silva', '854519649143457', '21985484'),
('Eletrônicos Valma', '934567893934695', '21975474');

INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact)
VALUES
('Tech eletronics', NULL, '12345678945632', NULL, 'Rio de Janeiro', '219946287'),
('Botique Durgas', NULL, NULL, '12345678300', 'Rio de Janeiro', '219567895'),
('Kids World', NULL, '45678912365448', NULL, 'São Paulo', '1198657484');

insert into product (Pname, classification_kids, category, review, size)
	values ('Fone de ouvido', false, 'Eletrônico', '4', null),
	       ('Barbie Elsa', true, 'Brinquedos', '3', null),
           ('Body Carters', true, 'Vestimenta', '5', null),
           ('Microfone Vedo - Youtube', False, 'Eletrônico', '4', null),
           ('Sofá retrátil', False, 'Móveis', '3', '3x57x80' ),
           ('Farinha de Arroz', False, 'Alimentos', '2', null),
           ('Fire Stick Amazon', False, 'Eletrônico', '3', null);
           
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
		values(1, 'Em Processamento', 'Compra via aplicativo', null, 1),
			  (2, 'Em Processamento', 'Compra via aplicativo', 50, 0),
              (3, 'Confirmado', null, null, 1),
              (4, 'Em Processamento', 'Compra via web site', 150, 0);

  insert into product_order (idOrder, idProduct, Quantity)
		values (9, 1, 2),
			   (10, 2, 1),
               (11, 3, 1);

insert into product_storage (storageLocation, quantity)
		values ('Rio de Janeiro', 1000),
			   ('Rio de Janeiro', 500),
               ('São Paulo', 10),
               ('São Paulo', 100),
               ('São Paulo', 10),
               ('Brasília', 60);
               
INSERT INTO product_seller (idSeller, idProduct, prodQuantity)
VALUES
(1, 6, 80),
(2, 7, 10);

INSERT INTO product_supplier (idSupplier, idProduct, quantity)
VALUES
(1, 1, 500),
(1, 2, 400),
(2, 4, 633),
(3, 3, 5),
(2, 5, 10);

INSERT INTO storage_location (idProduct, idLstorage, quantity, location)
VALUES
(1, 2, 100, 'RJ'),
(2, 6, 50, 'GO');

-- atualizar a quantidade do produto  
UPDATE product_order
SET quantity = quantity + 1
WHERE idOrder = 9 AND idProduct = 1;

-- Atualiza a quantidade para pode inserir valores na Product_seller
UPDATE product_seller
SET prodQuantity = prodQuantity + 20
WHERE idSeller = 1 AND idProduct = 6;

-- where
-- Quais são os clientes PF?
select c.idClient, c.Fname, c.Lname
from clients c join client_pf pf
on pf.idClient = c.idClient
order by c.idClient;

-- Quais são os cliente PF?
SELECT c.idClient, c.Fname, c.Lname
FROM clients c join client_pj pj
on pj.idClient = c.idClient
order by c.idClient;

-- Quantos clientes PF e PJ existem?
SELECT 'Pessoa Física' AS Tipo, COUNT(*) AS Total
FROM client_pf
UNION ALL
SELECT 'Pessoa Jurídica', COUNT(*)
FROM client_pj;

-- join
-- Algum vendedor também é fornecedor?
SELECT 
    s.idSeller,
    s.SocialName AS SellerName,
    f.SocialName AS SupplierName
FROM seller s
JOIN supplier f 
    ON s.CNPJ = f.CNPJ;

-- Qual o total de produtos por vendedor?
SELECT 
    s.SocialName,
    COUNT(ps.idProduct) AS TotalProducts
FROM seller s
JOIN product_seller ps ON s.idSeller = ps.idSeller
GROUP BY s.SocialName;

-- Qual a quantidade total vendida por vendedor?
SELECT 
    s.SocialName,
    SUM(ps.prodQuantity) AS TotalQuantity
FROM seller s
JOIN product_seller ps ON s.idSeller = ps.idSeller
GROUP BY s.SocialName
HAVING SUM(ps.prodQuantity) > 0
ORDER BY TotalQuantity DESC;

-- Quantos pedidos existem por status?
SELECT 
    orderStatus,
    COUNT(*) AS TotalPedidos
FROM orders
GROUP BY orderStatus;

-- Qual o valor total de frete (sendValue) por status de pedido?
SELECT 
    orderStatus,
    SUM(sendValue) AS TotalFrete
FROM orders
GROUP BY orderStatus;

-- Quais clientes já fizeram pedidos?
SELECT DISTINCT
    c.idClient,
    c.Fname,
    c.Lname
FROM clients c
JOIN orders o ON o.idOrderClient = c.idClient;

-- Quais clientes ainda não fizeram pedidos?
SELECT 
    c.idClient,
    c.Fname,
    c.Lname
FROM clients c
LEFT JOIN orders o ON o.idOrderClient = c.idClient
WHERE o.idOrder IS NULL;

-- Quantos produtos existem por categoria?
SELECT 
    category,
    COUNT(*) AS TotalProdutos
FROM product
GROUP BY category;

-- Quais produtos foram vendidos em cada pedido?
SELECT 
    o.idOrder,
    p.Pname,
    po.quantity
FROM product_order po
JOIN orders o ON o.idOrder = po.idOrder
JOIN product p ON p.idProduct = po.idProduct
ORDER BY o.idOrder;

-- Qual a quantidade total vendida por produto?
SELECT 
    p.Pname,
    SUM(po.quantity) AS TotalVendido
FROM product p
JOIN product_order po ON p.idProduct = po.idProduct
GROUP BY p.Pname
ORDER BY TotalVendido DESC;

-- Qual o valor total estimado do pedido (frete + itens)
SELECT 
    o.idOrder,
    SUM(po.quantity) + o.sendValue AS ValorTotalEstimado
FROM orders o
JOIN product_order po ON po.idOrder = o.idOrder
GROUP BY o.idOrder;

-- Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(o.idOrder) AS TotalPedidos
FROM clients c
LEFT JOIN orders o ON o.idOrderClient = c.idClient
GROUP BY c.idClient;





