1)
select cpf, nome from mecanico where cods in (1, 2)
2)
select m.cpf, m.nome from mecanico m where m.cods in (
 select cods from setor where nome='Funilaria' or nome='Pintura'
)
3)
select cpf, nome from mecanico m  inner join conserto c using(codm) where data='2014-06-13'
4)
select m.nome, c.nome, hora from mecanico m inner join conserto co using(codm)
inner join veiculo v using(codv) inner join cliente c using(codc) where data='2014-06-12'
5)
select m.nome, m.funcao, cods, s.nome from mecanico m left join setor s using(cods)
6)
select distinct(nome), data from mecanico left join conserto using(codm)
7)
select avg(quilometragem) from veiculo
8)
select sum(quilometragem) from veiculo inner join cliente using(codc) group by cidade
9)
select codm, count(codv) from conserto where data between '2014-06-12' and '2014-06-19' group by codm
10)
select count(codv), marca from conserto c inner join veiculo v using(codv) group by marca
11)
select modelo, marca, ano from veiculo where quilometragem > all(select avg(quilometragem) from veiculo)
12)
select nome from mecanico where codm in (
	select codm from conserto join mecanico using(codm) group by codm,data
)

---------------------------------------------
select m.codm,v.codv from conserto c join veiculo v using(codv) join mecanico m using(codm)

select m.codm, v.codv from mecanico m join conserto c using(codm) join veiculo v using(codv)

select m.codm, v.codv from mecanico m left join conserto c using(codm) join veiculo v using(codv)

select m.codm, v.codv from mecanico m full join conserto c using(codm) full join veiculo v using(codv)