USE dbConfeitaria
GO

-- A) criar uma Stored Procedure para inserir as categorias de produto conforme ilustrado

CREATE OR ALTER PROCEDURE SPCategoriaProduto
@nomeCategoriaProduto VARCHAR(25)
AS
BEGIN
	INSERT INTO tbCategoriaProduto (nomeCategoriaProduto) 
	VALUES (@nomeCategoriaProduto)
END

EXEC SPCategoriaProduto 'Bolo Festa'
EXEC SPCategoriaProduto 'Bolo Simples'
EXEC SPCategoriaProduto 'Torta'
EXEC SPCategoriaProduto 'Salgado'
GO

SELECT*FROM tbCategoriaProduto





/*
B) Criar uma Stored Procedure para inserir os produtos abaixo, sendo que, a procedure
deverá antes de inserir verificar se o nome do produto ja existe, evitando assim que
produto seja duplicado
*/

CREATE OR ALTER PROCEDURE SPProduto
@nomeProduto VARCHAR(30),
@precoKiloProduto MONEY,
@codCategoriaProduto INT
AS
BEGIN
	IF EXISTS (SELECT * FROM tbProduto WHERE nomeProduto = @nomeProduto)
	BEGIN
		PRINT 'Nome do produto ja cadastrado (' + @nomeProduto + ')'
	END
	ELSE 
	BEGIN
		INSERT INTO tbProduto (nomeProduto, precoKiloProduto, codCategoriaProduto)
		VALUES (@nomeProduto, @precoKiloProduto, @codCategoriaProduto)
	END
END

EXEC SPProduto 'Bolo Floresta Negra', 42.00, 1
EXEC SPProduto 'Bolo Prestígio', 43.00, 1
EXEC SPProduto 'Bolo Nutella', 44.00, 1
EXEC SPProduto 'Bolo Formigueiro', 17.00, 2
EXEC SPProduto 'Bolo cenoura', 19.00, 2
EXEC SPProduto 'Torta de palmito', 54.00, 3
EXEC SPProduto 'Torta de frango e catupiry', 47.00, 3
EXEC SPProduto 'Torta de escarola', 44.00, 3
EXEC SPProduto 'Coxinha frango', 25.00, 4
EXEC SPProduto 'Esfinha carne', 27.00, 4
EXEC SPProduto 'Folhado queijo', 31.00, 4
EXEC SPProduto 'Risoles misto', 29.00, 4
GO

--teste
EXEC SPProduto 'Risoles misto', 12.00, 2
GO

SELECT*FROM tbProduto





/*
c) Criar uma stored procedure para cadastrar os clientes abaixo relacionados, 
sendo que deverão ser feitas duas validações:

Verificar pelo CPF se o cliente já existe. Caso já exista emitir a mensagem: 
"Cliente cpf XXXXX já cadastrado"
Verificar se o cliente é morador de Itaquera ou Guaianases, pois 
a confeitaria não realiza entregas para clientes que residam fora desses bairros.
Caso o cliente não seja morador desses bairros enviar a mensagem 
"Não foi possível cadastrar o cliente XXXX pois o bairro XXXX não é atendido pela confeitaria"
*/

CREATE OR ALTER PROCEDURE SPCliente
@nomeCliente VARCHAR (80),
@dataNascimentoCliente DATETIME,
@ruaCliente VARCHAR (50),
@numCasaCliente INT,
@cepCliente VARCHAR (9),
@bairroCliente VARCHAR (50),
@cpfCliente VARCHAR (14),
@sexoCliente VARCHAR (1)
AS
BEGIN
	IF EXISTS (SELECT * FROM tbCliente WHERE cpfCliente = @cpfCliente)
	BEGIN
		PRINT 'Cliente cpf ' +@cpfCliente+ ' já cadastrado'
	END
	ELSE IF @bairroCliente NOT IN ('Guaianases', 'Itaquera')
	BEGIN
		PRINT 'Não foi possível cadastrar o cliente ' +@nomeCliente+ ' pois o bairro ' +@bairroCliente+ ' não é atendido pela confeitaria'
	END
	ELSE
	BEGIN
		INSERT INTO tbCliente (nomeCliente, dataNascimentoCliente, ruaCliente, numCasaCliente, cepCliente, bairroCliente, cpfCliente, sexoCliente)
		VALUES (@nomeCliente, @dataNascimentoCliente, @ruaCliente, @numCasaCliente, @cepCliente, @bairroCliente, @cpfCliente, @sexoCliente)
	END
END

EXEC SPCliente 'Samira Fatah', '1990-05-05T00:00:00', 'Rua Aguapeí', 1000, '08090-000', 'Guaianases', '111.111.111-11', 'F'
EXEC SPCliente 'Celia Nogueira', '1992-06-06T00:00:00', 'Rua Andes', 234, '08456-090', 'Guaianases', '222.222.222-22', 'F'
EXEC SPCliente 'Paulo Cesar Siqueira', '1984-04-04T00:00:00', 'Rua Castelo do Piauí', 232, '08109-000', 'Itaquera', '333.333.333-33', 'M'
EXEC SPCliente 'Rodrigo Favaroni', '1991-04-09T00:00:00', 'Rua Sansão Castelo Branco', 10, '08431-090', 'Guaianases', '444.444.444-44', 'M'
EXEC SPCliente 'Flávia Regina Brito', '1992-04-22T00:00:00', 'Rua Mariano Moro', 300, '08200-123', 'Itaquera', '555.555.555-55', 'F'
GO 

SELECT * FROM tbCliente





/*
d) Criar via stored procedure as encomendas abaixo relacionadas, fazendo as verificações abaixo:

No momento da encomenda o cliente irá fornecer o seu cpf. Caso ele não tenha sido cadastrado enviar 
a mensagem "não foi possível efetivar a encomenda pois o cliente xxxx não está cadastrado"
Caso tudo esteja correto, efetuar a encomenda e emitir a mensagem: 
"Encomenda XXX para o cliente YYY efetuada com sucesso" sendo que no lugar de XXX deverá 
aparecer o número da encomenda e no YYY deverá aparecer o nome do cliente;
*/

CREATE OR ALTER PROCEDURE SPEncomenda
@dataEncomenda DATE,
@cpfCliente VARCHAR(14),
@valorTotalEncomenda MONEY,
@dataEntregaEncomenda DATE
AS
BEGIN
	DECLARE @codCliente INT
	DECLARE @nomeCliente VARCHAR(80)
	DECLARE @codEncomenda INT

	SELECT @codCliente = codCliente, @nomeCliente = nomeCliente
	FROM tbCliente
	WHERE cpfCliente = @cpfCliente

	IF @codCliente IS NULL
	BEGIN
		PRINT 'não foi possível efetivar a encomenda pois o cliente ' +@cpfCliente+ ' não está cadastrado'
	END
	ELSE
	BEGIN
		INSERT INTO tbEncomenda (dataEncomenda, valorTotalEncomenda, dataEntregaEncomenda, codCliente)
		VALUES (@dataEncomenda, @valorTotalEncomenda, @dataEntregaEncomenda, @codCliente)

		SET @codEncomenda = SCOPE_IDENTITY() --ta pega o id

		PRINT 'Encomenda ' + CONVERT(VARCHAR, @codEncomenda ) + ' para o cliente ' +@nomeCliente+ ' efetuada com sucesso'
	END
END

EXEC SPEncomenda '2026-08-08', '111.111.111-11', 450.00, '2026-08-15'
EXEC SPEncomenda '2026-10-10', '222.222.222-22', 200.00, '2026-10-15'
EXEC SPEncomenda '2026-10-10', '333.333.333-33', 150.00, '2026-12-10'
EXEC SPEncomenda '2026-10-06', '111.111.111-11', 250.00, '2026-10-12'
EXEC SPEncomenda '2026-10-05', '444.444.444-44', 150.00, '2026-10-12'
GO

--teste
EXEC SPEncomenda '2026-09-05', '444.999.444-44', 150.00, '2026-10-12'

SELECT * FROM tbEncomenda





/*
e) Criar via stored procedure os itens de encomenda abaixo relacionados.
*/

CREATE OR ALTER PROCEDURE SPItensEncomenda
@codEncomenda INT,
@codProduto INT,
@quantidadeKilos FLOAT,
@subTotal MONEY
AS
BEGIN 

	SELECT @codEncomenda = codEncomenda
	FROM tbEncomenda
	WHERE codEncomenda = @codEncomenda
	IF @codEncomenda IS NOT NULL
	BEGIN
	INSERT INTO tbItensEncomenda (codEncomenda, codProduto, quantidadeKilos, subTotal)
	VALUES (@codEncomenda, @codProduto, @quantidadeKilos, @subTotal)
	END
END

EXEC SPItensEncomenda 1, 1,  2.5, 105.00
EXEC SPItensEncomenda 1, 10, 2.6, 70.00
EXEC SPItensEncomenda 1, 9,  6,   150.00
EXEC SPItensEncomenda 1, 12, 4.3, 125.00
EXEC SPItensEncomenda 2, 9,  8,   200.00
EXEC SPItensEncomenda 3, 11, 3.2, 100.00
EXEC SPItensEncomenda 3, 9,  2,   50.00
EXEC SPItensEncomenda 4, 2,  3.5, 150.00
EXEC SPItensEncomenda 4, 3,  2.2, 100.00
EXEC SPItensEncomenda 5, 6,  3.4, 150.00
GO

SELECT * FROM tbItensEncomenda


/*
f) Após todos os cadastros, criar Stored procedures para alterar o que se pede:

1- O preço dos produtos da categoria "Bolo festa" sofreram um aumento de 10%

2- O preço dos produtos categoria "Bolo simples" estão em promoção e terão um desconto de 20%;

3- O preço dos produtos categoria "Torta" aumentaram 25%

4- O preço dos produtos categoria "Salgado", com exceção da esfiha de carne, sofreram um aumento de 20%
*/

-- F.1) Bolo Festa: +10%
CREATE OR ALTER PROCEDURE SPAumentaBoloFesta
AS
BEGIN
	UPDATE tbProduto
	SET precoKiloProduto = precoKiloProduto * 1.10
	WHERE codCategoriaProduto = (SELECT codCategoriaProduto FROM tbCategoriaProduto WHERE nomeCategoriaProduto = 'Bolo Festa')
END
GO

-- F.2) Bolo Simples: -20%
CREATE OR ALTER PROCEDURE SPDescontoBoloSimples
AS
BEGIN
	UPDATE tbProduto
	SET precoKiloProduto = precoKiloProduto * 0.80
	WHERE codCategoriaProduto = (SELECT codCategoriaProduto FROM tbCategoriaProduto WHERE nomeCategoriaProduto = 'Bolo Simples')
END
GO

-- F.3) Torta: +25%
CREATE OR ALTER PROCEDURE SPAumentoTorta
AS
BEGIN
	UPDATE tbProduto
	SET precoKiloProduto = precoKiloProduto * 1.25
	WHERE codCategoriaProduto = (SELECT codCategoriaProduto FROM tbCategoriaProduto WHERE nomeCategoriaProduto = 'Torta')
END
GO

-- F.4) Salgado: +20%, exceto Esfinha carne
CREATE OR ALTER PROCEDURE SPAumentoSalgado
AS
BEGIN
	UPDATE tbProduto
	SET precoKiloProduto = precoKiloProduto * 1.20
	WHERE codCategoriaProduto = (SELECT codCategoriaProduto FROM tbCategoriaProduto WHERE nomeCategoriaProduto = 'Salgado')
	AND nomeProduto <> 'Esfinha carne'
END
GO

EXEC SPAumentaBoloFesta
EXEC SPDescontoBoloSimples
EXEC SPAumentoTorta
EXEC SPAumentoSalgado
GO

SELECT * FROM tbProduto



/*
g) Criar uma procedure para excluir clientes pelo CPF sendo que:

1- Caso o cliente possua encomendas emitir a mensagem 
"Impossível remover esse cliente pois o cliente XXXX possui encomendas; onde XXXX é o nome do cliente.

2- Caso o cliente não possua encomendas realizar a remoção e emitir a mensagem 
"Cliente XXXX removido com sucesso", onde XXXX é o nome do cliente;
*/

CREATE OR ALTER PROCEDURE SPExcluirCliente
@cpfCliente VARCHAR(14)
AS
BEGIN
	DECLARE @codCliente INT
	DECLARE @nomeCliente VARCHAR(80)

	SELECT @codCliente = codCliente, @nomeCliente = nomeCliente
	FROM tbCliente
	WHERE cpfCliente = @cpfCliente

	IF EXISTS (SELECT * FROM tbEncomenda WHERE codCliente = @codCliente)
	BEGIN
		PRINT 'Impossivel remover esse cliente pois o cliente ' +@nomeCliente+ ' possui encomendas'
	END
	ELSE
	BEGIN
		DELETE FROM tbCliente WHERE codCliente = @codCliente
		PRINT 'Cliente ' +@nomeCliente+ ' removido com sucesso'
	END
END
GO

-- Teste 9tem que dar erro)
EXEC SPExcluirCliente '111.111.111-11'

-- Teste (tem que funcionar)
EXEC SPExcluirCliente '555.555.555-55'
GO

SELECT * FROM tbCliente