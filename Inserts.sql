insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (1, 'paulo33', 'Paulo', 'Silva', 'paulosilv@gmail.com', to_date('04/23/1998', 'MM/DD/YYYY'));
insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (2, 'aninha.br', 'Ana', 'Oliveira', 'anaa94@uol.com.br', to_date('07/15/1994', 'MM/DD/YYYY'));
insert into usuario (user_id, user_name, nome, sobrenome, email, data_nasc)
values (3, 'victoras', 'Victor', 'Araújo Silva', 'victor.silva@terra.com.br', to_date('06/04/1985', 'MM/DD/YYYY'));


insert into personagem (personagem_id, classe, raca, user_id, nivel) values (5, 'ARQUEIRO', 'ELFO', 3, 1);
insert into personagem (personagem_id, classe, raca, user_id, nivel) values (8, 'TRAPACEIRO', 'GOBLIN', 2, 1);
insert into personagem (personagem_id, classe, raca, user_id, nivel) values (7, 'TEMPLARIO', 'HUMANO', 1, 1);

insert into arma (arma_id, nome, tipo, dano_base) values (1, 'Espada Larga', 'ESPADA', 10);
insert into arma (arma_id, nome, tipo, dano_base) values (2, 'Arco Longo', 'ARCO', 8);
insert into arma (arma_id, nome, tipo, dano_base) values (3, 'Cajado Branco', 'CAJADO', 3);


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
