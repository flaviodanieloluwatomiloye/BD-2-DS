USE bdBancoEtec
GO


/*
a)Nome do correntista, saldo da conta corrente, saldo da
poupança e a soma dos dois saldos
*/
DROP VIEW vwSaldoTotal;
GO

CREATE VIEW  vwSaldoTotal AS

	SELECT nomeCorrentista AS 'Dono da conta', SUM(saldoCC) AS 'Saldo Conta Corrente', SUM(saldoCP) AS 'Saldo Conta Poupanca', (SUM(saldoCP) + SUM(saldoCC)) AS 'Saldo Total' FROM tbCorrentista

	INNER JOIN tbContaCorrente ON tbCorrentista.codCorrentista = tbContaCorrente.codCorrentista
	INNER JOIN tbContaPoupanca ON tbCorrentista.codCorrentista = tbContaPoupanca.codCorrentista

	GROUP BY nomeCorrentista;

SELECT * FROM vwSaldoTotal;


/*
 b)Utilizando a view vwSaldoTotal, ordenar os correntistas
 por ordem alfabética
 */
 DROP VIEW IF EXISTS vwSaldoTotalOrganizado;
 GO

 CREATE VIEW  vwSaldototalOrganizado AS 

	SELECT TOP 100 PERCENT * 
	FROM vwSaldoTotal 
	ORDER BY [dono da conta] ASC;

SELECT * FROM vwSaldototalOrganizado;


/*
c) vwProjecaoSaldoPoupanca
Nome do correntista e saldo da poupança atualizado após
acréscimo de 0.5% no próximo mês
*/
DROP VIEW IF EXISTS vwProjecaoSaldoPoupanca;
GO
 
CREATE VIEW vwProjecaoSaldoPoupanca AS
																						--Demorei para chegar em 1.005
	SELECT nomeCorrentista AS 'Correntista', saldoCP AS 'Saldo Atual Poupanca', (saldoCP * 1.005) AS 'Saldo Poupanca Proximo Mes' 
	FROM tbCorrentista
	
	INNER JOIN tbContaPoupanca ON tbCorrentista.codCorrentista = tbContaPoupanca.codCorrentista;
 
SELECT * FROM vwProjecaoSaldoPoupanca;

 
 
/*
d) Todos os dados da conta corrente ao lado do nome do
correntista (exceto senha numérica e alfanumérica), com a
data de abertura da conta corrente no formato dd/mm/aaaa
e o saldo da poupança
*/
DROP VIEW IF EXISTS vwExibeCorrentista;
GO
 
CREATE VIEW vwExibeCorrentista AS
	SELECT
		nomeCorrentista AS 'Correntista', codContaCorrente AS 'Codigo Conta Corrente', numeroAgenciaCC AS 'Agencia', numeroCC AS 'Numero Conta Corrente', 
		digitoCC AS 'Digito', saldoCC AS 'Saldo Conta Corrente', CONVERT(VARCHAR(10), dataAberturaCC, 103) AS 'Data Abertura',saldoCP AS 'Saldo Poupanca'
	FROM tbCorrentista

	INNER JOIN tbContaCorrente ON tbCorrentista.codCorrentista = tbContaCorrente.codCorrentista
	INNER JOIN tbContaPoupanca ON tbCorrentista.codCorrentista = tbContaPoupanca.codCorrentista;

SELECT * FROM vwExibeCorrentista;
 
 
 /*
e) Nome do correntista, número da conta corrente e saldo da
conta corrente, apenas dos que possuem mais de R$500000,00
na conta corrente, ordenados do maior para o menor saldo
*/
DROP VIEW IF EXISTS vwCorrentistaConta;
GO
 
CREATE VIEW vwCorrentistaConta AS
	SELECT TOP 100 PERCENT
		nomeCorrentista AS 'Correntista', numeroCC AS 'Numero Conta Corrente', saldoCC AS 'Saldo Conta Corrente'
	FROM tbCorrentista

	INNER JOIN tbContaCorrente ON tbCorrentista.codCorrentista = tbContaCorrente.codCorrentista

	WHERE saldoCC > 500000.00
	ORDER BY saldoCC DESC;
 
SELECT * FROM vwCorrentistaConta;