USE bdBancoEtec
GO

INSERT INTO tbCorrentista (nomeCorrentista, dataNascCorrentista, cpfCorrentista, rgCorrentista) VALUES
('Rogerio Ceni', '1973-01-22T00:00:00', '123.456.789-00', '12.545.122-01'),
('Rai Vieira', '1965-05-15T00:00:00', '232.322.321-99', '18.332.232-10'),
('Armelindo Donizetti', '1965-10-10T00:00:00', '222.333.232-00', '12.433.233-00');

INSERT INTO tbContaCorrente (numeroAgenciaCC, numeroCC, digitoCC, senhaNumericaCC, senhaAlfanumericaCC, saldoCC, dataAberturaCC, codCorrentista) VALUES 
(1021, '123.122', 11, 111111, '6B3L3M', 100000.00, '2017-10-10T00:00:00', 1),
(1022, '212.121', 12, 12211, '2x1SP', 90000.00, '2014-12-12T00:00:00', 2),
(1021, '123.121', 11, 123456, '01MITO', 1200000.00, '2017-05-10T00:00:00', 1),
(1021, '324.544', 10, 839222, 'ZETTO1', 23498.90, '2015-05-10T00:00:00', 3);

INSERT INTO tbContaPoupanca (numeroAgenciaCP, numeroCP, digitoCP, saldoCP, dataAberturaCP, codCorrentista) VALUES
(1021, 434433, 4, 2000000.00, '2017-06-10T00:00:00', 1),
(1022, 322222, 5, 4000000.00, '2017-05-15T00:00:00', 2),
(1021, 232222, 6, 220000.00, '2017-04-10T00:00:00', 3);
