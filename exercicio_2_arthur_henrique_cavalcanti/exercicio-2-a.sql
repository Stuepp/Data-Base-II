create table curral(
	numero int primary key,
	localizacao varchar(25)
);

create table tratamento(
	data_t int primary key,
	descricao varchar(25)
);

create table veterinario(
	crm int primary key,
	nome varchar(25),
	convenio varchar(25)
);

create table animal(
	id_animal int primary key,
	nome varchar(25),
	raca varchar(25),
	sexo char(1)
);

create table consulta(
	data_c date primary key,
	resultado varchar(25),
	fk_vet int,
	fk_animal int,
	foreign key(fk_vet) references veterinario,
	foreign key(fk_animal) references animal
);

create table matriz(
	id_matriz int primary key,
	inseminacao int,
	foreign key(inseminacao) references curral,
	foreign key(id_matriz) references animal
);

create table reprodutor(
	id_reprodutor int primary key,
	foreign key(id_reprodutor) references animal
);

create table cobertura (
	id_cobertura int primary key,
	fk_reprodutor int,
	fk_matriz int,
	foreign key(fk_reprodutor) references reprodutor,
	foreign key(fk_matriz) references matriz
);

create table adquirido(
	id_adquiro int primary key,
	nome_pai varchar(25),
	nome_mae varchar(25),
	valor int,
	foreign key(id_adquiro) references reprodutor
);

create table cria(
	id_cria int primary key,
	data_demame date,
	foreign key(id_cria) references reprodutor
);