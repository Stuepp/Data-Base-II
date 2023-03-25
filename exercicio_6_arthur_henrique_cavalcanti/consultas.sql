1)
create view exe1 (nome, funcao) as
select nome, funcao from mecanico

select * from exe1
2)
create view exe2(mordelo, marca) as
select modelo,marca from veiculo

select * from exe2
3)
create view exe3(nomeM,nomeCl,marca,modelo,data,hora) as
select m.nome,cl.nome,marca,modelo,data,hora from conserto c join mecanico m using(codm) join veiculo v using(codv) join cliente cl using(codc)

select * from exe3
4)
create view exe4 (ano, km_medio) as
select ano,avg(quilometragem) from veiculo group by ano

select * from exe4
5)
create view exe5 (nome,data,consertos_realizados) as
select nome,data, count(hora) as consertos_realizados from conserto join mecanico m using(codm) group by data,nome

select * from exe5
6)
create view exe6 (nome_setor, consertos_realizados) as
select s.nome,data,count(hora) from conserto join mecanico using(codm) join setor s using(cods) group by s.nome,data

select * from exe6
7)
create view exe7 (funcao, qtd_mecanicos) as
select funcao, count(*) from mecanico group by funcao

select * from exe7
8)
create view exe8 (nome_mecanico, funcao,cods,nome_setor) as
select m.nome,funcao,cods,s.nome from mecanico m left join setor s using(cods)

select * from exe8
9)
create view exe9 (funcao, qtd_consertos) as
select funcao,count(data) as qtd_consertos from conserto c join mecanico m using(codm) group by funcao

select * from exe9