--Nome: Lucas Caltabiano Matricula: 112800305
--Nome: Christoph Califice Matricula: 121048060

CREATE TABLE usuario
(
  user_id number(10) NOT NULL,
  user_name varchar2(50) NOT NULL,
  nome varchar2(50) NOT NULL,
  sobrenome varchar2(50) NOT NULL,
  email varchar2(50) NOT NULL,
  idade int,
  data_nasc date not null,

  CONSTRAINT usuario_PK PRIMARY KEY (user_id),
  CONSTRAINT usuario_unique UNIQUE (user_name),
  CONSTRAINT check_idade CHECK (idade BETWEEN 16 and 99),
  CONSTRAINT check_email CHECK (email like '%@%')

);

CREATE TABLE personagem
(
  personagem_id number(10) NOT NULL,
  classe varchar2(50) NOT NULL,
  raca varchar2(50) NOT NULL,
  hp int NOT NULL,
  sp int NOT NULL,
  user_id int,
  mapa_id int,
  arma_id int,

  CONSTRAINT personagem_pk PRIMARY KEY (personagem_id),
  CONSTRAINT check_classe CHECK (classe in ('ARQUEIRO','FEITICEIRO','TEMPLARIO','TRAPACEIRO')),
  CONSTRAINT check_raca CHECK (raca in ('Humano','Orc','Elfo','Dragonianos', 'Goblin'))

);

CREATE TABLE arma
(
  arma_id number(10) NOT NULL,
  nome varchar2(50) NOT NULL,
  tipo varchar2(50) NOT NULL,
  dano_base int NOT NULL,

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
  valor_base int,
  descricao varchar2(100) NOT NULL,
  custo int NOT NULL,

  CONSTRAINT habilidade_PK PRIMARY KEY (habilidade_id),
  CONSTRAINT nome_unique_hab UNIQUE (nome),
  CONSTRAINT check_propriedade_hab CHECK (propriedade in ('FOGO','GELO','NEUTRO','VENTO', 'TERRA', 'STATUS', 'CURA')),
  CONSTRAINT check_valor_hab CHECK (valor_base > 0)

);

CREATE TABLE item
(
  item_id number(10) NOT NULL,
  tipo varchar2(20) NOT NULL,
  valor_base int NOT NULL,
  nome varchar2(50) NOT NULL,
  ataque int,
  defesa int,
  equipa_em varchar2(20),
  
  
  CONSTRAINT item_PK PRIMARY KEY (item_id),
  CONSTRAINT check_tipo_item CHECK (tipo in ('CONSUMIVEL','OUTROS','ESCUDO','VESTIMENTA','CALÇADOS','CAPACETE', 'CAPA')),
  CONSTRAINT check_equipa_em CHECK (equipa_em in ('MÃO','CABEÇA','PÉS','CORPO','PERNA','ACESSORIO'))
);

CREATE TABLE npc
(
  npc_id number(10) NOT NULL,
  tipo varchar2(50) NOT NULL,
  nome varchar2(50) NOT NULL,
  hp int,
  sp int,
  nivel int not null,
  
  CONSTRAINT npc_pk PRIMARY KEY (npc_id),
  CONSTRAINT check_tipo_npc CHECK (tipo in ('INIMIGO','ALIADO', 'NEUTRO'))


);

CREATE TABLE mapa
(
  mapa_id number(10) NOT NULL,
  nome varchar2(50) NOT NULL,
  tamanho varchar2(30) NOT NULL,
  tipo varchar2(30) NOT NULL,
  
  CONSTRAINT mapa_id PRIMARY KEY (mapa_id),
  CONSTRAINT check_tipo_mapa CHECK (tipo in ('CIDADE','CAMPO', 'CALABOUÇO'))
  
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
  quantidade int NOT NULL

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

ALTER TABLE personagem_item ADD CONSTRAINT personagem_item_fk FOREIGN KEY (personagem_id) REFERENCES personagem(personagem_id);
ALTER TABLE personagem_item ADD CONSTRAINT item_fk FOREIGN KEY (item_id) REFERENCES item(item_id);

ALTER TABLE npc_mapa ADD CONSTRAINT npc_fk FOREIGN KEY (npc_id) REFERENCES npc(npc_id);
ALTER TABLE npc_mapa ADD CONSTRAINT mapa_fk FOREIGN KEY (mapa_id) REFERENCES mapa(mapa_id);

--1 trigger tipo after - calcula hp/sp

CREATE OR REPLACE TRIGGER update_hp_sp
AFTER INSERT OR UPDATE
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

--3 trigger tipo before e for each row

CREATE OR REPLACE TRIGGER calcula_idade
before INSERT OR UPDATE
   ON usuario
   FOR EACH ROW

BEGIN

  :new.idade := trunc((months_between(sysdate, :new.idade))/12);

END;

/

CREATE OR REPLACE TRIGGER verifica_custo
before INSERT OR UPDATE
   ON personagem_habilidade
   FOR EACH ROW

DECLARE
  
  vCusto int;
  vSP int;

BEGIN

  select h.custo
    into vCustom
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