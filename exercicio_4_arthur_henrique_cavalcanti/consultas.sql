1)
select nome, endereco from Cliente
2)
select nome, funcao from Mecanico where cods = 2
3)
select m.nome,m.cpf from Mecanico m intersect select c.nome,c.cpf from Cliente c
4)
select cidade from Mecanico union select cidade from Cliente
5)
select distinct marca from Veiculo v join Cliente c on v.codc=c.codc and cidade='Joinville'
6)
select distinct funcao from Mecanico
7)
select * from Cliente where idade>25
8)
select m.cpf,m.nome from Mecanico m join Setor s on m.cods=s.cods and s.nome='Mecânica'
9)
select m.cpf,m.nome from Mecanico m join Conserto c on data='2014-06-13' and m.codm=c.codm
10)
select c.nome,v.modelo,m.nome,m.funcao from Conserto co join Mecanico m using(codm) join Veiculo v using(codv) join Cliente c using(codc)
11)
select m.nome,c.nome,co.data from Conserto co join Mecanico m using(codm) join Veiculo v using(codv) join Cliente c using(codc) where data='2014-06-19'
12)
select cods, s.nome from Conserto co join Mecanico m using(codm) join Setor s using(cods) where data='2014-06-14' or data='2014-06-12'

 exemplo:
 select marca, modelo from veiculo v join cliente c using(codc) where ....