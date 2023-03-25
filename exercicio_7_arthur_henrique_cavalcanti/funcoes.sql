--1)  Função para inserção de um mecânico.
create or replace function insert_mecanico(vcodm int, vcpf int, vnome varchar, vidade int, vendereco varchar, vcidade varchar, vfuncao varchar) returns void as 
$$
begin
    insert into mecanico(codm, cpf, nome, idade, endereco, cidade, funcao) values (vcodm, vcpf, vnome, vidade, vendereco, vcidade, vfuncao);
    -- print na tela: raise notice 'Deu certo!'
end;
$$
language plpgsql;

select insert_mecanico(10, 3242343, 'nomeInserido', 21, 'endereco inserido', 'cidade inserida', 'critico')

select * from mecanico
--2) Função para exclusão de um mecânico. 
create or replace function delete_mecanico(vcodm int) returns void as 
$$
begin
    delete from mecanico where codm =  vcodm;
    -- print na tela: raise notice 'Deu certo!'
end;
$$
language plpgsql;

select delete_mecanico(10);

select * from mecanico
--3) Função única para inserção, atualizar e exclusão de um cliente.
create or replace function insere_atualiza_exclui(op char,vcodc int, vcpf varchar, vnome varchar, vidade int, vendereco varchar, vcidade varchar) returns void as 
$$
begin
	if (op = 'i') then
		insert into cliente(codc, cpf, nome, idade, endereco, cidade) values (vcodc, vcpf, vnome, vidade, vendereco, vcidade);
	elsif (op = 'a') then
		update cliente set cpf=vcpf, nome = vnome, idade = vidade, endereco = vendereco, cidade = vcidade where codc = vcodc;
	elsif (op = 'e') then
		delete from cliente where codc =  vcodc;
	end if;
end;
$$
language plpgsql;

select insere_atualiza_exclui('i', 8, '10000110000', 'Joao', 21, 'jabnfasjs', 'Jajnasjdna');

select * from cliente
--4) Função que limite o cadastro de no máximo 10 setores na oficina mecânica.
create or replace function limita_setor(vcods int, vnome varchar) returns void as
$$
declare vnro int;
begin
	select count(cods) from setor into vnro;
	if(vnro<10) then
		insert into setor(cods,nome) values (vcods,vnome);
	else
		raise notice 'MAX LIMTE';
	end if;
end
$$
language plpgsql;

select limita_setor(11,'adasdasdasda');

select * from setor

--5) Função que limita o cadastro de um conserto apenas se o mecânico não tiver mais de 3 consertos agendados para o mesmo dia.
create or replace function limita_conserto(vcodm int, vcodv int, vdata date, vhora time without time zone) returns void as
$$
declare vnro int;
begin
	select count(codm) from conserto where codm = vcodm and data=vdata group by data into vnro;
	if(vnro < 3) then
		insert into conserto(codm,codv,data,hora) values (vcodm,vcodv,vdata,vhora);
	else
		raise notice 'lotado';
	end if;
end;
$$
language plpgsql;

select limita_conserto(1, 5, '2014-06-12','17:00:00');

select * from conserto where codm = 1
--6) Função para calcular a média geral de idade dos Mecânicos e Clientes. --melhorar
create or replace function avg_idade_mecanico_cliente() returns void as 
$$
declare vavgmecanico int;
declare vavgcliente int;
begin
	select avg(idade) as idade_media_mecanico from mecanico into vavgmecanico;
	select avg(idade) as idade_media_cliente from cliente into vavgcliente;
	raise notice 'As idades médias são: %', (vavgmecanico+vavgcliente)/2;
end
$$
language plpgsql;

select avg_idade_mecanico_cliente();
--7) Função única que permita fazer a exclusão de um Setor, Mecânico, Cliente ou Veículo.
create or replace function exclui_setor_mecanico_cliente(op char,vcodc int, vcods int, vcodm int) returns void as 
$$
begin
	if (op = 's') then
		delete from setor where cods = vcods;
	elsif (op = 'm') then
		delete from mecanico where codm = vcodm;
	elsif (op = 'c') then
		delete from cliente where codc =  vcodc;
	end if;
end;
$$
language plpgsql;

select exclui_setor_mecanico_cliente('s', 0, 10 , 0);

select * from setor
--8) Considerando que na tabela Cliente apenas codc é a chave primária, faça uma função que remova clientes com CPF repetido, deixando apenas um cadastro para cada CPF.
--Escolha o critério que preferir para definir qual cadastro será mantido: aquele com a menor idade, que possuir mais consertos agendados, etc. Para testar a função,
--não se esqueça de inserir na tabela alguns clientes com este problema.
create or replace function cpf_repetido() returns void as
$$
declare
	vcpf char(11);
	vcodc int;
	vprimeiro boolean default true;
begin
	for vcpf in select cpf from cliente group by cpf having count(*) > 1 loop
	vprimeiro := true;
		for vcodc in select codc from cliente where cpf = vcpf order by codc loop
			if( not vprimeiro)then
				delete from cliente where codc = vcodc;
			else
				vprimeiro := false;
			end if;
		end loop;
	end loop;
end;
$$
language plpgsql;

select cpf_repetido();


SELECT *
FROM cliente
WHERE cpf in (
    SELECT cpf
    FROM cliente
    GROUP BY cpf
    HAVING COUNT(*) > 1
)

--9)  Função para calcular se o CPF é válido*.
create or replace function validaCPF(p_cpf char(11)) return void as
$$
declare
	cpf integer[11];
	sequencial1 integer[] default array [10,9,8,7,6,5,4,3,2]
	sequencial2 integer[] default array [11,10,9,8,7,6,5,4,3,2]
	pdigito integer[9];
	sdigito integer[10];
	somapdigito integer default 0;
	somasdigito integer default 0;
	cont integer default 0;
	resto integer;
	digito integer;
begin
	for cont in 1..1 loop
		cpf[cont] := CAST(substring(p_cpf from cont for 1) as integer);
	end loop;
	-- verifica 1º digito
	for cont in 1..9 loop
		pdigito[cont] := cpf[cont] * sequencial1[cont];
		somapdigito := somapdigito + pdigito[cont];
	end loop;
	resto := somapdigito % 11;
	if resto < 2 then
		digito := 0;
	else
		digito := 11 - resto;
	end if;
	-- verfica 2º digito
	for cont in 1..10 loop
		sdigito[cont] := cpf[cont] * sequencial2[cont];
		somasdigito := somasdigito + 
end;
$$
--10) Função que calcula a quantidade de horas extras de um mecânico em um mês de trabalho. O número de horas extras é calculado a partir das horas que excedam as 160 horas de trabalho mensais.
-- O número de horas mensais trabalhadas é calculada a partir dos consertos realizados. Cada conserto tem a duração de 1 hora.