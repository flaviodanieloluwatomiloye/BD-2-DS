CREATE DATABASE dbConfeitaria
GO

USE dbConfeitaria
GO

DROP TABLE IF EXISTS tbItensEncomenda
DROP TABLE IF EXISTS tbProduto
DROP TABLE IF EXISTS tbEncomenda
DROP TABLE IF EXISTS tbCategoriaProduto
DROP TABLE IF EXISTS tbCliente

CREATE TABLE tbCliente (
	codCliente INT PRIMARY KEY IDENTITY (1, 1),
	nomeCliente VARCHAR (80),
	dataNascimentoCliente DATETIME,
	ruaCliente VARCHAR (50),
	numCasaCliente INT,
	cepCliente VARCHAR (9),
	bairroCliente VARCHAR (50),
	cidadeCliente VARCHAR (50),
	estadoCliente VARCHAR (30),
	cpfCliente VARCHAR (14),
	sexoCliente VARCHAR (1)
);

CREATE TABLE tbCategoriaProduto (
	codCategoriaProduto INT PRIMARY KEY IDENTITY (1, 1),
	nomeCategoriaProduto VARCHAR (25)
);

CREATE TABLE tbEncomenda (
	codEncomenda INT PRIMARY KEY IDENTITY (1, 1),
	dataEncomenda DATE,
	valorTotalEncomenda MONEY,
	dataEntregaEncomenda DATE,
	codCliente INT FOREIGN KEY (codCliente) REFERENCES tbCliente(codCliente)
);

CREATE TABLE tbProduto (
	codProduto INT PRIMARY KEY IDENTITY (1, 1),
	nomeProduto VARCHAR (30),
	precoKiloProduto MONEY,
	codCategoriaProduto INT FOREIGN KEY (codCategoriaProduto) REFERENCES tbCategoriaProduto(codCategoriaProduto)
);

CREATE TABLE tbItensEncomenda (
	codItensEncomenda INT PRIMARY KEY IDENTITY (1, 1),
	quantidadeKilos FLOAT,
	subTotal MONEY,
	codEncomenda INT FOREIGN KEY (codEncomenda) REFERENCES tbEncomenda(codEncomenda),
	codProduto INT FOREIGN KEY (codProduto) REFERENCES tbProduto(codproduto)
);