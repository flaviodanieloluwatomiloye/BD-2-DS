CREATE DATABASE bdBancoEtec
GO

USE bdBancoEtec
GO

DROP TABLE IF EXISTS tbContaPoupanca;
DROP TABLE IF EXISTS tbContaCorrente;
DROP TABLE IF EXISTS tbCorrentista;

CREATE TABLE tbCorrentista (
	codCorrentista INT PRIMARY KEY IDENTITY (1, 1),
	nomeCorrentista VARCHAR (100),
	dataNascCorrentista DATETIME,
	cpfCorrentista VARCHAR (14),
	rgCorrentista VARCHAR (13)
);

CREATE TABLE tbContaPoupanca (
	codContaPoupanca INT PRIMARY KEY IDENTITY (1, 1),
	numeroAgenciaCP INT,
	numeroCP INT,
	digitoCP INT,
	saldoCP MONEY,
	dataAberturaCP DATETIME,
	codCorrentista INT FOREIGN KEY REFERENCES tbCorrentista (codCorrentista)
);

CREATE TABLE tbContaCorrente (
	codContaCorrente INT PRIMARY KEY IDENTITY (1, 1),
	numeroAgenciaCC INT,
	numeroCC VARCHAR (7),
	digitoCC INT,
	senhaNumericaCC INT,
	senhaAlfanumericaCC VARCHAR (16),
	saldoCC MONEY,
	dataAberturaCC DATETIME,
	codCorrentista INT FOREIGN KEY REFERENCES tbCorrentista (codCorrentista)
);

