--(a) matrículas e os nomes completos de todos os componentes, na forma de comentários

--Nome: Lucas Caltabiano Matricula: 112800305
--Nome: Christoph Califice Matricula: 121048060


/*
(b) o conjunto completo de comandos SQL de criação (CREATE TABLE) e alteração
(ALTER TABLE) das tabelas, com todas as restrições de integridade correspondentes
(primary key, unique, foreign key, check constraint)
*/

CREATE TABLE usuario
(
  user_id number(10) NOT NULL,
  user_name varchar2(40) NOT NULL,
  nome varchar2(50) NOT NULL,
  sobrenome varchar2(50) NOT NULL,
  email varchar2(80) NOT NULL,
  idade number(10),
  data_nasc date not null,

  CONSTRAINT usuario_PK PRIMARY KEY (user_id),
  CONSTRAINT usuario_unique UNIQUE (user_name),
  CONSTRAINT check_idade CHECK (idade BETWEEN 16 and 99),
  CONSTRAINT check_email CHECK (email like '%@%')

);

CREATE TABLE personagem
(
  personagem_id number(10) NOT NULL,
  classe varchar2(20) NOT NULL,
  raca varchar2(20) NOT NULL,
  hp number(10),
  sp number(10),
  user_id number(10),
  mapa_id number(10),
  arma_id number(10),
  nivel number(10) NOT NULL,
  defesa number(10) default 1 not null,

  CONSTRAINT personagem_pk PRIMARY KEY (personagem_id),
  CONSTRAINT check_classe CHECK (classe in ('ARQUEIRO','FEITICEIRO','TEMPLARIO','TRAPACEIRO')),
  CONSTRAINT check_raca CHECK (raca in ('HUMANO','ORC','ELFO','DRAGONIANO', 'GOBLIN'))

);

CREATE TABLE arma
(
  arma_id number(10) NOT NULL,
  nome varchar2(50) NOT NULL,
  tipo varchar2(20) NOT NULL,
  dano_base number(10) NOT NULL,

  CONSTRAINT armas_PK PRIMARY KEY (arma_id),
  CONSTRAINT nome_unique UNIQUE (nome),
  CONSTRAINT check_tipo_ar CHECK (tipo in ('CAJADO','ESPADA','MAÇA','ADAGA', 'ARCO')),
  CONSTRAINT check_dano_ar CHECK (dano_base > 0)

);

CREATE TABLE habilidade
(
  habilidade_id number(10) NOT NULL,
  nome varchar2(40) NOT NULL,
  propriedade varchar2(20) NOT NULL,
  valor_base number(10),
  descricao varchar2(200) NOT NULL,
  custo number(10) NOT NULL,

  CONSTRAINT habilidade_PK PRIMARY KEY (habilidade_id),
  CONSTRAINT nome_unique_hab UNIQUE (nome),
  CONSTRAINT check_propriedade_hab CHECK (propriedade in ('FOGO','GELO','NEUTRO','VENTO', 'TERRA', 'STATUS', 'CURA')),
  CONSTRAINT check_valor_hab CHECK (valor_base >= 0)

);

CREATE TABLE item
(
  item_id number(10) NOT NULL,
  tipo varchar2(20) NOT NULL,
  valor_base number(10) NOT NULL,
  nome varchar2(50) NOT NULL,
  defesa number(10),
  equipa_em varchar2(20),
  
  
  CONSTRAINT item_PK PRIMARY KEY (item_id),
  CONSTRAINT check_tipo_item CHECK (tipo in ('CONSUMIVEL','OUTROS','ESCUDO','VESTIMENTA','CALÇADOS','CAPACETE', 'CAPA', 'ARMADURA', 'CHAPEU')),
  CONSTRAINT check_equipa_em CHECK (equipa_em in ('MAO','CABECA','PES','CORPO','PERNA','ACESSORIO'))
);

CREATE TABLE npc
(
  npc_id number(10) NOT NULL,
  tipo varchar2(20) NOT NULL,
  nome varchar2(50) NOT NULL,
  hp number(10),
  sp number(10),
  nivel number(10) not null,
  
  CONSTRAINT npc_pk PRIMARY KEY (npc_id),
  CONSTRAINT check_tipo_npc CHECK (tipo in ('INIMIGO','ALIADO', 'NEUTRO'))


);

CREATE TABLE mapa
(
  mapa_id number(10) NOT NULL,
  nome varchar2(50) NOT NULL,
  tamanho varchar2(30) NOT NULL,
  tipo varchar2(20) NOT NULL,
  
  CONSTRAINT mapa_id PRIMARY KEY (mapa_id),
  CONSTRAINT check_tipo_mapa CHECK (tipo in ('CIDADE','CAMPO', 'CALABOUCO'))
  
);


CREATE TABLE personagem_habilidade
(
  habilidade_id number(10) NOT NULL,
  personagem_id number(10) NOT NULL

);


CREATE TABLE personagem_item
(
  item_id number(10) NOT NULL,
  personagem_id number(10) NOT NULL,
  quantidade number(10) NOT NULL

);

CREATE TABLE npc_mapa
(
  npc_id number(10) NOT NULL,
  mapa_id number(10) NOT NULL

);

ALTER TABLE personagem ADD CONSTRAINT personagem_usuario_fk FOREIGN KEY (user_id) REFERENCES usuario(user_id);
ALTER TABLE personagem ADD CONSTRAINT personagem_mapa_fk FOREIGN KEY (mapa_id) REFERENCES mapa(mapa_id);
ALTER TABLE personagem ADD CONSTRAINT personagem_arma_fk FOREIGN KEY (arma_id) REFERENCES arma(arma_id);

ALTER TABLE personagem_habilidade ADD CONSTRAINT personagem_hab_fk FOREIGN KEY (personagem_id) REFERENCES personagem(personagem_id);
ALTER TABLE personagem_habilidade ADD CONSTRAINT habilidade_fk FOREIGN KEY (habilidade_id) REFERENCES habilidade(habilidade_id);
ALTER TABLE personagem_habilidade ADD CONSTRAINT personagem_habilidade_unique UNIQUE (personagem_id,habilidade_id);

ALTER TABLE personagem_item ADD CONSTRAINT personagem_item_fk FOREIGN KEY (personagem_id) REFERENCES personagem(personagem_id);
ALTER TABLE personagem_item ADD CONSTRAINT item_fk FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE personagem_item ADD CONSTRAINT personagem_item_unique UNIQUE (personagem_id, item_id);

ALTER TABLE npc_mapa ADD CONSTRAINT npc_fk FOREIGN KEY (npc_id) REFERENCES npc(npc_id);
ALTER TABLE npc_mapa ADD CONSTRAINT mapa_fk FOREIGN KEY (mapa_id) REFERENCES mapa(mapa_id);


/*
(c) o conjunto completo de comandos de criação dos gatilhos (logo após cada tabela
respectiva, ou em bloco)
*/

--3 trigger tipo before e for each row

CREATE OR REPLACE TRIGGER update_hp_sp
BEFORE INSERT OR UPDATE
   ON personagem
   FOR EACH ROW

DECLARE

  vHPBase number;
  vSPBase number;

BEGIN

  if UPDATING THEN

    :new.classe := :old.classe;
    :new.raca := :old.raca;
    :new.personagem_id := :old.personagem_id;
    :new.user_id := :old.user_id;

  end if;

  if :new.classe = 'ARQUEIRO' THEN
    vHPBase := 200;
    vSPBase := 100;
  elsif :new.classe = 'FEITICEIRO' THEN
    vHPBase := 150;
    vSPBase := 130;
  elsif :new.classe = 'TEMPLARIO' THEN
    vHPBase := 400;
    vSPBase := 80;
  elsif :new.classe = 'TRAPACEIRO' THEN
    vHPBase := 300;
    vSPBase := 90;
  end if; 

  if :new.classe = 'HUMANO' THEN
    vHPBase := vHPBase * 1;
    vSPBase := vSPBase * 1;
  elsif :new.classe = 'ORC' THEN
    vHPBase := vHPBase * 1.25;
    vSPBase := vSPBase * 1.1 ;
  elsif :new.classe = 'ELFO' THEN
    vHPBase := vHPBase * 0.9 ;
    vSPBase := vSPBase * 1.5 ;
  elsif :new.classe = 'DRAGONIANOS' THEN
    vHPBase := vHPBase * 1.30 ;
    vSPBase := vSPBase * 0.7 ;
  elsif :new.classe = 'GOBLIN' THEN
    vHPBase := vHPBase * 1.15;
    vSPBase := vSPBase * 0.8;
  END IF;

  if INSERTING THEN
    :new.hp := vHPBase;
    :new.sp := vSPBase;
  ELSE
    :new.hp := :old.hp + ((vHPBase * 0.10) * :new.nivel);
    :new.sp := :old.sp + ((vSPBase * 0.10) * :new.nivel);
  END IF;

END;
/

create or replace TRIGGER calcula_idade
before INSERT OR UPDATE
   ON usuario
   FOR EACH ROW
declare
  vIdade number;
BEGIN
  select to_number(trunc((months_between(sysdate, :new.data_nasc))/12))
    into vIdade
    from dual;
  :new.idade := vIdade;

END;
/

create or replace TRIGGER verifica_custo
before INSERT OR UPDATE
   ON personagem_habilidade
   FOR EACH ROW

DECLARE
  
  vCusto number;
  vSP number;

BEGIN

  select h.custo
    into vCusto
    from habilidade h
   where h.habilidade_id = :new.habilidade_id;

  select p.sp
    into vSP
    from personagem p
   where p.personagem_id = :new.personagem_id;

   if vCusto > vSP THEN

    Raise_Application_Error (-20343, 'Custo de habilidade maior que SP do personagem.');

   end if;
   
END;
/

--1 trigger tipo after - calcula hp/sp

create or replace TRIGGER verifica_qtd_item
AFTER INSERT OR UPDATE
   ON personagem_item
   FOR EACH ROW
   
BEGIN

	if :new.quantidade <= 0 then

	  delete 
		from personagem_item
	   where ITEM_ID = :new.item_id 
		 and PERSONAGEM_ID = :new.personagem_id;

	end if;
   
END;
/

create or replace TRIGGER calcula_defesa
AFTER INSERT OR UPDATE OR DELETE
   ON personagem_item
   FOR EACH ROW

BEGIN

  if INSERTING OR UPDATING THEN

    update personagem p
       set p.defesa = (select nvl(i.defesa, 0) from item i where i.item_id = :new.item_id) + p.defesa
       where p.personagem_id = :new.personagem_id;

  END IF; 

  if DELETING THEN

    update personagem p
       set p.defesa = p.defesa - (select nvl(i.defesa, 0) from item i where i.item_id = :old.item_id)
       where p.personagem_id = :old.personagem_id;
  end if;            

END;
/



--(d) o conjunto completo de comandos de inserção de dados. 


insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (1, 'paulo33', 'Paulo', 'Silva', 'paulosilv@gmail.com', to_date('04/23/1998', 'MM/DD/YYYY'));
insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (2, 'aninha.br', 'Ana', 'Oliveira', 'anaa94@uol.com.br', to_date('07/15/1994', 'MM/DD/YYYY'));
insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (3, 'victoras', 'Victor', 'Araújo Silva', 'victor.silva@terra.com.br', to_date('06/04/1985', 'MM/DD/YYYY'));


insert into arma (arma_id, nome, tipo, dano_base) values (1, 'Espada Larga', 'ESPADA', 10);
insert into arma (arma_id, nome, tipo, dano_base) values (2, 'Arco Longo', 'ARCO', 8);
insert into arma (arma_id, nome, tipo, dano_base) values (3, 'Cajado Branco', 'CAJADO', 3);

insert into personagem (personagem_id, classe, raca, user_id, nivel) values (5, 'ARQUEIRO', 'ELFO', 3, 1);
insert into personagem (personagem_id, classe, raca, user_id, nivel) values (8, 'TRAPACEIRO', 'GOBLIN', 2, 1);
insert into personagem (personagem_id, classe, raca, user_id, nivel, arma_id) values (7, 'TEMPLARIO', 'HUMANO', 1, 1, 1);

insert into habilidade (habilidade_id, nome, propriedade, valor_base, descricao, custo) 
values (9, 'Rajada de Flechas', 'NEUTRO', 5, 'Lança um intensa rajada de flechas contra o alvo.', 12);
insert into habilidade (habilidade_id, nome, propriedade, valor_base, descricao, custo) 
values (2, 'Apunhalar', 'NEUTRO', 15, 'Quando o alvo está de costas, remove 15% do HP total do alvo.', 20);
insert into habilidade (habilidade_id, nome, propriedade, valor_base, descricao, custo) 
values (23, 'Mão divina', 'STATUS', 30, 'Ataques constra monstros do tipo morto-vivo tem seu dano aumentado em 10%.', 25);
insert into habilidade (habilidade_id, nome, propriedade, valor_base, descricao, custo) 
values (1, 'Primeiros-socorros', 'NEUTRO', 5, 'Lança um intensa rajada de flechas contra o alvo.', 12);

insert into item (item_id, tipo, valor_base, nome) values (5, 'CONSUMIVEL', 4, 'Poção de cura menor');
insert into item (item_id, tipo, valor_base, nome, defesa, equipa_em) values (20, 'ESCUDO', 0, 'Escudo de Madeira', 20, 'MAO');
insert into item (item_id, tipo, valor_base, nome, defesa, equipa_em) values (98, 'CAPA', 0, 'Capa de Seda', 3, 'CORPO');
insert into item (item_id, tipo, valor_base, nome) values (12, 'CONSUMIVEL', 14, 'Poção da fúria');


insert into npc (npc_id, tipo, nome, hp, sp, nivel) values (40, 'NEUTRO', 'Isaias', 40, 0, 14);
insert into npc (npc_id, tipo, nome, hp, sp, nivel) values (43, 'INIMIGO', 'Zumbi', 120, 5, 4);
insert into npc (npc_id, tipo, nome, hp, sp, nivel) values (23, 'ALIADO', 'Soldado', 540, 50, 25);

insert into mapa (mapa_id, nome, tamanho, tipo) values (42, 'Caminho dos Mochileiros', '430x900', 'CAMPO');
insert into mapa (mapa_id, nome, tamanho, tipo) values (76, 'Caverna dos Esqueletos', '350x300', 'CALABOUCO');
insert into mapa (mapa_id, nome, tamanho, tipo) values (2, 'Faról de Andromeda', '500x300', 'CIDADE');

insert into personagem_habilidade (habilidade_id, personagem_id) values (9, 5);
insert into personagem_habilidade (habilidade_id, personagem_id) values (1, 5);
insert into personagem_habilidade (habilidade_id, personagem_id) values (1, 8);
insert into personagem_habilidade (habilidade_id, personagem_id) values (1, 7);
insert into personagem_habilidade (habilidade_id, personagem_id) values (23, 7);
insert into personagem_habilidade (habilidade_id, personagem_id) values (2, 8);


insert into npc_mapa (npc_id, mapa_id) values (40, 42);
insert into npc_mapa (npc_id, mapa_id) values (43, 76);
insert into npc_mapa (npc_id, mapa_id) values (23, 2);


insert into personagem_item (item_id, personagem_id, quantidade) values (12, 5, 15);
insert into personagem_item (item_id, personagem_id, quantidade) values (5, 5, 10);
insert into personagem_item (item_id, personagem_id, quantidade) values (98, 5, 1);
insert into personagem_item (item_id, personagem_id, quantidade) values (5, 7, 8);
insert into personagem_item (item_id, personagem_id, quantidade) values (5, 8, 15);
insert into personagem_item (item_id, personagem_id, quantidade) values (20, 7, 1);


commit;



--(e) as 2 consultas SQL.

/*
Consulta 1:
 Junção de pelo menos 4 tabelas
 Seleções PARA CADA UMA das tabelas;
 Orientações específicas:
- Filtrar registros em TODAS as tabelas;
- Seleções sobre colunas que não pertençam às chaves primárias das tabelas;
- Seleções por DESIGUALDADE (outros operadores do que a igualdade (=))
em pelo menos 2 tabelas. 
*/


SELECT u.user_name, u.idade, p.nivel, a.nome, a.dano_base, i.nome, pi.quantidade, i.valor_base FROM
usuario u inner join personagem p on u.user_id = p.user_id
inner join arma a on p.arma_id = a.arma_id
inner join personagem_item pi on pi.personagem_id = p.personagem_id
inner join item i on i.item_id = pi.item_id
where p.nivel < 15
and pi.quantidade >= 1
and upper(i.nome) like 'POÇÃO%'
and a.dano_base <> 0
and u.idade between 18 and 35;


/*
Consulta 2:
Consulta com sub-consulta;
Sub-consulta retorna pelo menos 1 valor por função de agregação;
Orientações específicas:
- ao menos 3 tabelas;
- Função de agregação na sub-consulta.
Exemplo:
select * from pedidos_produtos natural join pedidos
natural join produtos natural join fornecedores
where valor_unitário > (select avg(preço) from produtos);
*/


select  u.user_id
      , u.user_name
      , p.classe
      , p.raca
      , i.nome
      , pi.quantidade
 from usuario u inner join personagem p on u.user_id = p.user_id
inner join personagem_item pi on pi.personagem_id = p.personagem_id
inner join item i on pi.item_id = i.item_id
where pi.quantidade > (select round(avg(quantidade)) from personagem_item);
